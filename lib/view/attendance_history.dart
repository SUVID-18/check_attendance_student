import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../view_model/attendance_history.dart';

/// 출결 기록을 확인하는 페이지 입니다.
///
/// 이곳에서 본인의 출결 내역 확인이 가능합니다.

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

///viewmodel
var viewModel = AttendanceHistoryViewModel();

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar 부분
      appBar: AppBar(
          title: const Text('출결 기록 페이지'), actions: [
        IconButton(
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings, color: Colors.black),
        )
      ]),

      //ListView를 사용해 리스트를 동적으로 나타내도록 함
      body: ListView.builder(
        ///리스트의 길이 만큼 카운트
        itemCount: viewModel.attendanceHistoryList.length,

        ///위젯을 인덱스 만큼 만들도록 함
        itemBuilder: (context, index) {
          ///출결 한 기록을 탭하여 세부 정보를 볼 수 있는 gesturedetector
          ///alertDialog를 통해 강의실 번호를 입력 받아 확인시 업로드가 된다
          return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                            title: const Text('출결 정보'),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '교수명: ${viewModel.attendanceHistoryList[index].professorName}',
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    '과목명: ${viewModel.attendanceHistoryList[index].subjectName}',
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    '출결 여부: ${viewModel.attendanceHistoryList[index].result}',
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                ]),

                            ///확인 버튼임
                            //아직 입력 받아 리스트에 추가하는것 구현 안함
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'))
                            ]));
              },

              ///실제 나타나는 출결 목록들
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      viewModel.attendanceHistoryList[index].subjectName,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      viewModel.attendanceHistoryList[index].professorName,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      viewModel.attendanceHistoryList[index].result.toString(),
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
