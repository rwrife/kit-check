import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/domain/models.dart';

void main() {
  KitTemplate makeKit() {
    return KitTemplate(
      id: KitId('kit-weekend'),
      name: 'Weekend Kit',
      categories: <KitCategory>[
        KitCategory(
          id: CategoryId('cat-clothes'),
          name: 'Clothes',
          sortOrder: 2,
        ),
        KitCategory(
          id: CategoryId('cat-toiletries'),
          name: 'Toiletries',
          sortOrder: 1,
        ),
      ],
      items: <KitItemTemplate>[
        KitItemTemplate(
          id: ItemId('item-shirt'),
          name: 'Shirt',
          categoryId: CategoryId('cat-clothes'),
          sortOrder: 2,
        ),
        KitItemTemplate(
          id: ItemId('item-toothbrush'),
          name: 'Toothbrush',
          categoryId: CategoryId('cat-toiletries'),
          sortOrder: 1,
        ),
        KitItemTemplate(
          id: ItemId('item-passport'),
          name: 'Passport',
          sortOrder: 0,
        ),
      ],
    );
  }

  test('snapshot order is deterministic by category then item order', () {
    final snapshot = TripChecklistSnapshot.fromKitTemplate(
      id: TripId('trip-1'),
      kit: makeKit(),
      tripName: 'Seattle weekend',
      startedOn: DateTime.utc(2026, 9, 1),
    );

    expect(snapshot.items.map((item) => item.itemId.value).toList(), <String>[
      'item-toothbrush',
      'item-shirt',
      'item-passport',
    ]);
  });

  test('snapshot remains independent from later template edits', () {
    final kit = makeKit();
    final snapshot = TripChecklistSnapshot.fromKitTemplate(
      id: TripId('trip-2'),
      kit: kit,
      tripName: 'Labor day',
      startedOn: DateTime.utc(2026, 9, 2),
    );

    final changedTemplate = KitTemplate(
      id: kit.id,
      name: kit.name,
      categories: kit.categories,
      items: <KitItemTemplate>[
        KitItemTemplate(
          id: ItemId('item-toothbrush'),
          name: 'Electric toothbrush',
          categoryId: CategoryId('cat-toiletries'),
          sortOrder: 1,
        ),
      ],
    );

    expect(snapshot.items.first.itemName, 'Toothbrush');
    expect(changedTemplate.items.first.name, 'Electric toothbrush');
  });

  test('updateItem creates a new immutable snapshot instance', () {
    final original = TripChecklistSnapshot.fromKitTemplate(
      id: TripId('trip-3'),
      kit: makeKit(),
      tripName: 'Road trip',
      startedOn: DateTime.utc(2026, 9, 3),
    );

    final updated = original.updateItem(
      ItemId('item-toothbrush'),
      (item) => item.markPacked(),
    );

    final originalItem = original.items.firstWhere(
      (item) => item.itemId == ItemId('item-toothbrush'),
    );
    final updatedItem = updated.items.firstWhere(
      (item) => item.itemId == ItemId('item-toothbrush'),
    );

    expect(originalItem.status, ChecklistStatus.pending);
    expect(updatedItem.status, ChecklistStatus.packed);
    expect(original.unresolvedItems.length, 3);
    expect(updated.unresolvedItems.length, 3);
  });
}
