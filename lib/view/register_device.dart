import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";

/// 기기 변경을 신청하는 페이지 입니다.
/// 이곳에서 출결 확인에 사용되는 기기를 변경할 수 있습니다.
/// 이 메뉴에 진입 시 서버에서 요구하는 인증 방식에 따라 전화 인증을 진행할 수도 문자 인증을 진행할 수도 있습니다.
class RegisterDevicePage extends StatelessWidget {
  const RegisterDevicePage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name, Phone Number and ID Registration',
      home: RegistrationForm(),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '기기변경 페이지',
      home: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  String name = '';
  String phoneNumber = '';
  String studentID = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      ///기기등록 or 변경
      ///
      ///

      title: '기기등록 or 변경 ',
      home: Scaffold(
        appBar: AppBar(
            title: Text('기기등록 ', style: TextStyle(fontSize: 22)),
            leading: IconButton(
              onPressed: () => GoRouter.of(context).go('/'),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            )),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 16),

              ///이름입력
              ///
              ///
              TextField(
                decoration: InputDecoration(
                  labelText: '이름',
                  hintText: '이름을 입력하세요.',
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: 16),

              ///폰번호 입력
              ///
              ///

              TextField(
                decoration: InputDecoration(
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

              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: '학생번호',
                  hintText: '학생번호를 입력하세요.',
                ),
                onChanged: (value) {
                  setState(() {
                    studentID = value;
                  });
                },
              ),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  /// 기기 정보 등록 로직 추가
                  /// 지금 구현안해뒀음 누르면 에러남 !!!
                  Navigator.pop(context);
                },
                child: Text('기기 등록'),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
