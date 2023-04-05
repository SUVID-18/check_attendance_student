import 'package:flutter/material.dart';

/// 앱 내 환경설정에 해당되는 페이지 입니다.
///
/// 이곳에서 계정 정보 확인 및 로그아웃이 가능합니다.
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Settings',style: TextStyle(fontSize: 22)),
            leading: IconButton(
              onPressed: ()=>Navigator.pop(context,"/"),
              icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black
              ),
            )
        ),
        body:SafeArea(
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children:[
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10),
                      Text("Account",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(height: 10),

                  GestureDetector(
                      onTap: (){
                        showDialog(context: context,
                            builder: (BuildContext context)=>
                                AlertDialog(
                                    title:Text("계정정보"),
                                    content: Text(""),
                                    actions: <Widget>[
                                      TextButton(onPressed: ()=> Navigator.pop(context),
                                          child: Text("확인"))
                                    ]
                                )
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("계정 정보 확인",style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600]
                              )),
                              Icon(Icons.arrow_forward_ios, color: Colors.grey)
                            ],
                          )
                      )
                  ),
                  GestureDetector(
                      onTap: (){
                        showDialog(context: context,
                            builder: (BuildContext context)=>
                                AlertDialog(
                                    title:Text("로그아웃"),
                                    content: Text("로그아웃 하시겠습니까?"),
                                    actions: <Widget>[
                                      TextButton(onPressed: ()=> Navigator.pop(context),
                                          child: Text("취소")),
                                      ElevatedButton(onPressed: ()=> Navigator.pop(context,"login"),
                                          child: Text("확인"))
                                    ]
                                )
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("로그아웃",style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600]
                              )),
                              Icon(Icons.arrow_forward_ios, color: Colors.grey)
                            ],
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}
