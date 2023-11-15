import 'package:check_attendance_student/model/lecture.dart';
import 'package:check_attendance_student/view/styles.dart';
import 'package:check_attendance_student/view_model/attendance.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

/// 태그 시 간단한 강의실 정보와 출석하기 버튼을 출력하는 페이지입니다.
class AttendancePage extends StatefulWidget {
  /// DynamicLink의 id 필드인 uuid 정보를 가지고 있는 변수.
  final String uuid;

  /// AttendancePage의 생성자.
  /// parameter로 uuid를 전달받습니다.
  const AttendancePage({required this.uuid, Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
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
              child: FutureBuilder<Lecture?>(
                  future: viewModel.getLecture(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.data == null) {
                      return CheckAttendanceCard(
                        getLectureData: viewModel.getAllLectures,
                        department: '현재 강의 정보 없음',
                        lectureName: '현재 강의 정보 없음',
                      );
                    } else {
                      return CheckAttendanceCard(
                        getLectureData: viewModel.getAllLectures,
                        department: snapshot.data!.department,
                        lectureName: snapshot.data!.name,
                        onAttendance: () async {
                          try {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => const AlertDialog(
                                title: Row(
                                  children: [
                                    CircularProgressIndicator.adaptive(),
                                    Text('  출결 진행 중...')
                                  ],
                                ),
                              ),
                            );
                            await viewModel.onSubmit();
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('출결이 완료되었습니다.')));
                            }
                          } on FirebaseFunctionsException catch (error) {
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          error.message ?? '오류가 발생했습니다.')));
                            }
                          }
                        },
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
