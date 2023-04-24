import 'package:check_attendance_student/view/register_device.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:check_attendance_student/view/attendance_history.dart';
import 'package:check_attendance_student/view/login.dart';
import 'package:check_attendance_student/view/main_page.dart';
import 'package:check_attendance_student/view/settings_page.dart';
import 'package:intl/date_symbol_data_local.dart';

//달력 로컬라이징을 위한 async화와 initializeDateFormatting
void main() async{
  await initializeDateFormatting();
  runApp(App());}

/// 앱 이름에 해당되는 상수
const String appName = '전출 시스템';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final GoRouter _routes = GoRouter(routes: [
    // 앱 실행 시 가장 먼저 출력되는 페이지
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(
        appName: appName,
      ),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: 'register_device',
          builder: (context, state) => const RegisterDevicePage(),
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => const AttendanceHistoryPage(),
        ),
      ]
    ),

  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appName,
      routerConfig: _routes,
      theme: ThemeData(
        // Material3 테마를 사용할지에 대한 여부
          useMaterial3: true),
    );
  }
}
