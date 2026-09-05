import 'package:kit_check/domain/models.dart';

abstract interface class KitCheckRepository {
  Future<List<KitTemplate>> loadKits();

  Future<void> saveKit(KitTemplate kit);

  Future<void> deleteKit(KitId id);
}

class InMemoryKitCheckRepository implements KitCheckRepository {
  final Map<KitId, KitTemplate> _kitsById = <KitId, KitTemplate>{};

  @override
  Future<void> deleteKit(KitId id) async {
    _kitsById.remove(id);
  }

  @override
  Future<List<KitTemplate>> loadKits() async {
    final kits = _kitsById.values.toList(growable: false)
      ..sort((left, right) => left.name.compareTo(right.name));
    return kits;
  }

  @override
  Future<void> saveKit(KitTemplate kit) async {
    _kitsById[kit.id] = kit;
  }
}
