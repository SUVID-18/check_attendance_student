import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 로그인 시 나타나는 페이지 입니다.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// 아이디와 비밀번호 변수
  /// TextEditingController로 구현해서 인스턴스의 핸들링 함수를 리스너로 등록해줘야함
  /// _usernameController는 아이디
  /// _passwardController는 비밀번호
  final _usernameController = TextEditingController();
  final _passwardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
            /// 앱 크기 조정을 수평 대칭적으로 함
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              ///상단 출석체크 위젯
              ///assets/images/swu_horizontalLogo.png 이미지 추가해놓음
              SizedBox(height: 80.0),
              Column(
                children: <Widget>[
                  Image.asset('assets/images/swu_horizontalLogo.png'),
                  SizedBox(height: 1.0),
                  Text('수원대 전자출결 앱', style: TextStyle(fontSize: 30),),
                ],
              ),
              ///아이디 및 비밀번호 입력란
              ///_usernameController 변수 사용
              SizedBox(height: 60.0,),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'ID'
                ),
              ),
              ///비밀번호 입력란
              ///obscureText 사용 비밀번호 입력시 숨김
              SizedBox(height: 12.0),
              TextField(
                controller: _passwardController,
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Passward'
                ),
                obscureText: true,
              ),
              ///이벤트 버튼 구현 위젯
              ButtonBar(
                children: <Widget>[
                  ///다음 페이지로 가는 버튼 Next
                  ///pop기능 사용시 페이지 이동이 꼬여서 context.push이용
                  ///잘못된 정보 입력시 AlertDialog뜨도록 구현해놓음
                  ElevatedButton(onPressed: (){
                    //showDialog(
                    //       context: context,
                    //       builder: (BuildContext context)=>AlertDialog(
                    //       title: Text('로그인 실패'),
                    //       content: Text('ID나 비밀번호가 없거나 잘못되었습니다'),
                    //       actions: <Widget>[
                    //                   TextButton(onPressed: ()=> Navigator.pop(context),
                    //                   child: Text('확인'))
                    //                  ]
                    //                 )
                    //                );
                    //Navigator.pop(context,"/");
                    context.push('/');
                  }, child: Text('Next'))
                ],
              ),
              /// 하단 로고
              /// 이미지 에셋 해놓음
              Column(
                  children: [
                    SizedBox(height: 50,),
                    Image.asset('assets/images/swu_bluelogo.png')
                  ]
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: Text('기기변경 신청',style: TextStyle(fontSize: 15),),
                  onPressed: ()=>context.push('/register_device'),
                ),
              )
            ],
          ),
        )
    );
  }
}

