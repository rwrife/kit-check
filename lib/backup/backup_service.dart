import 'package:kit_check/backup/backup_document.dart';
import 'package:kit_check/domain/models.dart';
import 'package:kit_check/persistence/kit_check_repository.dart';

/// How to treat a record in a backup whose id already exists locally.
enum RestoreConflictResolution {
  /// Keep the local record and ignore the backed-up version.
  keepLocal,

  /// Overwrite the local record with the backed-up version.
  overwrite,
}

/// What to do with local data that is *not* mentioned in the backup.
enum RestoreMode {
  /// Keep local records whose ids are not in the backup.
  merge,

  /// Delete every local kit and trip first (the backup becomes the whole
  /// dataset). Deletion only happens after the caller confirms the preview.
  replaceAll,
}

/// A preview of what a restore would change. Produced by
/// [BackupService.previewRestore] and shown to the user before anything is
/// written.
class RestorePlan {
  RestorePlan({
    required List<String> newKitIds,
    required List<String> conflictingKitIds,
    required List<String> newTripIds,
    required List<String> conflictingTripIds,
    required this.localKitCount,
    required this.localTripCount,
  }) : newKitIds = List<String>.unmodifiable(newKitIds),
       conflictingKitIds = List<String>.unmodifiable(conflictingKitIds),
       newTripIds = List<String>.unmodifiable(newTripIds),
       conflictingTripIds = List<String>.unmodifiable(conflictingTripIds);

  final List<String> newKitIds;
  final List<String> conflictingKitIds;
  final List<String> newTripIds;
  final List<String> conflictingTripIds;
  final int localKitCount;
  final int localTripCount;

  bool get hasConflicts =>
      conflictingKitIds.isNotEmpty || conflictingTripIds.isNotEmpty;

  int get totalIncoming =>
      newKitIds.length +
      conflictingKitIds.length +
      newTripIds.length +
      conflictingTripIds.length;
}

/// Counts reported after a restore has been applied.
class RestoreSummary {
  RestoreSummary({
    required this.kitsInserted,
    required this.kitsOverwritten,
    required this.kitsKeptLocal,
    required this.tripsInserted,
    required this.tripsOverwritten,
    required this.tripsKeptLocal,
    required this.localDataCleared,
  });

  final int kitsInserted;
  final int kitsOverwritten;
  final int kitsKeptLocal;
  final int tripsInserted;
  final int tripsOverwritten;
  final int tripsKeptLocal;
  final bool localDataCleared;
}

/// Orchestrates export, restore preview, restore, and data deletion on top of
/// a [KitCheckRepository].
///
/// Restore is a two-phase operation by design: callers must obtain a
/// [RestorePlan] via [previewRestore], present it to the user, and only then
/// call [applyRestore] with `userConfirmed: true`. Passing `false` (or
/// forgetting to preview) never touches stored data.
class BackupService {
  BackupService(this._repository);

  final KitCheckRepository _repository;

  /// Capture every user-owned kit and trip as a versioned backup document.
  Future<BackupDocument> exportBackup() async {
    final kits = await _repository.loadKits(includeArchived: true);
    final trips = await _repository.loadTrips();
    return BackupDocument(kits: kits, trips: trips);
  }

  /// Encode the backup as the documented versioned JSON string.
  Future<String> exportBackupJson({DateTime? exportedAt}) async {
    final document = await exportBackup();
    return BackupCodec.encode(document, exportedAt: exportedAt);
  }

  /// Compare a decoded backup against local data without writing anything.
  Future<RestorePlan> previewRestore(BackupDocument document) async {
    final localKits = await _repository.loadKits();
    final localTrips = await _repository.loadTrips();

    final localKitIds = localKits.map((kit) => kit.id.value).toSet();
    final localTripIds = localTrips.map((trip) => trip.id.value).toSet();

    final newKitIds = <String>[];
    final conflictingKitIds = <String>[];
    for (final kit in document.kits) {
      (localKitIds.contains(kit.id.value) ? conflictingKitIds : newKitIds).add(
        kit.id.value,
      );
    }

    final newTripIds = <String>[];
    final conflictingTripIds = <String>[];
    for (final trip in document.trips) {
      (localTripIds.contains(trip.id.value) ? conflictingTripIds : newTripIds)
          .add(trip.id.value);
    }

    return RestorePlan(
      newKitIds: newKitIds,
      conflictingKitIds: conflictingKitIds,
      newTripIds: newTripIds,
      conflictingTripIds: conflictingTripIds,
      localKitCount: localKits.length,
      localTripCount: localTrips.length,
    );
  }

  /// Apply a restore. The caller must have shown the preview from
  /// [previewRestore] and obtained an explicit user confirmation; otherwise
  /// this throws a [StateError] and changes nothing.
  Future<RestoreSummary> applyRestore(
    BackupDocument document, {
    required bool userConfirmed,
    RestoreMode mode = RestoreMode.merge,
    RestoreConflictResolution conflictResolution =
        RestoreConflictResolution.keepLocal,
  }) async {
    if (!userConfirmed) {
      throw StateError(
        'Restore requires explicit user confirmation after reviewing the '
        'conflict preview.',
      );
    }

    var localDataCleared = false;
    if (mode == RestoreMode.replaceAll) {
      await _repository.clearAllData();
      localDataCleared = true;
    }

    var kitsInserted = 0;
    var kitsOverwritten = 0;
    var kitsKeptLocal = 0;
    var tripsInserted = 0;
    var tripsOverwritten = 0;
    var tripsKeptLocal = 0;

    final existingKitIds = localDataCleared
        ? <String>{}
        : (await _repository.loadKits()).map((kit) => kit.id.value).toSet();
    final existingTripIds = localDataCleared
        ? <String>{}
        : (await _repository.loadTrips()).map((trip) => trip.id.value).toSet();

    for (final kit in document.kits) {
      if (existingKitIds.contains(kit.id.value)) {
        if (conflictResolution == RestoreConflictResolution.overwrite) {
          await _repository.saveKit(kit);
          kitsOverwritten += 1;
        } else {
          kitsKeptLocal += 1;
        }
      } else {
        await _repository.saveKit(kit);
        kitsInserted += 1;
      }
    }

    for (final trip in document.trips) {
      if (existingTripIds.contains(trip.id.value)) {
        if (conflictResolution == RestoreConflictResolution.overwrite) {
          await _repository.saveTrip(trip);
          tripsOverwritten += 1;
        } else {
          tripsKeptLocal += 1;
        }
      } else {
        await _repository.saveTrip(trip);
        tripsInserted += 1;
      }
    }

    return RestoreSummary(
      kitsInserted: kitsInserted,
      kitsOverwritten: kitsOverwritten,
      kitsKeptLocal: kitsKeptLocal,
      tripsInserted: tripsInserted,
      tripsOverwritten: tripsOverwritten,
      tripsKeptLocal: tripsKeptLocal,
      localDataCleared: localDataCleared,
    );
  }

  /// Delete every locally stored kit and trip. There is no undo; callers must
  /// present a confirmation flow first.
  Future<void> deleteAllData() => _repository.clearAllData();

  /// Render trip history as RFC 4180 CSV. See docs/backup-and-export.md for
  /// the documented column contract. Contains only user-owned kit/trip data.
  Future<String> exportHistoryCsv() async {
    final trips = await _repository.loadTrips();
    final buffer = StringBuffer()
      ..writeln(
        'trip_id,trip_name,kit_name,'
        'started_on_utc,item_id,item_name,item_status,omission_note',
      );

    for (final trip in trips) {
      if (trip.items.isEmpty) {
        buffer.writeln(
          _csvRow(<String>[
            trip.id.value,
            trip.tripName,
            trip.kitName,
            trip.startedOn.toUtc().toIso8601String(),
            '',
            '',
            '',
            '',
          ]),
        );
        continue;
      }
      for (final item in trip.items) {
        buffer.writeln(
          _csvRow(<String>[
            trip.id.value,
            trip.tripName,
            trip.kitName,
            trip.startedOn.toUtc().toIso8601String(),
            item.itemId.value,
            item.itemName,
            _statusName(item.status),
            item.omissionNote ?? '',
          ]),
        );
      }
    }

    return buffer.toString();
  }

  static String _statusName(ChecklistStatus status) {
    return switch (status) {
      ChecklistStatus.pending => 'pending',
      ChecklistStatus.packed => 'packed',
      ChecklistStatus.omitted => 'omitted',
      ChecklistStatus.returned => 'returned',
    };
  }

  /// Quote fields per RFC 4180 so commas/newlines/quotes survive a round
  /// trip through spreadsheet tools.
  static String _csvField(String value) {
    if (value.contains(RegExp('[",\n\r]'))) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String _csvRow(List<String> fields) {
    return fields.map(_csvField).join(',');
  }
}
