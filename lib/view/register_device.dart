import 'package:flutter/material.dart';

/// 기기 변경을 신청하는 페이지 입니다.
/// 이곳에서 출결 확인에 사용되는 기기를 변경할 수 있습니다.
/// 이 메뉴에 진입 시 서버에서 요구하는 인증 방식에 따라 전화 인증을 진행할 수도 문자 인증을 진행할 수도 있습니다.
// class RegisterDevicePage extends StatelessWidget {
//   const RegisterDevicePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Name, Phone Number and ID Registration',
//       home: RegistrationForm(),
//     );
//   }
// }
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: '기기변경 페이지',
//       home: RegistrationForm(),
//     );
//   }
// }

class RegisterDevicePage extends StatefulWidget {
  const RegisterDevicePage({super.key});

  @override
  State<RegisterDevicePage> createState() => _RegisterDevicePageState();
}

class _RegisterDevicePageState extends State<RegisterDevicePage> {
  /// 이름에 해당되는 변수
  String name = '';

  /// 전화번호에 해당되는 변수
  String phoneNumber = '';

  /// 학번에 해당되는 변수
  String studentID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('기기등록 ', style: TextStyle(fontSize: 22)),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),

            ///이름입력
            ///
            ///
            TextField(
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '이름을 입력하세요.',
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            const SizedBox(height: 16),

            ///폰번호 입력
            ///
            ///

            TextField(
              decoration: const InputDecoration(
                labelText: '휴대폰 번호',
                hintText: '휴대폰 번호를 입력하세요.',
              ),
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
            ),

            ///학번 입력
            ///
            ///

            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '학생번호',
                hintText: '학생번호를 입력하세요.',
              ),
              onChanged: (value) {
                setState(() {
                  studentID = value;
                });
              },
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                /// 기기 정보 등록 로직 추가
                /// 지금 구현안해뒀음 누르면 에러남 !!!
                Navigator.pop(context);
              },
              child: const Text('기기 등록'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
