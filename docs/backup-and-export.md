# Backup and Export

Kit Check is local-first. Backup and export exist so **you** own your data —
nothing here sends anything anywhere. Exports copy data to the device
clipboard; you decide where the file goes. Restore reads a document you
supply and only changes local data after you confirm a preview.

## JSON backup format (schema version 1)

The backup is a single UTF-8 JSON document. Every backup produced by this
build carries `schemaVersion: 1` and `app: "kit_check"`. Restore rejects any
other version or app id **before** touching stored data.

```json
{
  "schemaVersion": 1,
  "app": "kit_check",
  "exportedAt": "2026-01-01T00:00:00.000Z",
  "kits": [
    {
      "id": "kit-1",
      "name": "Weekend Kit",
      "isArchived": false,
      "categories": [
        { "id": "cat-1", "name": "Clothes", "sortOrder": 0 }
      ],
      "items": [
        {
          "id": "item-1",
          "name": "Socks",
          "quantity": 3,
          "note": null,
          "categoryId": "cat-1",
          "sortOrder": 0
        }
      ]
    }
  ],
  "trips": [
    {
      "id": "trip-1",
      "kitId": "kit-1",
      "kitName": "Weekend Kit",
      "tripName": "Seattle Weekend",
      "tripNote": null,
      "startedOnMs": 1767225600000,
      "items": [
        {
          "itemId": "item-1",
          "itemName": "Socks",
          "quantity": 3,
          "note": null,
          "categoryName": "Clothes",
          "status": "omitted",
          "omissionNote": "Laundry not finished"
        }
      ]
    }
  ]
}
```

Field rules:

- `startedOnMs` — milliseconds since the Unix epoch, always interpreted as UTC.
- `status` — one of `pending`, `packed`, `omitted`, `returned`.
- `omissionNote` — non-empty string **only** when `status` is `omitted`;
  must be `null` otherwise.
- Ids (`kit.id`, `category.id`, `item.id`, `trip.id`, `item.itemId`) must be
  unique inside their collection. A trip checklist cannot list the same item
  id twice.
- `item.categoryId` must reference a category inside the same kit, or be
  `null`.

Restore validation is all-or-nothing: a document that fails any rule is
rejected with a field-path message and no local data changes.

## Restore behavior

1. You paste/provide backup JSON.
2. The app validates the document completely (nothing written yet).
3. A **preview** shows what would change: new records vs. records that
   already exist locally (conflicts).
4. Nothing changes until you explicitly confirm in the preview dialog.
   Cancelling leaves local data untouched.
5. Confirming replaces local data with the backup contents.

The backup service also supports a merge mode (keep local records not in the
backup, choose keep-local or overwrite for conflicts); the current UI flow
uses replace-with-confirmation, which is the least surprising behavior for
restoring a device.

## CSV history export

`Export history CSV` produces RFC 4180 CSV (fields containing commas,
quotes, or newlines are double-quoted) with exactly these columns:

| Column | Meaning |
| ------ | ------- |
| `trip_id` | Trip identifier (app-internal id) |
| `trip_name` | Trip name as you typed it |
| `kit_name` | Source kit name captured when the trip started |
| `started_on_utc` | ISO-8601 UTC start time |
| `item_id` | Snapshot item id |
| `item_name` | Item name as snapshotted for this trip |
| `item_status` | `pending` / `packed` / `omitted` / `returned` |
| `omission_note` | Omission reason for omitted items, else empty |

One row per checklist item (trips with no items emit one row with empty item
columns). The CSV contains only your own kit/trip data — no device
identifiers, no analytics fields, nothing else.

## Trip history search and filters

The Trip history section lists every trip stored on this device, newest
start date first (ties broken by trip id so ordering is deterministic).
Search and filters run entirely in memory against local data:

- Free-text search over trip name, trip note, kit name, item names, and
  omission notes. Matching is case-insensitive and every whitespace-
  separated term must appear somewhere in the trip.
- Kit dropdown filter, inclusive `started from`/`through` date range, and
  active/completed/unresolved filters. A trip is *active* while any
  checklist item is still unresolved and *completed* once every item has
  been returned.

None of this queries a server. There is no index or cache beyond the local
database, so turning on airplane mode changes nothing about search results.

## Deleting a single trip

Each history card has a **Delete trip** action. It permanently removes that
trip and its checklist snapshot from the on-device database; the trip
disappears from history views and from any JSON backup or CSV export taken
afterwards. There is no undo and no automatic export — the confirmation
dialog states this before anything is deleted. Deleting one trip never
touches kits or other trips.

## Delete all local data

"Delete all local data" removes every kit, category, item, trip, and
checklist snapshot from the on-device database in one transaction. It is
irreversible; the confirmation dialog says so, and no export is created
automatically. After deletion the app returns to the same state as a fresh
install (schema intact, no records).

## Privacy boundaries

- Export = clipboard copy initiated by you. No network calls, no share-sheet
  auto-upload, no background work.
- Restore = local file/text you provide. The app never fetches backups.
- No accounts, no telemetry, and no cloud sync exist in this MVP.
