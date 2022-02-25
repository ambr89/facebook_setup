library package_test;

import 'dart:io';

import 'package:args/args.dart';
import 'package:facebook_setup_package/facebook_setup_package.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:facebook_setup_package/custom_exceptions.dart';

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
      createSettingFromConfig(yamlConfig);
      print('\n✓ Successfully generated launcher icons');
    } catch (e) {
      stderr.writeln('\n✕ Could not generate launcher icons');
      stderr.writeln(e);
      exit(2);
    }
  } else {
    try {
      for (String flavor in flavors) {
        print('\nFlavor: $flavor');
        final Map<String, dynamic> yamlConfig =
        loadConfigFile(flavorConfigFile(flavor), flavorConfigFile(flavor));
        await createSettingFromConfig(yamlConfig, flavor);
      }
      print('\n✓ Successfully generated launcher icons for flavors');
    } catch (e) {
      stderr.writeln('\n✕ Could not generate launcher icons for flavors');
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

  if ((yamlMap['flutter_icons'] is! Map)) {
    stderr.writeln(NoConfigFoundException('Check that your config file '
        '`${fileOptionResult ?? defaultConfigFile}`'
        ' has a `flutter_icons` section'));
    exit(1);
  }

  // yamlMap has the type YamlMap, which has several unwanted sideeffects
  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap['flutter_icons'].entries) {
    config[entry.key.toString()] = entry.value;
  }

  return config;
}


Future<void> createSettingFromConfig(Map<String, dynamic> config,
    [String? flavor]) async {

  print("TODOOO" );
  print(config);

  //final updater = Updater();
  //updater.updateIosApplicationIdFromConfig(context);

  // if (!isImagePathInConfig(config)) {
  //   throw const InvalidConfigException(errorMissingImagePath);
  // }
  // if (!hasPlatformConfig(config)) {
  //   throw const InvalidConfigException(errorMissingPlatform);
  // }
  //
  // if (isNeedingNewAndroidIcon(config) || hasAndroidAdaptiveConfig(config)) {
  //   final int minSdk = android_launcher_icons.minSdk();
  //   if (minSdk < 26 &&
  //       hasAndroidAdaptiveConfig(config) &&
  //       !hasAndroidConfig(config)) {
  //     throw const InvalidConfigException(errorMissingRegularAndroid);
  //   }
  // }
  //
  // if (isNeedingNewAndroidIcon(config)) {
  //   android_launcher_icons.createDefaultIcons(config, flavor);
  // }
  // if (hasAndroidAdaptiveConfig(config)) {
  //   android_launcher_icons.createAdaptiveIcons(config, flavor);
  // }
  // if (isNeedingNewIOSIcon(config)) {
  //   ios_launcher_icons.createIcons(config, flavor);
  // }
}