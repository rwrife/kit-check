import 'package:kit_check/domain/models.dart';

/// Lifecycle state used by history filters. A trip is `active` while any
/// checklist item is still unresolved and `completed` once every item has
/// been returned.
enum TripStateFilter { all, active, completed }

/// A deterministic, local-only filter/search specification over trip history.
///
/// All matching is pure and in-memory: no network access, no clocks, and no
/// dependence on map iteration order. The same query applied to the same
/// trip list always produces the same result.
class TripHistoryQuery {
  const TripHistoryQuery({
    this.searchText = '',
    this.kitId,
    this.startedFrom,
    this.startedThrough,
    this.state = TripStateFilter.all,
    this.unresolvedOnly = false,
  });

  /// Free-text search over trip name, trip note, kit name, item names, and
  /// omission notes. Matched case-insensitively; all whitespace-separated
  /// terms must appear somewhere in the trip.
  final String searchText;

  /// When set, only trips sourced from this kit are returned.
  final KitId? kitId;

  /// Inclusive lower bound on [TripChecklistSnapshot.startedOn] (UTC).
  final DateTime? startedFrom;

  /// Inclusive upper bound on [TripChecklistSnapshot.startedOn] (UTC).
  final DateTime? startedThrough;

  final TripStateFilter state;

  /// When true, only trips with at least one unresolved item are returned.
  final bool unresolvedOnly;

  bool get isActive {
    return searchText.trim().isNotEmpty ||
        kitId != null ||
        startedFrom != null ||
        startedThrough != null ||
        state != TripStateFilter.all ||
        unresolvedOnly;
  }

  bool matches(TripChecklistSnapshot trip) {
    if (kitId != null && trip.kitId != kitId) {
      return false;
    }

    if (startedFrom != null || startedThrough != null) {
      final startedUtc = trip.startedOn.toUtc();
      if (startedFrom != null && startedUtc.isBefore(startedFrom!.toUtc())) {
        return false;
      }
      if (startedThrough != null &&
          startedUtc.isAfter(startedThrough!.toUtc())) {
        return false;
      }
    }

    final unresolvedCount = trip.unresolvedItems.length;

    if (unresolvedOnly && unresolvedCount == 0) {
      return false;
    }

    switch (state) {
      case TripStateFilter.all:
        break;
      case TripStateFilter.active:
        if (unresolvedCount == 0) {
          return false;
        }
      case TripStateFilter.completed:
        if (unresolvedCount != 0) {
          return false;
        }
    }

    return _matchesText(trip);
  }

  bool _matchesText(TripChecklistSnapshot trip) {
    final terms = searchText
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
        .toList(growable: false);

    if (terms.isEmpty) {
      return true;
    }

    final haystack = _haystackFor(trip);
    return terms.every(haystack.contains);
  }

  static String _haystackFor(TripChecklistSnapshot trip) {
    final buffer = StringBuffer()
      ..write(trip.tripName.toLowerCase())
      ..write(' ')
      ..write(trip.kitName.toLowerCase());

    final note = trip.tripNote?.toLowerCase();
    if (note != null && note.isNotEmpty) {
      buffer
        ..write(' ')
        ..write(note);
    }

    for (final item in trip.items) {
      buffer
        ..write(' ')
        ..write(item.itemName.toLowerCase());
      final omission = item.omissionNote?.toLowerCase();
      if (omission != null && omission.isNotEmpty) {
        buffer
          ..write(' ')
          ..write(omission);
      }
    }

    return buffer.toString();
  }
}

/// Applies a [TripHistoryQuery] to a trip list with a stable, documented
/// sort order: newest start date first, ties broken by trip id ascending.
List<TripChecklistSnapshot> filterTrips(
  List<TripChecklistSnapshot> trips,
  TripHistoryQuery query,
) {
  final matches = trips.where(query.matches).toList(growable: false)
    ..sort(_stableTripComparator);
  return List<TripChecklistSnapshot>.unmodifiable(matches);
}

int _stableTripComparator(
  TripChecklistSnapshot left,
  TripChecklistSnapshot right,
) {
  final byDate = right.startedOn.toUtc().compareTo(left.startedOn.toUtc());
  if (byDate != 0) {
    return byDate;
  }
  return left.id.value.compareTo(right.id.value);
}
