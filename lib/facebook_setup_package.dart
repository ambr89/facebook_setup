library facebook_setup_package;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
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


// Future<void> updateAndroidApplicationIdFromConfig(context) async {
//   stdout.writeln('Updating Android application name');
//   FileUpdater.updateFile(
//     File(ANDROID_MANIFEST_FILE),
//     XmlAttribute(
//       ANDROID_APPNAME_KEY,
//       config.android!.name!,
//     ),
//   );
// }

  Future<void> updateIosApplicationIdFromConfig(Map<String, dynamic> flutterIconsConfig) async {
    stdout.writeln('Updating iOS application name');
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
  }
}
