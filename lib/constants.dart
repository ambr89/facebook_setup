String androidResFolder(String? flavor) =>
    "android/app/src/${flavor ?? 'main'}/res/";
String androidColorsFile(String? flavor) =>
    "android/app/src/${flavor ?? 'main'}/res/values/colors.xml";
const String androidGradleFile = 'android/app/build.gradle';
const String androidFileName = 'ic_launcher.png';
const String androidAdaptiveForegroundFileName = 'ic_launcher_foreground.png';
const String androidAdaptiveBackgroundFileName = 'ic_launcher_background.png';
String androidAdaptiveXmlFolder(String? flavor) =>
    androidResFolder(flavor) + 'mipmap-anydpi-v26/';
const String androidDefaultIconName = 'ic_launcher';

const String iosDefaultIconFolder =
    'ios/Runner/Assets.xcassets/AppIcon.appiconset/';
const String iosAssetFolder = 'ios/Runner/Assets.xcassets/';
const String iosConfigFile = 'ios/Runner.xcodeproj/project.pbxproj';
const String IOS_PLIST_FILE = "ios/Runner/Info.plist";
const String ANDROID_MANIFEST_FILE = "android/app/src/main/AndroidManifest.xml";
const String ANDROID_STRING_FILE =
    "android/app/src/main/res/values/strings.xml";
const String iosDefaultIconName = 'Icon-App';

const String errorMissingFbKey =
    'Missing "fb_key" o "fb_app_name" within configuration';
const String errorMissingPlatform =
    'No platform specified within config to generate icons for.';
const String noInfoPlistFileFoundName =
    'File Info.plist to get information from was not found in: ' +
        IOS_PLIST_FILE;
const String noManifestFileFoundName =
    'File AndroidManifest.xml to get information from was not found in: ' +
        ANDROID_MANIFEST_FILE;
const String noAndroidStringFileFoundName =
    'File string.xml to get information from was not found in: ' +
        ANDROID_STRING_FILE;

const String MANIFEST_STRING =
    '<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>'
    '<activity android:name="com.facebook.FacebookActivity"'
    ' android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"'
    ' android:label="@string/app_name" />'
    '<activity android:name="com.facebook.CustomTabActivity"'
    ' android:exported="true">'
    '<intent-filter>'
    '<action android:name="android.intent.action.VIEW" />'
    '<category android:name="android.intent.category.DEFAULT" />'
    '<category android:name="android.intent.category.BROWSABLE" />'
    '<data android:scheme="@string/fb_login_protocol_scheme" />'
    '</intent-filter>'
    '</activity>';

String introMessage(String currentVersion) => '''
  ════════════════════════════════════════════
     FACEBOOK SETUP PACKAGE (v$currentVersion)                               
  ════════════════════════════════════════════
  ''';
