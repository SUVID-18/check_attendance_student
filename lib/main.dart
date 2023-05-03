import 'package:check_attendance_student/view/register_device.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:check_attendance_student/view/attendance_history.dart';
import 'package:check_attendance_student/view/login.dart';
import 'package:check_attendance_student/view/main_page.dart';
import 'package:check_attendance_student/view/register_device.dart';
import 'package:check_attendance_student/view/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 달력 로컬라이징을 위한 initializeDateFormatting
  await initializeDateFormatting();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

/// 앱 이름에 해당되는 상수
const String appName = '전출 시스템';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final GoRouter _routes = GoRouter(routes: [
    // 앱 실행 시 가장 먼저 출력되는 페이지
    GoRoute(
        path: '/',
        redirect: (context, state) async {
          var link = await FirebaseDynamicLinks.instance.getInitialLink();
          if (link != null && link.link.path == 'attendance') {
            return '/attendance/${link.link.queryParameters['id']}';
          } else {
            return null;
          }
        },
        builder: (context, state) => const MainPage(
              appName: appName,
            ),
        routes: [
          GoRoute(
            path: 'attendance/:id',
            // 여기서 pageBuilder를 사용할 수도 있는데, 페이지 전환 커스텀 애니메이션을 만들 수 있다는 장점이 있다고 한다.
            // 그런 경우에는 AttendancePage를 MaterialPage로 묶어야 한다.
            builder: (context, state) {
              String? uuid = state.params['id'];
              return AttendancePage(uuid: uuid!);
            },
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
        ]),

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
