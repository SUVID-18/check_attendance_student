import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 설정 페이지의 동작을 담당하는 클래스
class SettingsPageViewModel {
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
  static final _instance = SettingsPageViewModel._init();

  /// 설정 페이지의 동작을 담당하는 생성자
  ///
  /// 설정 페이지에서 필요한 부분에 대입시키면 된다.
  ///
  /// ```dart
  ///var viewModel = RegisterDeviceViewModel();
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
  factory SettingsPageViewModel() => _instance;

  /// 로그아웃을 하는 메서드
  ///
  /// 로그인된 계정을 로그아웃 할 시 사용되는 메소드이다.
  /// [context]에 [BuildContext]를 필요로 한다.
  Future<void> logout({required BuildContext context}) async {
    FirebaseAuth.instance.signOut().then((_) => context.go('/'));
  }

  SettingsPageViewModel._init() {
    _userName = '';
    _studentId = '';
    _userMajor = '';
  }
}
