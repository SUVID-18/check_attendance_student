import 'dart:async';

import 'package:check_attendance_student/firebase_options.dart';
import 'package:check_attendance_student/view/attendance.dart';
import 'package:check_attendance_student/view/attendance_history.dart';
import 'package:check_attendance_student/view/login.dart';
import 'package:check_attendance_student/view/register_device.dart';
import 'package:check_attendance_student/view/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
// 백그라운드에서 메세지를 핸들링 하는 프라이빗 메서드
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('핸들링 메세지 : ${message.messageId}');
}

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 토큰 변경 감지 시 Firestore의 토큰 필드 업데이트
  FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) async {

    var currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid!=null){
      // var docRef = FirebaseFirestore.instance.collection('student').doc(currentUid).get();
      FirebaseFirestore.instance.collection('student').doc(currentUid).update({
        'token': newToken
      });
    }
  });

  runApp(App());
}

/// 앱 이름에 해당되는 상수
const String appName = '전출 시스템';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
        redirect: loginRedirect,
        path: '/',
        builder: (context, state) => const AttendanceHistoryPage(),
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
        ]),
  ]);

  @override
  void initState() {
    super.initState();

    _requestPermission();

    _checkGoogleApiAvailability();

    setupInteractedMessage();
    // 알림을 클릭했을 때

  }

  /// 앱의 알림 권한을 승인하기 위한 private 메서드.
  _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.requestPermission(
      alert: true,
    )
        .then((permissionResult) {
      if (permissionResult.authorizationStatus == AuthorizationStatus.denied) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: const Text('경고'),
                content:
                    const Text('알림 기능을 허용하지 않으면 출결 변동 알림을 받지 못할 수도 있습니다.')));
      }
    });
  }

  /// Google Play Service 설치를 확인하는 private 메서드.
  _checkGoogleApiAvailability() async {
    GooglePlayServicesAvailability checkResult = await GoogleApiAvailability
        .instance
        .checkGooglePlayServicesAvailability();
    print('구글 서비스 승인 확인 : ${checkResult.value.toInt()}');
    if (checkResult.value ==
        GooglePlayServicesAvailability.serviceMissing.value) {
      try {
        await GoogleApiAvailability.instance.makeGooglePlayServicesAvailable();
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
      if (message.notification != null){
         context.go('/');
      }
  }

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
