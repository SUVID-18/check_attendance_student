import 'package:flutter/material.dart';

import '../model/student.dart';
import '../view_model/settings_page.dart';

/// 앱 내 환경설정에 해당되는 페이지 입니다.
///
/// 이곳에서 계정 정보 확인 및 로그아웃이 가능합니다.
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ///설정페이지 viewmodel
  late var viewModel = SettingsPageViewModel(context: context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Settings', style: TextStyle(fontSize: 22)),
            leading: IconButton(
              onPressed: () => Navigator.pop(context, '/'),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            )),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
              const SizedBox(height: 20),

              ///상단 부제목 부분
              const Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 10),
                  Text('Account',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                ],
              ),

              ///여백용 SizedBox
              const SizedBox(height: 10),

              ///계정정보란
              /// viewModel 반영
              //터치시 AlertDialog 이용하여 계정정보를 보여줌
              //그냥 쓰니 text overflow가 나서 sizedbox로 감싸고 shrinkwarp사용
              GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: const Text('계정정보'),

                                ///정보 받아오기 용 futureBuilder 생성
                                content: FutureBuilder<Student?>(
                                    future: viewModel.getStudentInfo(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<Student?> snapshot) {
                                      //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
                                      if (snapshot.hasData == false) {
                                        return const CircularProgressIndicator(); // CircularProgressIndicator : 로딩 에니메이션
                                      }
                                      //error가 발생하게 될 경우 반환하게 되는 부분
                                      else if (snapshot.hasError) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Error: ${snapshot.error}',
                                            // 에러명을 텍스트에 뿌려줌
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        );
                                      }
                                      // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
                                      else {
                                        return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                snapshot.data?.name ??
                                                    '이름 알 수 없음',
                                                // 비동기 처리를 통해 받은 데이터를 텍스트에 뿌려줌
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                snapshot.data?.studentId ??
                                                    '학번 알 수 없음',
                                                // 비동기 처리를 통해 받은 데이터를 텍스트에 뿌려줌
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                snapshot.data?.department ??
                                                    '학부 알 수 없음',
                                                // 비동기 처리를 통해 받은 데이터를 텍스트에 뿌려줌
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                snapshot.data?.major ??
                                                    '학과 알 수 없음',
                                                // 비동기 처리를 통해 받은 데이터를 텍스트에 뿌려줌
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ]));
                                      }
                                    }),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('확인'))
                                ]));
                  },

                  //안쪽 여백을 위해 Container가 아닌 padding을 이용
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Row(
                        //여백을 주기위한 spaceBetween
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('계정 정보 확인',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600])),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey)
                        ],
                      ))),

              ///로그아웃 란
              ///viewModel 반영
              //터치시 AlertDialog이용 로그아웃 여부 질문
              //확인 버튼 터치시 로그인 화면 이동, 취소버튼시 이전화면으로 push처리
              //확인 버튼은 비교적 짙은색의 elevetedbutton, 취소버튼은 textbutton
              GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: const Text('로그아웃'),
                                content: const Text('로그아웃 하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('취소')),
                                  ElevatedButton(
                                      onPressed: () {
                                        viewModel.logout();
                                      },
                                      child: const Text('확인'))
                                ]));
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        //여백을 주기 위한 spaceBetween
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('로그아웃',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600])),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey)
                        ],
                      )))
            ])));
  }
}
