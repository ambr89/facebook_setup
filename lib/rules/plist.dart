import 'package:xml/xml.dart';

import '../file_updater.dart';

class Plist implements UpdateRule {
  Plist(this.key, this.value);

  final String key;
  final String value;
  bool previousLineMatchedKey = false;
  bool changed = false;

  @override
  String update(String line) {
    if (line.contains('<key>$key</key>')) {
      previousLineMatchedKey = true;
      changed = true;
      return line;
    }

    if (!previousLineMatchedKey) {
      return line;
    } else {
      previousLineMatchedKey = false;
      return line.replaceAll(
          RegExp(r'<string>[^<]*</string>'), '<string>$value</string>');
    }
  }

  @override
  bool updateXml(String line) {
    return false;
  }

  @override
  bool hasChanged() {
    return changed;
  }

  String getKey(){
    return '        <key>$key</key>';
  }

  String getValue(){
    return '        <string>$value</string>';
  }

  bool xmlHasKey(XmlDocument document) {
    final totalKey = document.findAllElements('key');
    bool exist = false;
    for (XmlElement elem in totalKey) {
      if (elem.text == key){
        exist = true;
        break;
      }
    }
    return exist;
  }

  @override
  bool isXmlFile() {
    return true;
  }

  bool addXml(XmlDocument document) {
    final builder = XmlBuilder();
    final total = document.findElements('plist').first.findElements('dict');
    builder.element('key', nest: key);
    total.first.children.add(builder.buildFragment());
    builder.element('string', nest: value);
    total.first.children.add(builder.buildFragment());
    return true;
  }
}
