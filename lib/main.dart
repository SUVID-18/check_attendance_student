import 'package:check_attendance_student/view/attendance.dart';
import 'package:check_attendance_student/view/register_device.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:check_attendance_student/view/attendance_history.dart';
import 'package:check_attendance_student/view/login.dart';
import 'package:check_attendance_student/view/main_page.dart';
import 'package:check_attendance_student/view/settings_page.dart';
import 'package:intl/date_symbol_data_local.dart';

//달력 로컬라이징을 위한 async화와 initializeDateFormatting
//

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp();
  final PendingDynamicLinkData? pendingLink = await FirebaseDynamicLinks.instance.getInitialLink();
  runApp(App(dynamicLink : pendingLink));}

/// 앱 이름에 해당되는 상수
const String appName = '전출 시스템';

class App extends StatelessWidget {
  final PendingDynamicLinkData? dynamicLink;
  App({Key? key, this.dynamicLink}) : super(key: key);

  final GoRouter _routes = GoRouter(routes: [
    // 앱 실행 시 가장 먼저 출력되는 페이지
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(
        appName: appName,
      ),
      routes: [
        GoRoute(
          path: 'attendance',
          builder: (context, state) => const AttendancePage(),
        ),
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
      builder: (context, child) {
        // 다이나믹 링크가 있을 경우 AttendancePage를 띄우고, 앱 버튼을 눌러서 띄웠다면 MainPage를 띄운다.
        if (dynamicLink!=null){
          return const AttendancePage();
        }
        else {
          return const MainPage(appName: appName);
        }
      },
      theme: ThemeData(
        // Material3 테마를 사용할지에 대한 여부
          useMaterial3: true),
    );
  }
}
