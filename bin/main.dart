import 'dart:io';
import 'package:facebook_setup_package/constants.dart';
import 'package:facebook_setup_package/main.dart' as facebook_setup;

void main(List<String> arguments) {
  stdout.writeln(introMessage('0.0.1'));
  facebook_setup.setFacebookKeys(arguments);
}