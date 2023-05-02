import 'package:flutter_test/flutter_test.dart';
import 'package:check_attendance_student/main.dart';
import 'package:check_attendance_student/view/attendance.dart';

void main() {
  testWidgets('앱 구동 테스트', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());
  });
}