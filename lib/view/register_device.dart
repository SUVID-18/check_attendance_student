import 'package:flutter/material.dart';

/// 기기 변경을 신청하는 페이지 입니다.
///
/// 이곳에서 출결 확인에 사용되는 기기를 변경할 수 있습니다.
/// 이 메뉴에 진입 시 서버에서 요구하는 인증 방식에 따라 전화 인증을 진행할 수도 문자 인증을 진행할 수도 있습니다.
class RegisterDevicePage extends StatelessWidget {
  const RegisterDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('기기 등록 페이지'),
    );
  }
}
