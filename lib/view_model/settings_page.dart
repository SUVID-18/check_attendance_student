import 'package:check_attendance_student/model/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 설정 페이지의 동작을 담당하는 클래스
class SettingsPageViewModel {
  /// 특정 메서드에서 위젯을 띄우기 위한 [BuildContext]
  BuildContext context;

  /// 사용자 이메일 계정
  String get userEmail => _userEmail;
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
  ///  onPressed: () => viewModel.logout(),
  ///  child: const Text('로그아웃'))
  ///```
  void logout() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
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

  /// 학생 정보를 반환하는 메서드
  ///
  /// 계정의 UID를 이용해서 학생 정보가 담긴 객체를 반환하는 메서드이다.
  /// 만일 어떠한 문제로 인해 학생 정보를 찾을 수 없는 경우 `null`을 반환한다.
  ///
  /// 해당 메서드는 인터넷 통신에 의한 대기시간이 필요하기에 [Future]형태를 띈다.
  ///
  /// ## 예제
  /// 코드가 너무 길어 생략. [FutureBuilder] 참고바람.
  ///
  /// ## 같이보기
  /// * [Student]
  /// * [FutureBuilder]
  Future<Student?> getStudentInfo() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var student = await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .get();
      var data = student.data();
      if (data != null) {
        return Student.fromJson(data);
      }
    }
    return null;
  }

  SettingsPageViewModel._init({required this.context});
}
