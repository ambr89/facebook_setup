import 'package:facebook_setup_package/constants.dart';
import 'package:facebook_setup_package/main.dart' as facebook_setup_package;

void main(List<String> arguments) {
  print(introMessage('0.0.1'));
  facebook_setup_package.setFacebookKeys(arguments);
}