import 'package:flutter_test/flutter_test.dart';

import 'package:facebook_setup_package/facebook_setup_package.dart';

// void main() {
//   test('adds one to input values', () {
//     final calculator = Calculator();
//     expect(calculator.addOne(2), 3);
//     expect(calculator.addOne(-7), -6);
//     expect(calculator.addOne(0), 1);
//   });
// }

void main() {
  // String context = arguments[0].toString();
  test('replaces values correctly', () {
    final updater = Updater();
    expect(updater.updateIosApplicationIdFromConfig("context"), true);
    expect(updater.updateIosApplicationIdFromConfig("ciao"), true);
  });
}
