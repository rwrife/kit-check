import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the claims made in `docs/platform-support.md`.
///
/// If a platform range, permission set, or release-metadata value drifts
/// from the documented contract, these tests fail and the docs must be
/// updated in the same change.
void main() {
  final mainManifest = File('android/app/src/main/AndroidManifest.xml');
  final gradleConfig = File('android/app/build.gradle.kts');
  final pbxproj = File('ios/Runner.xcodeproj/project.pbxproj');
  final iosInfoPlist = File('ios/Runner/Info.plist');
  final pubspec = File('pubspec.yaml');

  group('Android platform contract', () {
    late String manifest;
    late String gradle;

    setUpAll(() {
      manifest = mainManifest.readAsStringSync();
      gradle = gradleConfig.readAsStringSync();
    });

    test('release manifest declares the documented permission set', () {
      // Documented: the release build requests NO permissions at all.
      final usesPermissions = RegExp('<uses-permission')
          .allMatches(manifest)
          .map((m) => m.group(0)!);
      expect(
        usesPermissions,
        isEmpty,
        reason: '''
docs/platform-support.md states the Android release build declares no
<uses-permission> entries. If a permission is being added intentionally,
update the docs with its user-facing purpose in the same change.''',
      );
    });

    test('minSdk/targetSdk follow the documented Flutter defaults', () {
      // Documented: min 24, target 36 via flutter.minSdkVersion /
      // flutter.targetSdkVersion (Flutter 3.47.x defaults).
      expect(
        gradle,
        contains('minSdk = flutter.minSdkVersion'),
        reason:
            'docs/platform-support.md documents minSdk = '
            'flutter.minSdkVersion (API 24). Pinning a literal elsewhere '
            'requires updating the docs.',
      );
      expect(
        gradle,
        contains('targetSdk = flutter.targetSdkVersion'),
        reason:
            'docs/platform-support.md documents targetSdk = '
            'flutter.targetSdkVersion (API 36).',
      );
    });

    test('applicationId matches the documented identifier', () {
      expect(gradle, contains('applicationId = "dev.rwrife.kit_check"'));
    });

    test('release signing still uses the debug config (unsigned warning)', () {
      // docs/platform-support.md explicitly warns that release artifacts
      // are NOT distribution-signed while this TODO-style config stands.
      // If real signing lands, update the docs' artifact table in the
      // same change — do not silently change this assertion only.
      expect(
        gradle,
        contains('signingConfig = signingConfigs.getByName("debug")'),
        reason:
            'Release builds currently use the debug signing key. If '
            'you wired real signing, update the unsigned-vs-signed table '
            'in docs/platform-support.md first.',
      );
    });
  });

  group('iOS platform contract', () {
    late String project;
    late String plist;

    setUpAll(() {
      project = pbxproj.readAsStringSync();
      plist = iosInfoPlist.readAsStringSync();
    });

    test('deployment target matches the documented iOS range', () {
      expect(
        RegExp('IPHONEOS_DEPLOYMENT_TARGET = 15.0').hasMatch(project),
        isTrue,
        reason:
            'docs/platform-support.md documents iOS 15.0+; update the '
            'docs together with any deployment-target change.',
      );
    });

    test('targets iPhone only', () {
      expect(
        RegExp(r'TARGETED_DEVICE_FAMILY = 1;').allMatches(project).length,
        3,
        reason:
            'docs/platform-support.md documents iPhone-only support; '
            'all iOS build configurations must target device family 1.',
      );
      expect(project.contains('TARGETED_DEVICE_FAMILY = "1,2";'), isFalse);
    });

    test('Info.plist declares no privacy permission prompts', () {
      // Documented: no camera, location, contacts, microphone, photos,
      // Face ID, or background modes.
      final usageDescriptions = RegExp('NS[A-Za-z]+UsageDescription')
          .allMatches(plist);
      expect(
        usageDescriptions,
        isEmpty,
        reason: '''
docs/platform-support.md states the iOS build requests no permissions.
Any new NS*UsageDescription key needs a documented user-facing purpose
added to the docs in the same change.''',
      );
      expect(plist.contains('UIBackgroundModes'), isFalse);
    });

    test('bundle identifier matches the documented release metadata', () {
      // docs/platform-support.md documents com.infinityball.kitcheck as the
      // iOS bundle identifier. Any change must land with the docs.
      expect(
        RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = com\.infinityball\.kitcheck;')
            .hasMatch(project),
        isTrue,
        reason:
            'docs/platform-support.md documents the iOS bundle id as '
            'com.infinityball.kitcheck; update the docs together with any '
            'identifier change.',
      );
    });
  });

  group('Release metadata contract', () {
    test('pubspec version matches the documented release metadata', () {
      final pubspecText = pubspec.readAsStringSync();
      expect(
        pubspecText.contains('version: 1.0.0+1'),
        isTrue,
        reason:
            'docs/platform-support.md documents version 1.0.0+1; bump '
            'the docs together with the app version.',
      );
    });

    test('package is not published to pub.dev', () {
      expect(pubspec.readAsStringSync().contains("publish_to: 'none'"), isTrue);
    });
  });
}
