# Kit Check

**Kit Check** is a local-first Android and iOS app for people who reuse packing kits to prepare and return trip-specific gear checklists without accounts.

## Motivation

Reusable packing lists are useful, but a static list cannot show which items were packed for one specific outing or which have made it back home. Kit Check combines a reusable kit template with a dated trip check-out/check-in record so users can confidently reset their gear between trips.

## Target users

- Travelers who maintain carry-on, road-trip, or camping kits.
- Parents and organizers preparing repeatable activity or weekend bags.
- Hobbyists who want a simple personal readiness checklist without a cloud account.

## Use cases

- Build a reusable weekend-trip kit with clothing, chargers, and toiletries.
- Start a trip, check off packed items, and note a deliberately omitted item.
- Check items back in after returning, then review unresolved items.
- Export a portable copy of personal kits and trip history before changing phones.

## Intended workflow

1. Create a kit and add named items, optional categories, quantities, and notes.
2. Start a trip from that kit; the app creates an independent checklist snapshot.
3. Mark items packed or omitted, then use the return checklist when the trip ends.
4. Review unresolved items and export or back up local data whenever desired.

## MVP

- Reusable kits with ordered categories and items.
- Per-trip packing and return checklist snapshots.
- Clear packed, omitted, returned, and unresolved states.
- Searchable local history and CSV/JSON export.
- Versioned backup/restore and delete-all-data controls.
- Accessible Flutter UI for Android and iOS.

## Non-goals

Kit Check is not a booking service, map, weather source, location tracker, shared cloud workspace, shopping list, airline compliance guide, safety checklist authority, or emergency-preparedness advisor. It does not claim that a kit is complete or suitable for any activity.

## Privacy, permissions, and local data

Data is stored locally on the device by default using SQLite. No account, analytics, location, contacts, camera, or network access is required for the MVP. Files are exported only when the user explicitly chooses a destination. Notifications, if added later, will be optional and requested in context. Users can export, restore, or permanently delete their data.

## Accessibility

The app will support screen-reader labels, keyboard/switch navigation where the platform provides it, logical focus order, non-color-only status, scalable text, and tappable controls sized for mobile use.

## Status and milestones

This repository currently contains product documentation and an implementation backlog only.

1. Create the Flutter project, domain model, and tests.
2. Implement kits and trip checklist snapshots.
3. Add accessible workflows, local export/backup, and release packaging.

## Development quickstart

The planned stack is Flutter/Dart with Drift over SQLite. Once the project skeleton lands:

```sh
flutter pub get
flutter test
flutter run
```

No application source or build artifact exists yet.
