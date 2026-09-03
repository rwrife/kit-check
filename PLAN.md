# Kit Check Plan

## Scope

Kit Check turns reusable kit templates into independent trip records. A user can create a kit, start a trip, check items out, check them back in, and identify unresolved items without mutating the template or requiring an account.

## Architecture

- **Flutter presentation:** Android and iOS screens using Material 3, semantic labels, and scalable layouts.
- **Dart domain layer:** Immutable kit, item, trip, and checklist-transition models with deterministic state transitions.
- **Local persistence:** Drift/SQLite migrations, repositories, and snapshot records.
- **Export boundary:** Versioned JSON backup/restore plus flat CSV history export, entirely user initiated.

## Technology choices

Flutter/Dart provides one accessible mobile codebase for Android and iOS. Drift provides typed, migration-aware local SQLite access. Flutter's standard testing tools cover domain, widget, and integration tests without requiring a backend.

## Milestones and dependencies

1. Establish Flutter project structure, linting, CI, domain model, and migrations.
2. Implement kit CRUD and ordered item/category management.
3. Implement trip creation and immutable checklist snapshots from a kit.
4. Implement packing, omission, return, and unresolved-item views.
5. Add search/history, accessibility refinement, and local export/backup/restore.
6. Validate Android/iOS builds and publish unsigned release candidates with clear local-data documentation.

Later milestones depend on the domain model and repository migration layer; export/restore must validate versions before mutating local data.

## Testing strategy

- Unit-test checklist transition rules, snapshot isolation, ordering, filtering, serialization, and migration behavior.
- Widget-test critical kit and trip workflows with semantics assertions.
- Integration-test create-to-return and backup/restore flows against temporary databases.
- Run Flutter analyzer and platform builds in CI when the skeleton is present.

## Packaging and distribution

Initial development targets Android and iOS simulators/devices. Release work will document build provenance, supported OS ranges, local-data locations, privacy details, unsigned/signed artifact status, and store-readiness requirements. No package or store listing exists yet.

## Risks and explicit non-goals

The main risks are accidental template mutation, ambiguous return states, and unsafe restore handling. The MVP does not make travel, safety, compliance, or completeness claims; coordinate with others; retrieve external data; track location; or use accounts/cloud synchronization.
