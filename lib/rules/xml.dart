import 'package:xml/src/xml/nodes/document.dart';
import 'package:xml/xml.dart';

import '../constants.dart';
import '../file_updater.dart';

class XmlStrings implements UpdateRule {
  XmlStrings(this.key, this.value);

  final String key;
  final String value;
  bool previousLineMatchedKey = false;
  bool changed = false;

  @override
  bool update(List<String> _data, XmlDocument document) {
    // print("update xml");
    // for (int x = 0; x < _data.length; x++) {
    //   String line = _data[x];
    //   print(line);
    //   if (line.contains('<string name="$key">')) {
    //     _data[x] = line.replaceAll(
    //         RegExp('<string name="$key">.*</string>'), '<string name="$key">$value</string>');
    //     break;
    //   }
    // }
    final totalKey = document.findAllElements('string');
    for (XmlElement elem in totalKey) {
      for (XmlAttribute attr in elem.attributes){
        if (attr.value == key){
          elem.innerText = value;
        }
      }
    }
    print(document);
    return true;
  }

  @override
  bool addXml(XmlDocument document) {
    final builder = XmlBuilder();
    final total = document.findElements('resources');
    builder.element('string', nest: () {
      builder.attribute('name', key);
      builder.text(value);
    });
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
    final totalKey = document.findAllElements('string');
    bool exist = false;
    for (XmlElement elem in totalKey) {
      for (XmlAttribute attr in elem.attributes){
        if (attr.value == key){
          exist = true;
          break;
        }
      }
    }
    return exist;
  }
}
