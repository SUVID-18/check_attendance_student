import 'package:flutter/material.dart';

/// 로그인 시 나타나는 페이지 입니다.
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 페이지'),
      ),
      body: const Center(
        child: Text('로그인 페이지'),
      ),
    );
  }
}
