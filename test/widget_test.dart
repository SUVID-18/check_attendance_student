// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:check_attendance_student/main.dart';

void main() {
  testWidgets('앱 구동 테스트', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());
  });
}
