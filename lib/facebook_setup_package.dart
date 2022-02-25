library facebook_setup_package;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'file_updater.dart';
import 'rules/plist.dart';


// /// A Calculator.
// class Calculator {
//   /// Returns [value] plus 1.
//   int addOne(int value) => value + 1;
// }

const String fileOption = 'file';
const String helpFlag = 'help';

const String IOS_PLIST_FILE = "ios/Runner/Info.plist";




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

  Future<void> updateIosApplicationIdFromConfig(String context) async {
    stdout.writeln('Updating iOS application name');
    var data = jsonDecode(await getJsonAsString(context));
    stdout.writeln(data);
    await FileUpdater.updateFile(
      File(IOS_PLIST_FILE),
      Plist(
        'FacebookAppID',
        data['FacebookAppID'],
      ),
    );
    await FileUpdater.updateFile(
      File(IOS_PLIST_FILE),
      Plist(
        'FacebookDisplayName',
        data['FacebookDisplayName'],
      ),
    );
  }
}
