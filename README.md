<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
# Facebook setup

A command-line tool which simplifies the task of updating your Flutter app's Facebook-Login keys. 
Fully flexible, allowing you to choose what platform you wish to set.

It's base on setting [flutter_facebook_auth documentation](https://pub.dev/packages/flutter_facebook_auth)

## Features
- [x] Update android Facebook app id (into Manifest and string file)
- [x] Update iOS Facebook app id (into Plist)
- [ ] Update web settings


## Usage

### Setup the config file
Add your Facebook Setup configuration to your pubspec.yaml or create a new config file called facebook_setup.yaml. 
An example is shown below. 

```bash
dev_dependencies:
  facebook_setup_package: 0.0.1

facebook_setup:
  fb_app_id: "YOUR_FACEBOOK_KEY"
  fb_app_name: "YOUR_FACEBOOK_APP_NAME"
  android: true # set true if android platform is present in your project and you want set/add keys, false in other case
  ios: true # set true if iOS platform is present in your project and you want set/add keys, false in other case
```

### Run the package
After setting up the configuration, all that is left to do is run the package.

```bash
flutter pub get
flutter pub run facebook_setup:main -f facebook_setup.yaml
```

