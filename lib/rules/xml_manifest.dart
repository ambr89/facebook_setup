import 'package:xml/xml.dart';

import '../constants.dart';
import '../file_updater.dart';

class XmlManifest implements UpdateRule {
  XmlManifest(this.key, this.value);

  final String key;
  final String value;
  bool previousLineMatchedKey = false;
  bool changed = false;

  @override
  bool update(List<String> _data, XmlDocument document) {
    // for (int x = 0; x < _data.length; x++) {
    //   String line = _data[x];
    //   if (line.contains('<key>$key</key>')) {
    //     previousLineMatchedKey = true;
    //     changed = true;
    //     _data[x] = line;
    //     break;
    //   }
    //   if (!previousLineMatchedKey) {
    //     _data[x] = line;
    //     break;
    //   } else {
    //     previousLineMatchedKey = false;
    //     _data[x] = line.replaceAll(
    //         RegExp(r'<string>[^<]*</string>'), '<string>$value</string>');
    //     break;
    //   }
    // }
    return true;
  }

  @override
  bool addXml(XmlDocument document) {
    final builder = XmlBuilder();
    final total =
        document.findElements('manifest').first.findElements('application');
    builder.xml(MANIFEST_STRING);
    total.first.children.add(builder.buildFragment());
    return true;
  }

  @override
  String getKey() {
    return key;
  }

  @override
  String getValue() {
    return value;
  }

  @override
  bool hasChanged() {
    return changed;
  }

  @override
  bool isXmlFile() {
    return true;
  }

  @override
  bool xmlHasKey(XmlDocument document) {
    final totalKey = document.findAllElements('meta-data');
    bool exist = false;
    for (XmlElement elem in totalKey) {
      for (XmlAttribute attr in elem.attributes) {
        if (attr.value == key) {
          exist = true;
          break;
        }
      }
    }
    return exist;
  }

  @override
  bool updateFbBundle(List<String> _data, XmlDocument document) {
    // TODO: implement updateArray
    throw UnimplementedError();
  }

  @override
  bool xmlHasKeyArray(XmlDocument document) {
    // TODO: implement xmlHasKeyArray
    throw UnimplementedError();
  }

  @override
  bool addBundleURLSchemes(XmlDocument document) {
    // TODO: implement addFbBundle
    throw UnimplementedError();
  }
}
