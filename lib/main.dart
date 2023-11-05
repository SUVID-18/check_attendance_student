import 'package:check_attendance_student/firebase_options.dart';
import 'package:check_attendance_student/view/attendance.dart';
import 'package:check_attendance_student/view/attendance_history.dart';
import 'package:check_attendance_student/view/login.dart';
import 'package:check_attendance_student/view/main_page.dart';
import 'package:check_attendance_student/view/register_device.dart';
import 'package:check_attendance_student/view/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

@pragma('vm:entry-point')
// 백그라운드에서 메세지를 핸들링 하는 프라이빗 메서드
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{

  await Firebase.initializeApp();
  print('핸들링 메세지 : ${message.messageId}');

}





//달력 로컬라이징을 위한 async화와 initializeDateFormatting
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
  );




  // FirebaseMessaging.instance.onTokenRefresh.listen((event) async{
    // 토큰을 새로 생성했을 때 실행되는 메서드이다.
    // 즉, 새로운 기기가 생성되거나 기기에 변경이 생길 때 활성화됨.
    // 근데, 기기를 변경할 때도 리스닝 되므로 새로운 사용자가 생겼다고 인식할 수는 없다.
    // 물론 일반적인 경우에서는 필요하다. 아마 여기서 데이터베이스를 건드는 코드를 추가하면 될듯.
    // 권한 설정을 허용하는 것을 물어보는 항목이 필요할 것 같음.
    // 앱에 권한이 부여되어 있지 않았음.

    // 토큰을 요청하여 받아옴.
    // var token = await FirebaseMessaging.instance.getToken();
    // var currentUid = FirebaseAuth.instance.currentUser?.uid;
    //
    // // 쿼리 스냅샷을 받아옴
    // final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('student').where{}
    // if (currentUid!=null){
    //   var docRef = FirebaseFirestore.instance.collection('student').doc(currentUid);
    //   //
    //   if (docRef.get!=null) {
    //     FirebaseFirestore.instance.collection('student').doc(currentUid).update({
    //       "token": token
    //     });
    //   }
    //
    // }


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
        redirect: (context, state) async {
          var link = await FirebaseDynamicLinks.instance.getInitialLink();
          if (FirebaseAuth.instance.currentUser == null) {
            return '/login';
            // 로그인이 안되어있으면 출결 페이지 안띄움
          } else if (link != null && link.link.path == 'attendance') {
            return '/attendance/${link.link.queryParameters['id']}';
          } else {
            return null;
          }
        },

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
  void initState() {
    super.initState();
    // 알림을 클릭했을
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          print(message.notification!.title.toString());
          print(message.notification!.body.toString());
          // print(message.data["click_action"]);
        }
      }
    });
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
