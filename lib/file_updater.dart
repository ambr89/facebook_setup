import 'dart:io';
import 'package:xml/xml.dart';

class UpdateRule {
  bool update(List<String> _data, XmlDocument document) => false;
  bool updateFbBundle(List<String> _data, XmlDocument document) => false;
  bool hasChanged() => true;
  String getKey() => '';
  String getValue() => '';
  bool isXmlFile() => true;
  bool xmlHasKey(XmlDocument document) => false;
  bool addXml(XmlDocument document) => false;
}

class FileUpdater {
  FileUpdater(List<String> lines,XmlDocument document) : _data = lines, _xml = document;
  final List<String> _data;
  final XmlDocument _xml;

  static Future<void> updateFile(File file, UpdateRule updateRule) async {
    final FileUpdater fileUpdater = await FileUpdater.fromFile(file);

    bool fromXml = fileUpdater.update(updateRule);
    if (fromXml) {
      fileUpdater.toFileXml(file);
    }
    else {
      fileUpdater.toFile(file);
    }
  }

  static Future<void> updateIosBundle(File file, UpdateRule updateRule) async {
    final FileUpdater fileUpdater = await FileUpdater.fromFile(file);

    bool fromXml = fileUpdater.updateFbBundle(updateRule);
    if (fromXml) {
      fileUpdater.toFileXml(file);
    }
    else {
      fileUpdater.toFile(file);
    }
  }

  static FileUpdater fromString(String s) {
    return FileUpdater(s.split('\n'), XmlDocument.parse(s));
  }

  static Future<FileUpdater> fromFile(File file) async {
    return FileUpdater(await file.readAsLines(), XmlDocument.parse(file.readAsStringSync()));
  }

  Future<void> toFile(File file) async {
    await file.writeAsString(_data.join('\n'));
  }

  Future<void> toFileXml(File file) async {
    await file.writeAsString(_xml.toXmlString(pretty: true, indent: '\t'));
  }

  bool update(UpdateRule rule) {
    if (rule.isXmlFile()) {
      if (rule.xmlHasKey(_xml)) {
        return rule.update(_data, _xml);
      }
      else {
        rule.addXml(_xml);
        return true;
      }
    }
    else {
      rule.update(_data, _xml);
      // for (int x = 0; x < _data.length; x++) {
      //   _data[x] = rule.update(_data[x]);
      // }
      if (!rule.hasChanged()) {
        _data.insertAll(_data.length - 2, [rule.getKey(), rule.getValue()]);
      }
      return false;
    }
  }

  bool updateFbBundle(UpdateRule rule){
    // if (rule.isXmlFile()) {
    //   if (rule.xmlHasKey(_xml)) {
    //     return rule.updateFbBundle(_data, _xml);
    //   }
    //   else {
    //     rule.addXml(_xml);
    //     return true;
    //   }
    // }
    // return false;
    return rule.updateFbBundle(_data, _xml);
  }

  @override
  String toString() {
    return _data.join('\n');
  }
}

