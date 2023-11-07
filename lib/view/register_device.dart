import 'package:flutter/material.dart';

import '../view_model/register_device.dart';

/// 기기 변경을 신청하는 페이지 입니다.
/// 이곳에서 출결 확인에 사용되는 기기를 변경할 수 있습니다.
/// 이 메뉴에 진입 시 서버에서 요구하는 인증 방식에 따라 전화 인증을 진행할 수도 문자 인증을 진행할 수도 있습니다.

///min

class RegisterDevicePage extends StatefulWidget {
  const RegisterDevicePage({super.key});

  @override
  State<RegisterDevicePage> createState() => _RegisterDevicePageState();
}

class _RegisterDevicePageState extends State<RegisterDevicePage> {
  late var viewModel = RegisterDeviceViewModel(context: context);


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
            TextField(
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '이름을 입력하세요.',
              ),
          controller: viewModel.nameController,
            ),

            ///폰번호 입력
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                  labelText: '학부', hintText: '대상 학부를 입력하세요'),
              controller: viewModel.departmentController,
            ),

            ///학번 입력
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '학번',
                hintText: '학번을 입력하세요.',
              ),
              controller: viewModel.studentIDController,
            ),

            ///이메일 입력
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '전공',
                hintText: '전공을 입력하세요.',
              ),
              controller: viewModel.majorController,
            ),

            ///만약 입력한 값이 없을때 띄워주는 안내창 생성.
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                viewModel.onSubmitPressed(
                    blankDialog: AlertDialog(
                        title: const Text('안내'),
                        content: const Text('모든 항목을 입력하십시오'),
                        actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('확인'))
                    ]));
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
