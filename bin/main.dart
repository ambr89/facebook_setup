import 'dart:io';
import 'package:facebook_setup/constants.dart';
import 'package:facebook_setup/main.dart' as facebook_setup;

void main(List<String> arguments) {
  stdout.writeln(introMessage('0.0.5'));
  facebook_setup.setFacebookKeys(arguments);
}
