import 'package:xml/xml.dart';

import '../file_updater.dart';

class Plist implements UpdateRule {
  Plist(this.key, this.value);

  final String key;
  final String value;
  bool previousLineMatchedKey = false;
  bool changed = false;

  @override
  bool update(List<String> _data, XmlDocument document) {
    for (int x = 0; x < _data.length; x++) {
      String line = _data[x];
      if (line.contains('<key>$key</key>')) {
        previousLineMatchedKey = true;
        continue;
      }
      if (!previousLineMatchedKey) {
        _data[x] = line;
      } else {
        changed = true;
        previousLineMatchedKey = false;
        _data[x] = line.replaceAll(
            RegExp(r'<string>[^<]*</string>'), '<string>$value</string>');
        break;
      }
    }
    return false;
  }

  @override
  bool hasChanged() {
    return changed;
  }

  @override
  String getKey(){
    return '        <key>$key</key>';
  }

  @override
  String getValue(){
    return '        <string>$value</string>';
  }

  @override
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

  @override
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
