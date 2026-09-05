import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/domain/models.dart';

void main() {
  test('kit captures immutable snapshots of constructor lists', () {
    final categories = <KitCategory>[
      KitCategory(id: CategoryId('cat-1'), name: 'Clothes', sortOrder: 0),
    ];
    final items = <KitItemTemplate>[
      KitItemTemplate(id: ItemId('item-1'), name: 'Socks', sortOrder: 0),
    ];

    final kit = KitTemplate(
      id: KitId('kit-1'),
      name: 'Weekend',
      categories: categories,
      items: items,
    );

    categories.add(
      KitCategory(id: CategoryId('cat-2'), name: 'Toiletries', sortOrder: 1),
    );
    items.add(
      KitItemTemplate(id: ItemId('item-2'), name: 'Toothbrush', sortOrder: 1),
    );

    expect(kit.categories.length, 1);
    expect(kit.items.length, 1);
    expect(() => kit.categories.add(categories.last), throwsUnsupportedError);
    expect(() => kit.items.add(items.last), throwsUnsupportedError);
  });
}
