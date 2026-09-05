import 'package:flutter_test/flutter_test.dart';
import 'package:kit_check/domain/models.dart';

void main() {
  group('ChecklistItemSnapshot transitions', () {
    final base = ChecklistItemSnapshot(
      itemId: ItemId('item-1'),
      itemName: 'Toothbrush',
    );

    test('pending -> packed -> returned is allowed', () {
      final packed = base.markPacked();
      final returned = packed.markReturned();

      expect(packed.status, ChecklistStatus.packed);
      expect(returned.status, ChecklistStatus.returned);
      expect(returned.isUnresolved, isFalse);
    });

    test('cannot mark pending item as returned', () {
      expect(base.markReturned, throwsStateError);
    });

    test('omission requires note and keeps unresolved status', () {
      expect(() => base.omit('   '), throwsArgumentError);

      final omitted = base.omit('forgot to wash it');

      expect(omitted.status, ChecklistStatus.omitted);
      expect(omitted.omissionNote, 'forgot to wash it');
      expect(omitted.isUnresolved, isTrue);
    });

    test('returned item cannot be mutated back to pending or packed', () {
      final returned = base.markPacked().markReturned();

      expect(returned.resetToPending, throwsStateError);
      expect(returned.markPacked, throwsStateError);
    });
  });
}
