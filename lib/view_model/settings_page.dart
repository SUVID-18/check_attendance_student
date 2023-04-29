import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 설정 페이지의 동작을 담당하는 클래스
class SettingsPageViewModel {
  /// 특정 메서드에서 위젯을 띄우기 위한 [BuildContext]
  BuildContext context;

  /// 사용자 이름에 해당되는 읽기전용 속성
  String get userName => _userName;

  /// 사용자 학번 해당되는 읽기전용 속성
  String get studentId => _studentId;

  /// 사용자 전공에 해당되는 읽기전용 속성
  String get userMajor => _userMajor;

  /// 사용자 이메일 계정 확인
  String get userEmail => _userEmail;

  late final String _userName;
  late final String _studentId;
  late final String _userMajor;
  final String _userEmail =
      FirebaseAuth.instance.currentUser?.email ?? '이메일 없음';

  /// 설정 페이지의 동작을 담당하는 생성자
  ///
  /// 설정 페이지에서 필요한 부분에 대입시키면 된다.
  /// 또한 특정 메서드에서 위젯을 띄우기 위해 [context]에 [BuildContext]를 전달해야 한다.
  /// [BuildContext]는 화면 구성 뒤에 생성되기에 `late`키워드를 붙여서 [context]에 넘겨지는 값이
  /// 추후 유효하다는 것을 명시해야한다.
  ///
  /// ```dart
  ///late var viewModel = SettingsPageViewModel(context: context);
  ///  Card(
  ///     child: Column(
  ///       children: [
  ///         Text('이름: ${viewModel.userName}'),
  ///         Text('학번: ${viewModel.userName}'),
  ///         Text('전공: ${viewModel.userName}'),
  ///       ],
  ///     ),
  ///   )
  ///```
  factory SettingsPageViewModel({required BuildContext context}) =>
      SettingsPageViewModel._init(context: context);

  /// 로그아웃을 하는 메서드
  ///
  /// 로그인된 계정을 로그아웃 할 시 사용되는 메소드이다.
  ///
  /// ```dart
  /// ElevatedButton(
  ///  onPressed: () {
  ///    viewModel.logout();
  ///  },
  ///  child: const Text('로그아웃'))
  void logout() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              CircularProgressIndicator.adaptive(),
              Text('  로그아웃 중...')
            ],
          ),
        ),
      ),
    );
    FirebaseAuth.instance
        .signOut()
        .then((_) => SharedPreferences.getInstance().then((pref) {
              pref.remove('userEmail').then((_) {
                Navigator.pop(context);
                context.go('/');
              });
            }));
  }

  SettingsPageViewModel._init({required this.context}) {
    _userName = '';
    _studentId = '';
    _userMajor = '';
  }
}
