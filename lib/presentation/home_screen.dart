import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/backup/backup_document.dart';
import 'package:kit_check/backup/backup_service.dart';
import 'package:kit_check/domain/models.dart';
import 'package:kit_check/history/trip_history_query.dart';
import 'package:kit_check/persistence/kit_check_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.configuration,
    required this.repository,
  });

  final AppConfiguration configuration;
  final KitCheckRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _kitNameController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _historySearchController =
      TextEditingController();
  final TextEditingController _historyFromController = TextEditingController();
  final TextEditingController _historyToController = TextEditingController();

  final List<String> _draftItems = <String>[];

  late final BackupService _backupService = BackupService(widget.repository);

  KitTemplate? _kit;
  TripChecklistSnapshot? _trip;
  bool _isBusy = false;
  String? _errorMessage;

  List<KitTemplate> _allKits = const <KitTemplate>[];
  List<TripChecklistSnapshot> _allTrips = const <TripChecklistSnapshot>[];
  KitId? _historyKitFilter;
  TripStateFilter _historyState = TripStateFilter.all;
  bool _historyUnresolvedOnly = false;

  @override
  void initState() {
    super.initState();
    _bootstrapFromRepository();
  }

  @override
  void dispose() {
    _kitNameController.dispose();
    _itemNameController.dispose();
    _tripNameController.dispose();
    _historySearchController.dispose();
    _historyFromController.dispose();
    _historyToController.dispose();
    super.dispose();
  }

  Future<void> _bootstrapFromRepository() async {
    try {
      final activeKits = await widget.repository.loadKits(
        includeArchived: false,
      );
      final allKits = await widget.repository.loadKits(includeArchived: true);
      final trips = await widget.repository.loadTrips();

      if (!mounted) {
        return;
      }

      final visibleKitIds = activeKits.map((kit) => kit.id).toSet();

      setState(() {
        _allKits = allKits;
        _allTrips = trips;
        if (_historyKitFilter != null &&
            !visibleKitIds.contains(_historyKitFilter)) {
          _historyKitFilter = null;
        }
        if (activeKits.isNotEmpty) {
          _kit = activeKits.first;
          _kitNameController.text = activeKits.first.name;
        }
        if (trips.isNotEmpty) {
          _trip = trips.first;
          _tripNameController.text = trips.first.tripName;
        }
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Failed to load local data: $error';
      });
    }
  }

  Future<void> _runBusy(Future<void> Function() action) async {
    if (_isBusy) {
      return;
    }

    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      await action();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = '$error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  void _addDraftItem() {
    final itemName = _itemNameController.text.trim();
    if (itemName.isEmpty) {
      return;
    }

    setState(() {
      _draftItems.add(itemName);
      _itemNameController.clear();
      _errorMessage = null;
    });
  }

  void _removeDraftItemAt(int index) {
    setState(() {
      _draftItems.removeAt(index);
    });
  }

  Future<void> _createKit() async {
    final kitName = _kitNameController.text.trim();
    if (kitName.isEmpty || _draftItems.isEmpty) {
      return;
    }

    await _runBusy(() async {
      final created = await widget.repository.createKit(kitName);
      final populated = KitTemplate(
        id: created.id,
        name: created.name,
        items: <KitItemTemplate>[
          for (var index = 0; index < _draftItems.length; index += 1)
            KitItemTemplate(
              id: ItemId('item-${index + 1}'),
              name: _draftItems[index],
              sortOrder: index,
            ),
        ],
      );

      await widget.repository.saveKit(populated);

      if (!mounted) {
        return;
      }
      setState(() {
        _kit = populated;
        _trip = null;
        _tripNameController.clear();
        _draftItems.clear();
        _allKits = <KitTemplate>[..._allKits, populated];
      });
    });
  }

  Future<void> _startTrip() async {
    final kit = _kit;
    final tripName = _tripNameController.text.trim();
    if (kit == null || tripName.isEmpty) {
      return;
    }

    await _runBusy(() async {
      final created = await widget.repository.createTrip(
        kitId: kit.id,
        tripName: tripName,
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _trip = created;
        _allTrips = <TripChecklistSnapshot>[created, ..._allTrips];
      });
    });
  }

  Future<void> _updateItem(
    ItemId itemId,
    ChecklistItemSnapshot Function(ChecklistItemSnapshot current) update,
  ) async {
    final trip = _trip;
    if (trip == null) {
      return;
    }

    await _runBusy(() async {
      final updated = trip.updateItem(itemId, update);
      await widget.repository.saveTrip(updated);

      if (!mounted) {
        return;
      }
      setState(() {
        _trip = updated;
        _allTrips = _allTrips
            .map((existing) => existing.id == updated.id ? updated : existing)
            .toList(growable: false);
      });
    });
  }

  Future<void> _omitItem(ChecklistItemSnapshot item) async {
    final reason = await _promptForOmissionReason(item.itemName);
    if (reason == null) {
      return;
    }

    await _updateItem(item.itemId, (current) => current.omit(reason));
  }

  Future<String?> _promptForOmissionReason(String itemName) async {
    var omissionNote = '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Omit $itemName'),
          content: TextField(
            key: const ValueKey('omission-note-field'),
            autofocus: true,
            minLines: 1,
            maxLines: 3,
            onChanged: (value) {
              omissionNote = value;
            },
            decoration: const InputDecoration(
              labelText: 'Reason for omission',
              hintText: 'Example: Laundry not finished',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const ValueKey('confirm-omit-button'),
              onPressed: () {
                Navigator.of(context).pop(omissionNote.trim());
              },
              child: const Text('Confirm omission'),
            ),
          ],
        );
      },
    );

    if (result == null || result.trim().isEmpty) {
      return null;
    }
    return result.trim();
  }

  Future<void> _exportBackupJson() async {
    await _runBusy(() async {
      final json = await _backupService.exportBackupJson();
      await Clipboard.setData(ClipboardData(text: json));
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = null;
      });
      _showNotice('Backup copied to clipboard as versioned JSON.');
    });
  }

  Future<void> _exportHistoryCsv() async {
    await _runBusy(() async {
      final csv = await _backupService.exportHistoryCsv();
      await Clipboard.setData(ClipboardData(text: csv));
      if (!mounted) {
        return;
      }
      _showNotice('Trip history copied to clipboard as CSV.');
    });
  }

  Future<void> _restoreFromBackup() async {
    final raw = await _promptForBackupJson();
    if (raw == null || raw.trim().isEmpty) {
      return;
    }

    BackupDocument document;
    try {
      document = BackupCodec.decode(raw);
    } on BackupValidationException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Backup rejected, no data changed: ${error.message}';
      });
      return;
    }

    final plan = await _backupService.previewRestore(document);
    if (!mounted) {
      return;
    }

    final confirmed = await _confirmRestore(plan);
    if (confirmed != true) {
      return;
    }

    await _runBusy(() async {
      final summary = await _backupService.applyRestore(
        document,
        userConfirmed: true,
        mode: RestoreMode.replaceAll,
        conflictResolution: RestoreConflictResolution.overwrite,
      );
      await _bootstrapFromRepository();
      if (!mounted) {
        return;
      }
      _showNotice(
        'Restore applied: ${summary.kitsInserted + summary.kitsOverwritten} '
        'kit(s), ${summary.tripsInserted + summary.tripsOverwritten} trip(s).',
      );
    });
  }

  Future<void> _deleteAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete all local data?'),
          content: const Text(
            'This permanently removes every kit, trip, and checklist from '
            'this device. There is no undo. Export a backup first if you '
            'want to keep a copy.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const ValueKey('confirm-delete-all-button'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete everything'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _runBusy(() async {
      await _backupService.deleteAllData();
      await _bootstrapFromRepository();
      if (!mounted) {
        return;
      }
      setState(() {
        _kit = null;
        _trip = null;
        _kitNameController.clear();
        _tripNameController.clear();
        _draftItems.clear();
      });
      _showNotice('All local data deleted.');
    });
  }

  TripHistoryQuery _buildHistoryQuery() {
    return TripHistoryQuery(
      searchText: _historySearchController.text,
      kitId: _historyKitFilter,
      startedFrom: _parseHistoryDate(_historyFromController.text),
      startedThrough: _endOfDay(_parseHistoryDate(_historyToController.text)),
      state: _historyState,
      unresolvedOnly: _historyUnresolvedOnly,
    );
  }

  static DateTime? _parseHistoryDate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return DateTime.tryParse(trimmed)?.toUtc();
  }

  static DateTime? _endOfDay(DateTime? date) {
    if (date == null) {
      return null;
    }
    return DateTime.utc(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  Future<void> _deleteTrip(TripChecklistSnapshot trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete trip "${trip.tripName}"?'),
          content: const Text(
            'This permanently removes the trip and its checklist from '
            'local history and from future exports on this device. '
            'There is no undo.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const ValueKey('confirm-delete-trip-button'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete trip'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _runBusy(() async {
      await widget.repository.deleteTrip(trip.id);
      await _bootstrapFromRepository();
      if (!mounted) {
        return;
      }
      if (_trip?.id == trip.id) {
        setState(() {
          _trip = null;
          _tripNameController.clear();
        });
      }
      _showNotice('Trip deleted from local history.');
    });
  }

  Future<String?> _promptForBackupJson() async {
    var backupText = '';

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore from backup JSON'),
          content: SizedBox(
            width: 480,
            child: TextField(
              key: const ValueKey('backup-json-field'),
              autofocus: true,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Paste backup JSON',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                backupText = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const ValueKey('preview-restore-button'),
              onPressed: () => Navigator.of(context).pop(backupText),
              child: const Text('Preview restore'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmRestore(RestorePlan plan) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm restore'),
          content: Semantics(
            label: 'Restore preview',
            child: Column(
              key: const ValueKey('restore-preview'),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Backup contains ${plan.totalIncoming} record(s).'),
                Text('New kits: ${plan.newKitIds.length}'),
                Text(
                  'Existing kits to overwrite: '
                  '${plan.conflictingKitIds.length}',
                ),
                Text('New trips: ${plan.newTripIds.length}'),
                Text(
                  'Existing trips to overwrite: '
                  '${plan.conflictingTripIds.length}',
                ),
                const SizedBox(height: 8),
                const Text(
                  'This replaces all current local data on this device '
                  'with the backup. There is no undo.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const ValueKey('confirm-restore-button'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Replace data and restore'),
            ),
          ],
        );
      },
    );
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const ValueKey('data-notice-snack'),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = _trip;

    return Scaffold(
      appBar: AppBar(title: const Text('Kit Check')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Semantics(
            label: 'Local first application summary',
            child: Text(
              'Prepare reusable trip kits and independent trip checklists.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Local-only mode: '
            '${widget.configuration.dataMode == DataMode.localOnly ? 'enabled' : 'disabled'}',
          ),
          Text(
            'Network requests allowed: '
            '${widget.configuration.allowNetworkRequests}',
          ),
          Text('Account required: ${widget.configuration.requiresAccount}'),
          const SizedBox(height: 16),
          const Text(
            'No cloud account is required. All MVP data stays on-device unless '
            'the user explicitly exports it.',
          ),
          if (_errorMessage != null) ...<Widget>[
            const SizedBox(height: 16),
            Semantics(
              label: 'Workflow error',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildKitComposer(context),
          if (_kit != null && trip == null) ...<Widget>[
            const SizedBox(height: 20),
            _buildTripStarter(),
          ],
          if (trip != null) ...<Widget>[
            const SizedBox(height: 24),
            _buildTripChecklist(context, trip),
          ],
          const SizedBox(height: 24),
          _buildDataSection(context),
          const SizedBox(height: 24),
          _buildHistorySection(context),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    final query = _buildHistoryQuery();
    final matches = filterTrips(_allTrips, query);
    final invalidDateRange =
        query.startedFrom != null &&
        query.startedThrough != null &&
        query.startedFrom!.isAfter(query.startedThrough!);

    return Semantics(
      label: 'Local trip history',
      child: Column(
        key: const ValueKey('trip-history-section'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Trip history (local only)',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Search and filters run entirely on this device. Deleting a '
            'trip removes it from local history and future exports with no '
            'undo.',
          ),
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('history-search-field'),
            controller: _historySearchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search trips',
              hintText: 'Trip, kit, item, or omission note',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  key: const ValueKey('history-from-field'),
                  controller: _historyFromController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Started from (YYYY-MM-DD)',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  key: const ValueKey('history-to-field'),
                  controller: _historyToController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Started through (YYYY-MM-DD)',
                  ),
                ),
              ),
            ],
          ),
          if (invalidDateRange) ...<Widget>[
            const SizedBox(height: 8),
            Semantics(
              label: 'Invalid history date range',
              child: Text(
                'The start date is after the end date, so no trips match.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Semantics(
            label: 'Filter history by kit',
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                key: const ValueKey('history-kit-filter'),
                isExpanded: true,
                value: _historyKitFilter?.value,
                hint: const Text('All kits'),
                items: <DropdownMenuItem<String?>>[
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All kits'),
                  ),
                  for (final kit in _allKits)
                    DropdownMenuItem<String?>(
                      value: kit.id.value,
                      child: Text(kit.name),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _historyKitFilter = value == null ? null : KitId(value);
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final option in TripStateFilter.values)
                Semantics(
                  label: 'History state filter ${option.name}',
                  button: true,
                  child: FilterChip(
                    key: ValueKey<String>('history-state-${option.name}'),
                    label: Text(_tripStateLabel(option)),
                    selected: _historyState == option,
                    onSelected: (_) {
                      setState(() {
                        _historyState = option;
                      });
                    },
                  ),
                ),
              Semantics(
                label: 'Show only trips with unresolved items',
                button: true,
                child: FilterChip(
                  key: const ValueKey('history-unresolved-chip'),
                  label: const Text('Unresolved items only'),
                  selected: _historyUnresolvedOnly,
                  onSelected: (selected) {
                    setState(() {
                      _historyUnresolvedOnly = selected;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Semantics(
            label: 'History search controls',
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Semantics(
                  label: 'Clear history filters',
                  button: true,
                  child: OutlinedButton(
                    key: const ValueKey('history-clear-filters'),
                    onPressed:
                        !_allTrips.any((trip) => query.matches(trip)) &&
                            !query.isActive
                        ? null
                        : () {
                            setState(() {
                              _historySearchController.clear();
                              _historyFromController.clear();
                              _historyToController.clear();
                              _historyKitFilter = null;
                              _historyState = TripStateFilter.all;
                              _historyUnresolvedOnly = false;
                            });
                          },
                    child: const Text('Clear filters'),
                  ),
                ),
                Text(
                  query.isActive
                      ? '${matches.length} of ${_allTrips.length} trip(s) match'
                      : '${_allTrips.length} trip(s) in history',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_allTrips.isEmpty)
            const Text('No trips yet. Start a trip checklist above.')
          else if (matches.isEmpty)
            const Text('No trips match the current filters.')
          else
            for (final trip in matches) _buildHistoryTripCard(trip),
        ],
      ),
    );
  }

  Widget _buildHistoryTripCard(TripChecklistSnapshot trip) {
    final unresolved = trip.unresolvedItems.length;

    return Card(
      key: ValueKey<String>('history-trip-${trip.id.value}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(trip.tripName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Kit: ${trip.kitName} · Started: '
              '${trip.startedOn.toUtc().toIso8601String().substring(0, 10)}',
            ),
            Semantics(
              label: 'Unresolved item count for ${trip.tripName}: $unresolved',
              child: Text(
                unresolved == 0
                    ? 'Completed — all items returned'
                    : '$unresolved unresolved item(s)',
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                Semantics(
                  label: 'Open trip ${trip.tripName}',
                  button: true,
                  child: FilledButton.tonal(
                    key: ValueKey<String>('open-trip-${trip.id.value}'),
                    onPressed: _isBusy
                        ? null
                        : () {
                            setState(() {
                              _trip = trip;
                              _tripNameController.text = trip.tripName;
                            });
                          },
                    child: const Text('Open'),
                  ),
                ),
                Semantics(
                  label: 'Delete trip ${trip.tripName} from local history',
                  button: true,
                  child: OutlinedButton(
                    key: ValueKey<String>('delete-trip-${trip.id.value}'),
                    onPressed: _isBusy ? null : () => _deleteTrip(trip),
                    child: const Text('Delete trip'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _tripStateLabel(TripStateFilter filter) {
    return switch (filter) {
      TripStateFilter.all => 'All trips',
      TripStateFilter.active => 'Active',
      TripStateFilter.completed => 'Completed',
    };
  }

  Widget _buildDataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Data & backup (local only)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Text(
          'Everything stays on this device. Exports copy data to the '
          'clipboard so you can save it yourself; nothing is uploaded.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            Semantics(
              label: 'Export JSON backup to clipboard',
              button: true,
              child: FilledButton.tonal(
                key: const ValueKey('export-backup-button'),
                onPressed: _isBusy ? null : _exportBackupJson,
                child: const Text('Export JSON backup'),
              ),
            ),
            Semantics(
              label: 'Export trip history CSV to clipboard',
              button: true,
              child: FilledButton.tonal(
                key: const ValueKey('export-csv-button'),
                onPressed: _isBusy ? null : _exportHistoryCsv,
                child: const Text('Export history CSV'),
              ),
            ),
            Semantics(
              label: 'Restore local data from backup JSON',
              button: true,
              child: OutlinedButton(
                key: const ValueKey('restore-backup-button'),
                onPressed: _isBusy ? null : _restoreFromBackup,
                child: const Text('Restore from backup'),
              ),
            ),
            Semantics(
              label: 'Delete all local data',
              button: true,
              child: OutlinedButton(
                key: const ValueKey('delete-all-button'),
                onPressed: _isBusy ? null : _deleteAllData,
                child: const Text('Delete all local data'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKitComposer(BuildContext context) {
    final canCreateKit =
        !_isBusy &&
        _kitNameController.text.trim().isNotEmpty &&
        _draftItems.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '1) Create a reusable kit',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('kit-name-field'),
          controller: _kitNameController,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Kit name',
            hintText: 'Weekend carry-on',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                key: const ValueKey('item-name-field'),
                controller: _itemNameController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addDraftItem(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Item name',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              label: 'Add item to current kit',
              button: true,
              child: FilledButton(
                key: const ValueKey('add-item-button'),
                onPressed: _isBusy ? null : _addDraftItem,
                child: const Text('Add item'),
              ),
            ),
          ],
        ),
        if (_draftItems.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (var index = 0; index < _draftItems.length; index += 1)
                InputChip(
                  label: Text(_draftItems[index]),
                  onDeleted: _isBusy ? null : () => _removeDraftItemAt(index),
                ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Semantics(
          label: 'Create kit from draft items',
          button: true,
          child: FilledButton(
            key: const ValueKey('create-kit-button'),
            onPressed: canCreateKit ? _createKit : null,
            child: Text(_isBusy ? 'Saving…' : 'Create kit'),
          ),
        ),
        if (_kit != null) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            'Kit ready: ${_kit!.name}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ],
    );
  }

  Widget _buildTripStarter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('2) Start a trip checklist'),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('trip-name-field'),
          controller: _tripNameController,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Trip name',
            hintText: 'Seattle weekend',
          ),
        ),
        const SizedBox(height: 12),
        Semantics(
          label: 'Start trip checklist from current kit',
          button: true,
          child: FilledButton(
            key: const ValueKey('start-trip-button'),
            onPressed: !_isBusy && _tripNameController.text.trim().isNotEmpty
                ? _startTrip
                : null,
            child: const Text('Start trip'),
          ),
        ),
      ],
    );
  }

  Widget _buildTripChecklist(BuildContext context, TripChecklistSnapshot trip) {
    final total = trip.items.length;
    final packedCount = trip.items
        .where(
          (item) =>
              item.status == ChecklistStatus.packed ||
              item.status == ChecklistStatus.returned,
        )
        .length;
    final returnedCount = trip.items
        .where((item) => item.status == ChecklistStatus.returned)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Trip: ${trip.tripName}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text('Packing progress: $packedCount / $total packed or returned'),
        Text('Return progress: $returnedCount / $total returned'),
        const SizedBox(height: 16),
        for (final item in trip.items) _buildChecklistItemCard(item),
        const SizedBox(height: 20),
        _buildUnresolvedSection(trip),
      ],
    );
  }

  Widget _buildChecklistItemCard(ChecklistItemSnapshot item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.itemName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Semantics(
              label:
                  'Status for ${item.itemName}: ${_statusLabel(item.status)}',
              child: Text('Status: ${_statusLabel(item.status)}'),
            ),
            if (item.omissionNote != null) ...<Widget>[
              const SizedBox(height: 4),
              Text('Omission note: ${item.omissionNote}'),
            ],
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: _buildItemActions(item)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemActions(ChecklistItemSnapshot item) {
    final actions = <Widget>[];

    if (item.status != ChecklistStatus.returned) {
      actions.add(
        Semantics(
          label: 'Mark ${item.itemName} as packed',
          button: true,
          child: FilledButton.tonal(
            key: ValueKey<String>('pack-${item.itemId.value}'),
            onPressed: _isBusy
                ? null
                : () => _updateItem(
                    item.itemId,
                    (current) => current.markPacked(),
                  ),
            child: const Text('Mark packed'),
          ),
        ),
      );
    }

    if (item.status == ChecklistStatus.packed) {
      actions.add(
        Semantics(
          label: 'Mark ${item.itemName} as returned',
          button: true,
          child: FilledButton(
            key: ValueKey<String>('return-${item.itemId.value}'),
            onPressed: _isBusy
                ? null
                : () => _updateItem(
                    item.itemId,
                    (current) => current.markReturned(),
                  ),
            child: const Text('Mark returned'),
          ),
        ),
      );
    }

    if (item.status != ChecklistStatus.returned) {
      actions.add(
        Semantics(
          label: 'Mark ${item.itemName} as omitted',
          button: true,
          child: OutlinedButton(
            key: ValueKey<String>('omit-${item.itemId.value}'),
            onPressed: _isBusy ? null : () => _omitItem(item),
            child: const Text('Omit'),
          ),
        ),
      );
    }

    if (item.status == ChecklistStatus.omitted) {
      actions.add(
        Semantics(
          label: 'Reset ${item.itemName} to pending',
          button: true,
          child: OutlinedButton(
            key: ValueKey<String>('reset-${item.itemId.value}'),
            onPressed: _isBusy
                ? null
                : () => _updateItem(
                    item.itemId,
                    (current) => current.resetToPending(),
                  ),
            child: const Text('Reset'),
          ),
        ),
      );
    }

    return actions;
  }

  Widget _buildUnresolvedSection(TripChecklistSnapshot trip) {
    final unresolved = trip.unresolvedItems;

    return Semantics(
      label: 'Unresolved items summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Unresolved items (${unresolved.length})'),
          const SizedBox(height: 8),
          if (unresolved.isEmpty)
            const Text('All items returned.')
          else
            for (final item in unresolved)
              Text('${item.itemName} — ${_statusLabel(item.status)}'),
        ],
      ),
    );
  }

  static String _statusLabel(ChecklistStatus status) {
    return switch (status) {
      ChecklistStatus.pending => 'Pending',
      ChecklistStatus.packed => 'Packed',
      ChecklistStatus.omitted => 'Omitted',
      ChecklistStatus.returned => 'Returned',
    };
  }
}
