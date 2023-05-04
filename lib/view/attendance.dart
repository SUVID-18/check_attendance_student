import 'package:check_attendance_student/view/styles.dart';
import 'package:flutter/material.dart';

/// 태그 시 간단한 강의실 정보와 출석하기 버튼을 출력하는 페이지입니다.
class AttendancePage extends StatelessWidget {
  /// DynamicLink의 id 필드인 uuid 정보를 가지고 있는 변수.
  final String uuid;

  /// AttendancePage의 생성자.
  /// parameter로 uuid를 전달받습니다.
  const AttendancePage({required this.uuid, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/swu_att_bg.png')
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: CheckAttendanceCard(
                lectureRoomName: '404호',
                lectureName: '찾을 수 없음',
              ),
            ),
          ],
        ),
      ),
    );
  }
}