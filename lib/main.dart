library package_test;

import 'dart:io';
import 'constants.dart';
import 'package:args/args.dart';
import 'package:facebook_setup_package/facebook_setup_package.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:facebook_setup_package/custom_exceptions.dart';
import 'package:facebook_setup_package/constants.dart';

import 'custom_exceptions.dart';

// test region
//
// /// A Calculator.
// class Calculator {
//   /// Returns [value] plus 1.
//   int addOne(int value) => value + 1;
// }
//
// // end region test



const String helpFlag = 'help';
const String fileOption = 'file';
const String defaultConfigFile = 'package_test.yaml';
const String flavorConfigFilePattern = r'^package_test-(.*).yaml$';
String flavorConfigFile(String flavor) => 'package_tests-$flavor.yaml';

List<String> getFlavors() {
  final List<String> flavors = [];
  for (var item in Directory('.').listSync()) {
    if (item is File) {
      final name = path.basename(item.path);
      final match = RegExp(flavorConfigFilePattern).firstMatch(name);
      if (match != null) {
        flavors.add(match.group(1)!);
      }
    }
  }
  return flavors;
}

Future<void> setFacebookKeys(List<String> arguments) async {

  final ArgParser parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(helpFlag, abbr: 'h', help: 'Usage help', negatable: false);
  // Make default null to differentiate when it is explicitly set
  parser.addOption(fileOption,
      abbr: 'f', help: 'Config file (default: $defaultConfigFile)');
  final ArgResults argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    stdout.writeln('Generates icons for iOS and Android');
    stdout.writeln(parser.usage);
    exit(0);
  }

  // Flavors manangement
  final flavors = getFlavors();
  final hasFlavors = flavors.isNotEmpty;

  // Load the config file
  final Map<String, dynamic>? yamlConfig =
  loadConfigFileFromArgResults(argResults, verbose: true);

  if (yamlConfig == null) {
    throw const NoConfigFoundException();
  }

  // Create icons
  if (!hasFlavors) {
    try {
      await createSettingFromConfig(yamlConfig);
      stdout.writeln('\n✓ Successfully updated facebook credentials');
    } catch (e) {
      stderr.writeln('\n✕ Could not update facebook credentials');
      stderr.writeln(e);
      exit(2);
    }
  } else {
    try {
      for (String flavor in flavors) {
        stdout.writeln('\nFlavor: $flavor');
        final Map<String, dynamic> yamlConfig =
        loadConfigFile(flavorConfigFile(flavor), flavorConfigFile(flavor));
        await createSettingFromConfig(yamlConfig, flavor);
      }
      stdout.writeln('\n✓ Successfully updated facebook credentials for flavors');
    } catch (e) {
      stderr.writeln('\n✕ Could not update facebook credentials for flavors');
      stderr.writeln(e);
      exit(2);
    }
  }

}


Map<String, dynamic>? loadConfigFileFromArgResults(ArgResults argResults,
    {bool verbose = false}) {
  final String? configFile = argResults[fileOption].toString();
  final String? fileOptionResult = argResults[fileOption].toString();

  // if icon is given, try to load icon
  if (configFile != null && configFile != defaultConfigFile) {
    try {
      return loadConfigFile(configFile, fileOptionResult);
    } catch (e) {
      if (verbose) {
        stderr.writeln(e);
      }

      return null;
    }
  }

  // If none set try flutter_launcher_icons.yaml first then pubspec.yaml
  // for compatibility
  try {
    return loadConfigFile(defaultConfigFile, fileOptionResult);
  } catch (e) {
    // Try pubspec.yaml for compatibility
    if (configFile == null) {
      try {
        return loadConfigFile('pubspec.yaml', fileOptionResult);
      } catch (_) {}
    }

    // if nothing got returned, print error
    if (verbose) {
      stderr.writeln(e);
    }
  }

  return null;
}

Map<String, dynamic> loadConfigFile(String path, String? fileOptionResult) {
  final File file = File(path);
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  if ((yamlMap['facebook_setup_package'] is! Map)) {
    stderr.writeln(NoConfigFoundException('Check that your config file '
        '`${fileOptionResult ?? defaultConfigFile}`'
        ' has a `facebook_setup_package` section'));
    exit(1);
  }

  // yamlMap has the type YamlMap, which has several unwanted sideeffects
  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap['facebook_setup_package'].entries) {
    config[entry.key.toString()] = entry.value;
  }

  return config;
}


Future<void> createSettingFromConfig(Map<String, dynamic> config,
    [String? flavor]) async {

  if (!isFbKeyInConfig(config)) {
    throw const InvalidConfigException(errorMissingFbKey);
  }

  if (!hasPlatformConfig(config)) {
    throw const InvalidConfigException(errorMissingPlatform);
  }

  final updater = Updater();
  if (isNeedingNewIOS(config)) {
    print("--- Updating IOS ---");
    if (await plistExist()) {
      await updater.updateIosApplicationIdFromConfig(config);
    }
    else {
      throw const NoInfoPlistFileFoundException(noInfoPlistFileFoundName);
    }
  }
  if (isNeedingNewAndroid(config)) {
    print("--- Updating Android Manifest ---");
    if (await manifestExist()) {
      await updater.updateAndroidManifestFromConfig(config);
    }
    else {
      throw const NoManifestFileFoundException(noManifestFileFoundName);
    }
    print("--- Updating Android Strings ---");
    if (await xmlStringExist()) {
      await updater.updateAndroidStringFromConfig(config);
    }
    else {
      throw const NoAndroidStringFileFoundException(noAndroidStringFileFoundName);
    }
  }

  stdout.writeln("------------------------------------------");

}


bool isFbKeyInConfig(Map<String, dynamic> flutterIconsConfig) {
  return flutterIconsConfig.containsKey('fb_app_id')
      && flutterIconsConfig.containsKey('fb_app_name');
}

bool hasPlatformConfig(Map<String, dynamic> flutterIconsConfig) {
  return hasAndroidConfig(flutterIconsConfig) ||
      hasIOSConfig(flutterIconsConfig);
}
bool hasAndroidConfig(Map<String, dynamic> flutterLauncherIcons) {
  return flutterLauncherIcons.containsKey('android');
}
bool hasIOSConfig(Map<String, dynamic> flutterLauncherIconsConfig) {
  return flutterLauncherIconsConfig.containsKey('ios');
}

bool isNeedingNewIOS(Map<String, dynamic> flutterLauncherIconsConfig) {
  return hasIOSConfig(flutterLauncherIconsConfig) &&
      flutterLauncherIconsConfig['ios'] != false;
}

bool isNeedingNewAndroid(Map<String, dynamic> flutterLauncherIconsConfig) {
  return hasAndroidConfig(flutterLauncherIconsConfig) &&
      flutterLauncherIconsConfig['android'] != false;
}

Future<bool> plistExist() async {
  var syncPath = IOS_PLIST_FILE;
  bool exist = await File(syncPath).exists();
  return exist;
}

Future<bool> manifestExist() async {
  var syncPath = ANDROID_MANIFEST_FILE;
  bool exist = await File(syncPath).exists();
  return exist;
}

Future<bool> xmlStringExist() async {
  var syncPath = ANDROID_STRING_FILE;
  bool exist = await File(syncPath).exists();
  return exist;
}