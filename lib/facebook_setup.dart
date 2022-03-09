library facebook_setup;

import 'dart:async';
import 'dart:io';
import 'package:facebook_setup/rules/xml.dart';
import 'package:facebook_setup/rules/xml_manifest.dart';

import 'constants.dart';
import 'file_updater.dart';
import 'rules/plist.dart';

const String fileOption = 'file';
const String helpFlag = 'help';

class Updater {
  Future<String> getJsonAsString(String context) async {
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
    stdout.writeln('Updated Android Manifest');
  }

  Future<void> updateAndroidStringFromConfig(
      Map<String, dynamic> config) async {
    stdout.writeln('Updating Android application name');
    await FileUpdater.updateFile(
      File(ANDROID_STRING_FILE),
      XmlStrings(
        "app_name",
        config['fb_app_name'].toString(),
      ),
    );
    await FileUpdater.updateFile(
      File(ANDROID_STRING_FILE),
      XmlStrings(
        "facebook_app_id",
        config['fb_app_id'].toString(),
      ),
    );
    await FileUpdater.updateFile(
      File(ANDROID_STRING_FILE),
      XmlStrings(
        "fb_login_protocol_scheme",
        'fb' + config['fb_app_id'].toString(),
      ),
    );
    stdout.writeln('Updated Android  application name');
  }

  Future<void> updateIosApplicationIdFromConfig(
      Map<String, dynamic> config) async {
    stdout.writeln('Updating iOS facebook id');
    await FileUpdater.updateFile(
      File(IOS_PLIST_FILE),
      Plist(
        'FacebookAppID',
        config['fb_app_id'].toString(),
      ),
    );
    await FileUpdater.updateFile(
      File(IOS_PLIST_FILE),
      Plist(
        'FacebookDisplayName',
        config['fb_app_name'].toString(),
      ),
    );
    await FileUpdater.updateIosBundleURL(
      File(IOS_PLIST_FILE),
      Plist(
        '',
        'fb' + config['fb_app_id'].toString(),
      ),
    );
    stdout.writeln('Updated iOS facebook id');
  }
}
