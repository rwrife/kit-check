import 'dart:convert';

import 'package:kit_check/domain/models.dart';

/// Current schema version emitted by this build of Kit Check.
///
/// Version history:
/// - 1: initial format (kits with categories/items, trips with checklist
///   snapshot items). Timestamps are epoch milliseconds in UTC.
const int backupSchemaVersion = 1;

/// The only accepted value for the `app` field of a backup document.
const String backupAppId = 'kit_check';

/// Thrown when a backup payload is structurally or semantically invalid.
///
/// All restore paths validate a payload fully (via [BackupCodec.decode])
/// *before* any data is written, so a thrown exception means no local data
/// was touched.
class BackupValidationException implements Exception {
  BackupValidationException(this.message);

  final String message;

  @override
  String toString() => 'BackupValidationException: $message';
}

/// A fully validated, in-memory backup of all user-owned kit and trip data.
class BackupDocument {
  BackupDocument({
    required List<KitTemplate> kits,
    required List<TripChecklistSnapshot> trips,
    this.exportedAt,
  }) : kits = List<KitTemplate>.unmodifiable(kits),
       trips = List<TripChecklistSnapshot>.unmodifiable(trips);

  final List<KitTemplate> kits;
  final List<TripChecklistSnapshot> trips;

  /// Wall-clock export time (UTC) when produced by this app; `null` when the
  /// document came from a user-supplied file that omitted it.
  final DateTime? exportedAt;
}

/// Encodes and decodes the versioned JSON backup format.
///
/// The documented shape (schema version 1) is:
///
/// ```json
/// {
///   "schemaVersion": 1,
///   "app": "kit_check",
///   "exportedAt": "2026-01-01T00:00:00.000Z",
///   "kits": [
///     {
///       "id": "kit-1",
///       "name": "Weekend Kit",
///       "isArchived": false,
///       "categories": [ { "id": "cat-1", "name": "Clothes", "sortOrder": 0 } ],
///       "items": [
///         {
///           "id": "item-1", "name": "Socks", "quantity": 3, "note": null,
///           "categoryId": "cat-1", "sortOrder": 0
///         }
///       ]
///     }
///   ],
///   "trips": [
///     {
///       "id": "trip-1",
///       "kitId": "kit-1",
///       "kitName": "Weekend Kit",
///       "tripName": "Seattle Weekend",
///       "tripNote": null,
///       "startedOnMs": 1767225600000,
///       "items": [
///         {
///           "itemId": "item-1", "itemName": "Socks", "quantity": 3,
///           "note": null, "categoryName": "Clothes", "status": "omitted",
///           "omissionNote": "Laundry not finished"
///         }
///       ]
///     }
///   ]
/// }
/// ```
///
/// `startedOnMs` is milliseconds since the Unix epoch, interpreted as UTC.
/// `status` is one of `pending`, `packed`, `omitted`, `returned`. Omitted
/// items must carry a non-empty `omissionNote`; every other status must
/// leave it `null`.
class BackupCodec {
  BackupCodec._();

  static String encode(BackupDocument document, {DateTime? exportedAt}) {
    final timestamp =
        exportedAt ?? document.exportedAt ?? DateTime.now().toUtc();

    return const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      'schemaVersion': backupSchemaVersion,
      'app': backupAppId,
      'exportedAt': timestamp.toUtc().toIso8601String(),
      'kits': document.kits.map(_kitToJson).toList(growable: false),
      'trips': document.trips.map(_tripToJson).toList(growable: false),
    });
  }

  /// Parses and fully validates [source]. Throws
  /// [BackupValidationException] with a field-path message on any problem.
  static BackupDocument decode(String source) {
    Object? parsed;
    try {
      parsed = jsonDecode(source);
    } on FormatException catch (error) {
      throw BackupValidationException('Invalid JSON: ${error.message}');
    }

    final root = _requireMap(parsed, 'root');

    final schemaVersion = _requireInt(
      root['schemaVersion'],
      'schemaVersion',
      'root',
    );
    if (schemaVersion != backupSchemaVersion) {
      throw BackupValidationException(
        'Unsupported schemaVersion $schemaVersion: this build supports '
        'version $backupSchemaVersion only',
      );
    }

    final app = _requireString(root['app'], 'app', 'root', allowEmpty: false);
    if (app != backupAppId) {
      throw BackupValidationException('Unknown backup app identifier: $app');
    }

    final exportedAtRaw = root['exportedAt'];
    DateTime? exportedAt;
    if (exportedAtRaw != null) {
      final text = _requireString(
        exportedAtRaw,
        'exportedAt',
        'root',
        allowEmpty: false,
      );
      final parsedTime = DateTime.tryParse(text);
      if (parsedTime == null) {
        throw BackupValidationException('root.exportedAt is not a valid date');
      }
      exportedAt = parsedTime.toUtc();
    }

    final kitsRaw = _requireList(root['kits'], 'kits');
    final tripsRaw = _requireList(root['trips'], 'trips');

    final kitIds = <String>{};
    final kits = <KitTemplate>[];
    for (var index = 0; index < kitsRaw.length; index += 1) {
      final kit = _kitFromMap(_requireMap(kitsRaw[index], 'kits[$index]'));
      if (!kitIds.add(kit.id.value)) {
        throw BackupValidationException('Duplicate kit id: ${kit.id.value}');
      }
      kits.add(kit);
    }

    final tripIds = <String>{};
    final trips = <TripChecklistSnapshot>[];
    for (var index = 0; index < tripsRaw.length; index += 1) {
      final trip = _tripFromMap(
        _requireMap(tripsRaw[index], 'trips[$index]'),
        path: 'trips[$index]',
      );
      if (!tripIds.add(trip.id.value)) {
        throw BackupValidationException('Duplicate trip id: ${trip.id.value}');
      }
      trips.add(trip);
    }

    return BackupDocument(kits: kits, trips: trips, exportedAt: exportedAt);
  }

  static Map<String, Object?> _kitToJson(KitTemplate kit) {
    return <String, Object?>{
      'id': kit.id.value,
      'name': kit.name,
      'isArchived': kit.isArchived,
      'categories': kit.categories
          .map(
            (category) => <String, Object?>{
              'id': category.id.value,
              'name': category.name,
              'sortOrder': category.sortOrder,
            },
          )
          .toList(growable: false),
      'items': kit.items
          .map(
            (item) => <String, Object?>{
              'id': item.id.value,
              'name': item.name,
              'quantity': item.quantity,
              'note': item.note,
              'categoryId': item.categoryId?.value,
              'sortOrder': item.sortOrder,
            },
          )
          .toList(growable: false),
    };
  }

  static Map<String, Object?> _tripToJson(TripChecklistSnapshot trip) {
    return <String, Object?>{
      'id': trip.id.value,
      'kitId': trip.kitId.value,
      'kitName': trip.kitName,
      'tripName': trip.tripName,
      'tripNote': trip.tripNote,
      'startedOnMs': trip.startedOn.toUtc().millisecondsSinceEpoch,
      'items': trip.items
          .map(
            (item) => <String, Object?>{
              'itemId': item.itemId.value,
              'itemName': item.itemName,
              'quantity': item.quantity,
              'note': item.note,
              'categoryName': item.categoryName,
              'status': _encodeStatus(item.status),
              'omissionNote': item.omissionNote,
            },
          )
          .toList(growable: false),
    };
  }

  static KitTemplate _kitFromMap(Map<String, Object?> map) {
    const path = 'kits';
    final id = _requireString(map['id'], 'id', path, allowEmpty: false);
    final name = _requireString(map['name'], 'name', path, allowEmpty: false);
    final isArchived = map['isArchived'] == null
        ? false
        : _requireBool(map['isArchived'], 'isArchived', path);

    final categoryIds = <String>{};
    final categories = <KitCategory>[];
    for (final raw in _requireList(map['categories'], '$path.categories')) {
      final categoryPath = '$path.categories';
      final category = _requireMap(raw, categoryPath);
      final categoryId = _requireString(
        category['id'],
        'id',
        categoryPath,
        allowEmpty: false,
      );
      if (!categoryIds.add(categoryId)) {
        throw BackupValidationException(
          '$categoryPath: duplicate category id $categoryId',
        );
      }
      categories.add(
        KitCategory(
          id: CategoryId(categoryId),
          name: _requireString(
            category['name'],
            'name',
            categoryPath,
            allowEmpty: false,
          ),
          sortOrder: _requireNonNegativeInt(
            category['sortOrder'],
            'sortOrder',
            categoryPath,
          ),
        ),
      );
    }

    final itemIds = <String>{};
    final items = <KitItemTemplate>[];
    for (final raw in _requireList(map['items'], '$path.items')) {
      final itemPath = '$path.items';
      final item = _requireMap(raw, itemPath);
      final itemId = _requireString(
        item['id'],
        'id',
        itemPath,
        allowEmpty: false,
      );
      if (!itemIds.add(itemId)) {
        throw BackupValidationException('$itemPath: duplicate item id $itemId');
      }
      final categoryId = _requireNullableString(
        item['categoryId'],
        'categoryId',
        itemPath,
      );
      if (categoryId != null && !categoryIds.contains(categoryId)) {
        throw BackupValidationException(
          '$itemPath: categoryId $categoryId does not exist in kit $id',
        );
      }

      items.add(
        KitItemTemplate(
          id: ItemId(itemId),
          name: _requireString(
            item['name'],
            'name',
            itemPath,
            allowEmpty: false,
          ),
          quantity: _requireNullableNonNegativeInt(
            item['quantity'],
            'quantity',
            itemPath,
          ),
          note: _requireNullableString(item['note'], 'note', itemPath),
          categoryId: categoryId == null ? null : CategoryId(categoryId),
          sortOrder: _requireNonNegativeInt(
            item['sortOrder'],
            'sortOrder',
            itemPath,
          ),
        ),
      );
    }

    return KitTemplate(
      id: KitId(id),
      name: name,
      categories: categories,
      items: items,
      isArchived: isArchived,
    );
  }

  static TripChecklistSnapshot _tripFromMap(
    Map<String, Object?> map, {
    required String path,
  }) {
    final itemIds = <String>{};
    final items = <ChecklistItemSnapshot>[];
    final rawItems = _requireList(map['items'], '$path.items');
    for (var index = 0; index < rawItems.length; index += 1) {
      final raw = rawItems[index];
      final itemPath = '$path.items[$index]';
      final item = _requireMap(raw, itemPath);
      final itemId = _requireString(
        item['itemId'],
        'itemId',
        itemPath,
        allowEmpty: false,
      );
      if (!itemIds.add(itemId)) {
        throw BackupValidationException(
          '$path: duplicate item id $itemId in trip checklist',
        );
      }

      final status = _decodeStatus(
        _requireString(item['status'], 'status', itemPath, allowEmpty: false),
        itemPath,
      );
      final omissionNote = _requireNullableString(
        item['omissionNote'],
        'omissionNote',
        itemPath,
      );
      final normalizedOmission = omissionNote?.trim();
      if (status == ChecklistStatus.omitted) {
        if (normalizedOmission == null || normalizedOmission.isEmpty) {
          throw BackupValidationException(
            '$itemPath: omitted items require a non-empty omissionNote',
          );
        }
      } else if (normalizedOmission != null && normalizedOmission.isNotEmpty) {
        throw BackupValidationException(
          '$itemPath: only omitted items may carry an omissionNote',
        );
      }

      items.add(
        ChecklistItemSnapshot(
          itemId: ItemId(itemId),
          itemName: _requireString(
            item['itemName'],
            'itemName',
            itemPath,
            allowEmpty: false,
          ),
          quantity: _requireNullableNonNegativeInt(
            item['quantity'],
            'quantity',
            itemPath,
          ),
          note: _requireNullableString(item['note'], 'note', itemPath),
          categoryName: _requireNullableString(
            item['categoryName'],
            'categoryName',
            itemPath,
          ),
          status: status,
          omissionNote: status == ChecklistStatus.omitted
              ? normalizedOmission
              : null,
        ),
      );
    }

    final startedOnMs = _requireInt(map['startedOnMs'], 'startedOnMs', path);

    return TripChecklistSnapshot(
      id: TripId(_requireString(map['id'], 'id', path, allowEmpty: false)),
      kitId: KitId(
        _requireString(map['kitId'], 'kitId', path, allowEmpty: false),
      ),
      kitName: _requireString(
        map['kitName'],
        'kitName',
        path,
        allowEmpty: false,
      ),
      tripName: _requireString(
        map['tripName'],
        'tripName',
        path,
        allowEmpty: false,
      ),
      tripNote: _requireNullableString(map['tripNote'], 'tripNote', path),
      startedOn: DateTime.fromMillisecondsSinceEpoch(startedOnMs, isUtc: true),
      items: items,
    );
  }

  static String _encodeStatus(ChecklistStatus status) {
    return switch (status) {
      ChecklistStatus.pending => 'pending',
      ChecklistStatus.packed => 'packed',
      ChecklistStatus.omitted => 'omitted',
      ChecklistStatus.returned => 'returned',
    };
  }

  static ChecklistStatus _decodeStatus(String value, String path) {
    return switch (value) {
      'pending' => ChecklistStatus.pending,
      'packed' => ChecklistStatus.packed,
      'omitted' => ChecklistStatus.omitted,
      'returned' => ChecklistStatus.returned,
      _ => throw BackupValidationException('$path: unknown status $value'),
    };
  }

  static Map<String, Object?> _requireMap(Object? value, String path) {
    // jsonDecode produces Map<String, dynamic>; accept it as the loose
    // object form and retype to Map<String, Object?>.
    if (value is Map<String, dynamic>) {
      return Map<String, Object?>.from(value);
    }
    throw BackupValidationException('$path: expected a JSON object');
  }

  static List<Object?> _requireList(Object? value, String path) {
    if (value is List<Object?>) {
      return value;
    }
    throw BackupValidationException('$path: expected a JSON array');
  }

  static String _requireString(
    Object? value,
    String field,
    String path, {
    required bool allowEmpty,
  }) {
    if (value is! String) {
      throw BackupValidationException('$path.$field: expected a string');
    }
    if (!allowEmpty && value.trim().isEmpty) {
      throw BackupValidationException('$path.$field: must not be empty');
    }
    return value;
  }

  static String? _requireNullableString(
    Object? value,
    String field,
    String path,
  ) {
    if (value == null) {
      return null;
    }
    return _requireString(value, field, path, allowEmpty: true);
  }

  static bool _requireBool(Object? value, String field, String path) {
    if (value is bool) {
      return value;
    }
    throw BackupValidationException('$path.$field: expected a boolean');
  }

  static int _requireInt(Object? value, String field, String path) {
    if (value is int) {
      return value;
    }
    throw BackupValidationException('$path.$field: expected an integer');
  }

  static int _requireNonNegativeInt(Object? value, String field, String path) {
    final parsed = _requireInt(value, field, path);
    if (parsed < 0) {
      throw BackupValidationException('$path.$field: must not be negative');
    }
    return parsed;
  }

  static int? _requireNullableNonNegativeInt(
    Object? value,
    String field,
    String path,
  ) {
    if (value == null) {
      return null;
    }
    return _requireNonNegativeInt(value, field, path);
  }
}
