library facebook_setup_package;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:facebook_setup_package/rules/xml.dart';
import 'package:facebook_setup_package/rules/xml_manifest.dart';

import 'constants.dart';
import 'file_updater.dart';
import 'rules/plist.dart';


// /// A Calculator.
// class Calculator {
//   /// Returns [value] plus 1.
//   int addOne(int value) => value + 1;
// }

const String fileOption = 'file';
const String helpFlag = 'help';


class Updater {
  Future<String> getJsonAsString(String context) async{
    String filename = 'assets/customizations/ios/Runner/Info_$context.json';
    var config = File(filename);

    // Put the whole file in a single string.
    var stringContents = await config.readAsString();
    return stringContents;
  }


  Future<void> updateAndroidManifestFromConfig(context) async {
    stdout.writeln('Updating Android Manifest');
    await FileUpdater.updateFile(
      File(ANDROID_MANIFEST_FILE),
      XmlManifest(
        'com.facebook.sdk.ApplicationId',
        '@string/facebook_app_id',
      ),
    );
    stdout.writeln('Updated Android Manifest ---- ');
  }

  Future<void> updateAndroidStringFromConfig(context) async {
    stdout.writeln('Updating Android application name');
    await FileUpdater.updateFile(
      File(ANDROID_STRING_FILE),
      XmlAttribute(
        'com.facebook.sdk.ApplicationId',
        '@string/facebook_app_id',
      ),
    );
  }

  Future<void> updateIosApplicationIdFromConfig(Map<String, dynamic> flutterIconsConfig) async {
    stdout.writeln('Updating iOS facebook id');
    await FileUpdater.updateFile(
      File(IOS_PLIST_FILE),
      Plist(
        'FacebookAppID',
        flutterIconsConfig['fb_app_id'].toString(),
      ),
    );
    await FileUpdater.updateFile(
      File(IOS_PLIST_FILE),
      Plist(
        'FacebookDisplayName',
        flutterIconsConfig['fb_app_name'].toString(),
      ),
    );
    stdout.writeln('Updated iOS facebook id ---- ');
  }
}
