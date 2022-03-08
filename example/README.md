# Example with embedded setup

In this example, `facebook_setup` setup is embedded in `pubspec.yaml`.

## Apply `facebook_setup` :

```
flutter pub get
flutter pub run facebook_setup:main -f pubspec.yaml
```

# Example with separate setup

In this example, `facebook_setup` setup is in a separate `your_facebook_setup.yaml` file.

File name can be any of your choice.


## Apply `your_facebook_setup` :

```
flutter pub get
flutter pub run facebook_setup:main -f your_facebook_setup.yaml
```
