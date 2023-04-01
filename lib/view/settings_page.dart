import 'package:flutter/material.dart';

/// 앱 내 환경설정에 해당되는 페이지 입니다.
///
/// 이곳에서 계정 정보 확인 및 로그아웃이 가능하며 기기변경 신청 메뉴로 접근도 가능합니다.
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정 페이지'),
      ),
      body: const Center(
        child: Text('설정 페이지'),
      ),
    );
  }
}
