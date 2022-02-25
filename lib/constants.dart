String androidResFolder(String? flavor) => "android/app/src/${flavor ?? 'main'}/res/";
String androidColorsFile(String? flavor) => "android/app/src/${flavor ?? 'main'}/res/values/colors.xml";
const String androidManifestFile = 'android/app/src/main/AndroidManifest.xml';
const String androidGradleFile = 'android/app/build.gradle';
const String androidFileName = 'ic_launcher.png';
const String androidAdaptiveForegroundFileName = 'ic_launcher_foreground.png';
const String androidAdaptiveBackgroundFileName = 'ic_launcher_background.png';
String androidAdaptiveXmlFolder(String? flavor) => androidResFolder(flavor) + 'mipmap-anydpi-v26/';
const String androidDefaultIconName = 'ic_launcher';

const String iosDefaultIconFolder =
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/';
const String iosAssetFolder = 'ios/Runner/Assets.xcassets/';
const String iosConfigFile = 'ios/Runner.xcodeproj/project.pbxproj';
const String iosDefaultIconName = 'Icon-App';

const String errorMissingFbKey =
    'Missing "fb_key" o "fb_app_name" within configuration';
const String errorMissingPlatform =
    'No platform specified within config to generate icons for.';
const String noInfoPlistFileFoundName =
    'File Info.plist to get information from was not found: ';

String introMessage(String currentVersion) => '''
  ════════════════════════════════════════════
     FACEBOOK SETUP PACKAGE (v$currentVersion)                               
  ════════════════════════════════════════════
  ''';
