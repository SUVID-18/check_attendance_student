import 'package:check_attendance_student/model/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// 로그인 페이지의 동작을 담당하는 클래스
class LoginViewModel with WidgetsBindingObserver {
  /// 사용자 ID에 해당되는 컨트롤러
  TextEditingController get emailController => _emailController;

  /// 로그인 관련 이벤트 발생 시 위젯을 띄우기 위한 [BuildContext]
  BuildContext context;

  /// 로그인 오류 여부 확인
  bool get isLoginError => _isLoginError;

  /// 사용자 이메일 계정 확인
  String get userEmail => _userEmail;

  @Deprecated('해당 컨트롤러는 더 이상 사용되지 않습니다. 다음 버전에서는 제거될 코드입니다.')

  /// 사용자 비밀번호에 해당되는 컨트롤러(더 이상 사용되지 않음)
  final passwordController = TextEditingController();

  final _emailController = TextEditingController();

  bool _isLoginError = false;

  final String _userEmail =
      FirebaseAuth.instance.currentUser?.email ?? '이메일 없음';

  /// 로그인 페이지의 동작을 담당하는 클래스의 생성자
  ///
  /// 로그인 페이지에서 필요한 부분에 대입시키면 된다.
  /// 로그인 링크 클릭을 인식하기 위해서는 아래 코드처럼 [initState]와
  /// [dispose]에 일부 코드 추가가 필요하다.
  ///
  /// 또한 로그인 관련 이벤트 발생 시 위젯을 띄우기 위해 [context]에 [BuildContext]를 전달해야 한다.
  /// [BuildContext]는 화면 구성 뒤에 생성되기에 `late`키워드를 붙여서 [context]에 넘겨지는 값이
  /// 추후 유효하다는 것을 명시해야한다.
  ///
  /// ```dart
  ///late var viewModel = LoginViewModel(context: context);
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   WidgetsBinding.instance.addObserver(viewModel);
  /// }
  ///
  /// @override
  /// void dispose() {
  ///   super.dispose();
  ///   WidgetsBinding.instance.removeObserver(viewModel);
  /// }
  ///
  ///TextField(
  ///             controller: viewModel.usernameController,
  ///             decoration: InputDecoration(
  ///                 filled: true,
  ///                 labelText: 'ID'
  ///             ),
  ///           ),
  ///```
  factory LoginViewModel({required BuildContext context}) =>
      LoginViewModel._init(context: context);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ((state != AppLifecycleState.resumed) &&
        _emailController.text.isNotEmpty) {
      SharedPreferences.getInstance().then((pref) async {
        await pref.setString('userEmail', _emailController.text);
      });
    } else if (state == AppLifecycleState.resumed) {
      try {
        FirebaseDynamicLinks.instance.onLink.listen((event) {
          _passwordlessLogin(event);
        });
      } catch (_) {
        throw Exception('Dynamic Link 관련 처리작업 실패');
      }
    }
  }

  void _passwordlessLogin(PendingDynamicLinkData event) async {
    if (_emailController.text.isNotEmpty &&
        FirebaseAuth.instance.isSignInWithEmailLink(event.link.toString())) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircularProgressIndicator.adaptive(),
                Text('  로그인 중...')
              ],
            ),
          ),
        ),
      );
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailLink(
                email: _emailController.text, emailLink: event.link.toString());

        var db = FirebaseFirestore.instance.collection('students');
        var document = await db.doc(userCredential.user!.uid).get();
        // 사용자의 객체가 서버에 등록이 되어있지 않은 경우 학생 객체 생성 및 전송
        if (!document.exists) {
          var student = Student(
              studentId: const Uuid().v4(),
              department: const Uuid().v4(),
              major: const Uuid().v4(),
              name: const Uuid().v4());
          var preference = await SharedPreferences.getInstance();
          await preference.setString(
              'attendanceStudentId', student.attendanceStudentId);
          db.doc(userCredential.user!.uid).set(student.toJson());
        }

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('로그인되었습니다.'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0))));
          context.go('/');
        }
      } catch (err) {
        Navigator.pop(context);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('로그인에 실패하였습니다.: ${err.toString()}'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0))));
          _isLoginError = true;
        }
      }
    }
  }

  /// 로그인 버튼을 누른 경우 수행할 동작

  /// 로그인 버튼의 `onPressed`에 해당 메서드를 등록하면 된다.
  /// ID와 비밀번호가 비어있을 시 [loginBlankDialog]에 제공된 `Dialog`를 띄우고
  /// 정상 입력을 할 시 로그인이 진행된다.
  ///
  /// ```dart
  /// ElevatedButton(
  ///      onPressed: () => viewModel.onSubmitPressed(
  ///          loginBlankDialog: AlertDialog(
  ///              title: Text('안내'),
  ///              content: Text('ID와 비밀번호를 모두 입력하십시요'),
  ///              actions: <Widget>[
  ///                TextButton(
  ///                    onPressed: () => Navigator.pop(context),
  ///                    child: Text('확인'))
  ///              ])),
  ///      child: Text('Next'))
  ///```
  void onSubmitPressed({required AlertDialog loginBlankDialog}) {
    if (_emailController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => loginBlankDialog,
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const Dialog(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircularProgressIndicator.adaptive(),
                Text('  로그인 링크 제작 중...')
              ],
            ),
          ),
        ),
      );
      var actionCodeSettings = ActionCodeSettings(
          url: 'https://suvid.page.link/login',
          handleCodeInApp: true,
          androidPackageName: 'com.suvid.check_attendance_student',
          androidInstallApp: true);
      FirebaseAuth.instance
          .sendSignInLinkToEmail(
          email: emailController.text,
          actionCodeSettings: actionCodeSettings)
          .catchError((error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('오류'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('확인'))
            ],
          ),
        );
      }).then((value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('로그인 진행을 위해 이메일로 전송된 링크를 클릭해주세요.'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0))));
      });
    }
  }

  /// 로그인 페이지 하단에 기기변경 신청 버튼 누를 시 동작

  /// 기기변경 신청 버튼의 `onPressed`에 해당 메서드를 등록하면 된다.
  ///
  /// ```dart
  /// ElevatedButton(
  ///        child: Text(
  ///          '기기변경 신청',
  ///          style: TextStyle(fontSize: 15),
  ///        ),
  ///        onPressed: () => viewModel.onChangePressed(),
  ///      ),
  ///```
  void onChangePressed() => context.push('/register_device');

  LoginViewModel._init({required this.context}) {
    SharedPreferences.getInstance().then((pref) {
      var email = pref.getString('userEmail');
      if (email != null) {
        _emailController.text = email;
      }
    });
    FirebaseDynamicLinks.instance.getInitialLink().then((initialLink) {
      if (initialLink != null) {
        _passwordlessLogin(initialLink);
      }
    });
  }
}
