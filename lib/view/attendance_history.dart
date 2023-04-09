import 'package:flutter/material.dart';

/// 출결 기록을 확인하는 페이지 입니다.
///
/// 이곳에서 본인의 출결 내역 확인이 가능합니다.

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}


class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  ///강의실 리스트
  ///강의실 번호, 과목명, 교수 이름, 출석여부가 포함되어있는 리스트임
  List<Map<String, dynamic>> _dataList = [
    {'number': '201호', 'subject': '소프트웨어 공학','professor': '고혁진 교수' ,'attendanceCheck': '출석'},
    {'number': '202호', 'subject': '프로그래밍 언어론','professor': '조영일 교수', 'attendanceCheck': '지각'},
    {'number': '303호', 'subject': '캡스톤 설계','professor': '문승진 교수', 'attendanceCheck': '출석'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar 부분
      appBar: AppBar(
          title: Text("출결 기록 페이지"),
          leading: IconButton(
            onPressed: ()=>Navigator.pop(context,"/"),
            icon: Icon(
                Icons.arrow_back,
                color: Colors.black
            ),
          )
      ),

      //ListView를 사용해 리스트를 동적으로 나타내도록 함
      body: ListView.builder(
        ///리스트의 길이 만큼 카운트
        itemCount: _dataList.length,

        ///위젯을 인덱스 만큼 만들도록 함
        itemBuilder: (context, index) {
          ///출결 한 기록을 탭하여 세부 정보를 볼 수 있는 gesturedetector
          ///alertDialog를 통해 강의실 번호를 입력 받아 확인시 업로드가 된다
          return GestureDetector(
            onTap: (){
              showDialog(context: context,
                  builder: (BuildContext context)=>
                      AlertDialog(
                          title: Text("출결 정보"),
                          content: Column(
                            children: [
                              Text("과목명: "+_dataList[index]['subject']),
                              Text("교수 명: "+_dataList[index]['professor']),
                              Text("출석 여부: "+_dataList[index]['attendanceCheck'])
                            ]
                          ),
                          ///확인 버튼임
                          //아직 입력 받아 리스트에 추가하는것 구현 안함
                          actions: <Widget>[
                            TextButton(onPressed: (){
                              Navigator.pop(context);},
                                child: Text('확인'))
                          ]
                    )
              );
            },
            ///실제 나타나는 출결 목록들
            child: Column(
              children: [
                Text(_dataList[index]['number']),
                Text(_dataList[index]['subject']),
                Text(_dataList[index]['attendanceCheck']),
                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}

