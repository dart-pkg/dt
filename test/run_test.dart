// ignore_for_file: prefer_single_quotes
import 'package:test/test.dart';
import 'package:output/output.dart';
import 'package:dt/dt.dart';

void main() {
  group('Run', () {
    test('run1', () {
      var calc = Calculator();
      var result = calc.addOne(123);
      dump(result, 'result');
    });
  });
}
