import 'package:flutter/material.dart';
import 'package:kit_check/app/app_configuration.dart';
import 'package:kit_check/domain/models.dart';
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

  final List<String> _draftItems = <String>[];

  KitTemplate? _kit;
  TripChecklistSnapshot? _trip;
  bool _isBusy = false;
  String? _errorMessage;

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
    super.dispose();
  }

  Future<void> _bootstrapFromRepository() async {
    try {
      final kits = await widget.repository.loadKits(includeArchived: false);
      final trips = await widget.repository.loadTrips();

      if (!mounted) {
        return;
      }

      setState(() {
        if (kits.isNotEmpty) {
          _kit = kits.first;
          _kitNameController.text = kits.first.name;
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
        ],
      ),
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
