import 'package:xml/xml.dart';

import '../file_updater.dart';

class XmlStrings implements UpdateRule {
  XmlStrings(this.key, this.value);

  final String key;
  final String value;
  bool previousLineMatchedKey = false;
  bool changed = false;

  @override
  bool update(List<String> _data, XmlDocument document) {
    final totalKey = document.findAllElements('string');
    for (XmlElement elem in totalKey) {
      for (XmlAttribute attr in elem.attributes){
        if (attr.value == key){
          elem.innerText = value;
        }
      }
    }
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
