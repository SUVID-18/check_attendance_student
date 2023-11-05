import 'dart:async';

import 'package:check_attendance_student/firebase_options.dart';
import 'package:check_attendance_student/view/attendance.dart';
import 'package:check_attendance_student/view/attendance_fake.dart';
import 'package:check_attendance_student/view/attendance_history.dart';
import 'package:check_attendance_student/view/login.dart';
import 'package:check_attendance_student/view/main_page.dart';
import 'package:check_attendance_student/view/register_device.dart';
import 'package:check_attendance_student/view/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

/// 릴리즈 모드 여부에 따라 리다이렉트 여부를 지정하는 함수
///
/// 릴리즈 모드인 경우 로그인이 되어있지 않은 경우 로그인을 진행하도록 강제한다.
/// 릴리즈 모드가 아닌 경우 원할한 개발을 위해 로그인 과정을 건너뛴다.
FutureOr<String?> loginRedirect(context, state) async {
  if (!kReleaseMode) {
    return null;
  }
  var link = await FirebaseDynamicLinks.instance.getInitialLink();
  if (FirebaseAuth.instance.currentUser == null) {
    return '/login';
    // 로그인이 안되어있으면 출결 페이지 안띄움
  } else if (link != null && link.link.path == 'attendance') {
    return '/attendance/${link.link.queryParameters['id']}';
  } else {
    return null;
  }
}

//달력 로컬라이징을 위한 async화와 initializeDateFormatting
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

/// 앱 이름에 해당되는 상수
const String appName = '전출 시스템';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final GoRouter _routes = GoRouter(routes: [
    // 앱 실행 시 가장 먼저 출력되는 로그인 페이지
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    // 로그인과 관계없이 기기변경 요청은 들어가져야 함
    GoRoute(
      path: '/register_device',
      builder: (context, state) => const RegisterDevicePage(),
    ),
    GoRoute(
        ///차단방지
        redirect: loginRedirect,
        path: '/',
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
            path: 'attendance_fake/:id',
            builder: (context, state) {
              String? uuid = state.params['id'];
              return FakeAttendancePage(uuid: uuid!);
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
