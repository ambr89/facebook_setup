import 'package:xml/src/xml/nodes/document.dart';
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
  bool update(List<String> _data, XmlDocument xml) {
    for (int x = 0; x < _data.length; x++) {
      String line = _data[x];
      if (line.contains('<key>$key</key>')) {
        previousLineMatchedKey = true;
        changed = true;
        _data[x] = line;
        break;
      }
      if (!previousLineMatchedKey) {
        _data[x] = line;
        break;
      } else {
        previousLineMatchedKey = false;
        _data[x] = line.replaceAll(
            RegExp(r'<string>[^<]*</string>'), '<string>$value</string>');
        break;
      }
    }
    return true;
  }

  @override
  bool addXml(XmlDocument document) {
    // print('addXml in xml_manifest');
    final builder = XmlBuilder();
    final total = document.findElements('manifest').first.findElements('application');
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
    // print("xmlHasKey in xml_manifest");
    final totalKey = document.findAllElements('meta-data');
    bool exist = false;
    // print(totalKey);

    for (XmlElement elem in totalKey) {
      // print(elem);

      for (XmlAttribute attr in elem.attributes){
        // print(attr);
        // print(attr.name);
        // print(key);
        // print(attr.value == key);
        if (attr.value == key){
          exist = true;
          break;
        }
      }
    }
    // print("end");
    return exist;
  }
}
