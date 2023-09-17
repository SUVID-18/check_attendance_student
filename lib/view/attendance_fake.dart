import 'package:check_attendance_student/view/styles.dart';
import 'package:check_attendance_student/view_model/attendance.dart';
import 'package:flutter/material.dart';

/// 개발용으로 제작된 페이지이며, 출결 시 모습을 쉽게 볼 수 있는 용도로 제작된 페이지입니다.
/// 실제 개발이 완료될 시 사라질 예정입니다.
class FakeAttendancePage extends StatefulWidget {
  /// DynamicLink의 id 필드인 uuid 정보를 가지고 있는 변수.
  final String uuid;

  /// AttendancePage의 생성자.
  /// parameter로 uuid를 전달받습니다.
  const FakeAttendancePage({required this.uuid, Key? key}) : super(key: key);

  @override
  State<FakeAttendancePage> createState() => _FakeAttendancePageState();
}

class _FakeAttendancePageState extends State<FakeAttendancePage> {
  late var viewModel = AttendanceViewModel(uuid: widget.uuid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/swu_att_bg.png'))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const CheckAttendanceCard(
                        lectureRoomName: '정보 없음(테스트)',
                        lectureName: '정보 없음(테스트)',
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
