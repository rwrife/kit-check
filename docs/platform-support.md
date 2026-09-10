# Platform Support and Release Readiness

This document records what Kit Check supports today, where its data lives,
what permissions it requires, and what must be true before any release
artifact is claimed. **No build, package, or store publication has been
performed for Kit Check as of this writing** — everything below describes
intended targets and validation gates, not published evidence.

## Supported platform ranges

The ranges below come directly from the project configuration
(`android/app/build.gradle.kts`, `ios/Runner.xcodeproj`, and the Flutter
SDK constraint in `pubspec.yaml`) and are enforced by
`test/platform/platform_support_contract_test.dart`, which fails if the
manifests drift from this document.

| Platform | Documented range | Source of truth |
| -------- | ---------------- | --------------- |
| Android | API 24 (Android 7.0 Nougat) through API 36 (`minSdk`/`targetSdk` from Flutter 3.47.x defaults) | `flutter.minSdkVersion` / `flutter.targetSdkVersion` in `android/app/build.gradle.kts` |
| iOS | iOS 15.0 and later | `IPHONEOS_DEPLOYMENT_TARGET = 15.0` in `ios/Runner.xcodeproj/project.pbxproj` |
| Flutter SDK | Dart `^3.13.2` (Flutter 3.47.x stable line) | `environment.sdk` in `pubspec.yaml` |

Compatibility is *configured*, not yet *device-verified*: no physical or
emulated device matrix has been run. Device validation is part of the
manual checklist in `docs/manual-test-checklist.md` and has not been
claimed complete.

## Local-data locations

Kit Check stores everything in a local SQLite database (Drift). There is no
server copy.

- **Android:** the app-private database directory
  (`/data/data/dev.rwrife.kit_check/databases/`). The database is not on
  shared storage and is removed when the app is uninstalled.
- **iOS:** the app's `Documents/` container directory (sandboxed, not
  shared with other apps; included in normal device backups unless the user
  disables them).
- The current UI wiring still runs against the in-memory repository
  (`InMemoryKitCheckRepository`); the Drift-backed storage layer exists and
  is migration-tested, and `LocalDatabase.file(path)` opens the database at
  an explicit path. **Data does not persist across app restarts until the
  app is switched to the file-backed repository**, which is tracked as
  follow-up work. Until then, treat app restarts as destructive.

Exported files (JSON backup text, CSV history text) are placed on the
clipboard at a destination *you* choose; the app never writes exports to a
fixed location and never uploads them. See
[backup-and-export.md](backup-and-export.md).

## Permissions

Documented and verified by `test/platform/network_permission_contract_test.dart`:

- **Android release build (`src/main`):** no permissions are declared.
  In particular `android.permission.INTERNET` is **not** requested, and the
  manifest declares no other `<uses-permission>` entries.
- **Android debug/profile builds** (`src/debug`, `src/profile`) do declare
  `android.permission.INTERNET`. This is the stock Flutter scaffold
  requirement for hot reload, observatory/debug traffic, and `flutter
  run --profile` tooling. Those variants are development-only and are never
  shipped as release artifacts.
- **iOS:** no `NS*UsageDescription` keys exist in `Runner/Info.plist` and no
  background modes are declared. The app requests no camera, location,
  contacts, microphone, photo-library, push, or biometric access.
- **Network:** the app performs no network calls of any kind (see
  `AppConfiguration.localOnly()` and the privacy boundaries in
  [backup-and-export.md](backup-and-export.md)).

If a future feature needs a permission, this file must name it alongside an
explicit user-facing purpose before the permission is added.

## Release metadata

- **Version:** `1.0.0+1` in `pubspec.yaml`. This maps to Android
  `versionName 1.0.0` / `versionCode 1` and iOS `CFBundleShortVersionString`
  / `CFBundleVersion` via the Flutter build.
- **Identifiers:** Android `applicationId` and namespace are
  `dev.rwrife.kit_check`; the iOS bundle identifier is
  `dev.rwrife.kitCheck` (`dev.rwrife.kitCheck.RunnerTests` for the native
  test target). iOS *distribution* additionally requires an Apple
  developer account and provisioning profiles before any signed build.
- **`publish_to: 'none'`** is set in `pubspec.yaml`; the package is not
  published to pub.dev.

## Unsigned development vs. signed store-ready

| Artifact | Status today | What signed/store-ready would require |
| -------- | ------------ | ------------------------------------- |
| `flutter build apk --debug` | Development-only; signed with the shared Android debug key; debug build requests INTERNET for tooling. | Not shippable; debug key is public. |
| `flutter build apk --release` | Builds with the **debug signing config** (stock scaffold TODO in `build.gradle.kts`). Despite the name, this is an *unsigned-for-distribution* development artifact. | A private keystore, `signingConfigs.release`, uploaded signing key, and Play App Signing or equivalent key custody. |
| Play Store listing | **Does not exist.** | Signed AAB, data-safety declaration consistent with this document, store listing review. |
| TestFlight / App Store | **Does not exist.** | Apple developer account, real bundle identifier, provisioning profiles, `flutter build ipa`, App Store Connect review, privacy nutrition labels consistent with this document. |

Until an actual signed artifact exists and is verified, no release
channel may be advertised, and release notes must not claim distribution
readiness.

## CI validation (what is automated vs. manual)

`.github/workflows/ci.yml` runs on every pull request and push to `main`:

1. **flutter-checks** (Linux): `dart format` gate, `flutter analyze`,
   `flutter test` (includes the platform-contract tests above).
2. **android-build** (Linux): `flutter build apk --debug`. Verifies the
   Android toolchain compiles the app; it is **not** a signed release
   artifact.
3. **ios-build** (macOS): `flutter build ios --no-codesign`. Verifies the
   iOS toolchain compiles the app; it is **not** codesigned or
   distributable.

CI proves the app *compiles* for both platforms and passes tests. CI does
**not** prove runtime behavior on devices, signed packaging, accessibility
validation with real screen readers, or store readiness — those remain on
the manual checklist.
