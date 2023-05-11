import 'package:flutter/material.dart';

/// 강의실 정보와 출석하기 버튼이 포함된 위젯
///
/// 강의실 이름과 과목 이름과 출결하기 버튼을 출력하는 카드 형태의 위젯이다.
class CheckAttendanceCard extends StatelessWidget {
  /// 강의실 이름에 해당되는 변수
  final String lectureRoomName;

  /// 과목 이름에 해당되는 변수
  final String lectureName;

  /// 출석하기 버튼을 누를 시 수행되는 동작
  final void Function()? onAttendance;

  /// 강의실 정보와 출석하기 버튼이 포함된 위젯
  ///
  /// 강의실 이름에 대한 정보를 [lectureRoomName]를 통해 전달받으며, 과목 이름에 대한 정보를
  /// [lectureName]을 통해 전달받는 카드 형태의 위젯으로 출석하기 버튼이 포함되어있다.
  /// 출석하기 버튼을 누를 시 수행될 동작은 [onAttendance]를 통해 제공하면 된다.
  const CheckAttendanceCard({
    required this.lectureRoomName,
    required this.lectureName,
    this.onAttendance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: const [
                  Icon(Icons.school_outlined),
                  Text('  출석체크',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 23.0))
                ],
              ),
            ),
            Text('강의실 이름: $lectureRoomName',
                style: Theme.of(context).textTheme.headlineSmall),
            Text(
              '과목 이름: $lectureName',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width - 300,
            ),
            // 출석을 진행하는 동작을 수행하는 버튼
            OutlinedButton(
                onPressed: onAttendance,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    Text(' 출석하기')
                  ],
                )),
          ],
        ),
      ),
    );
  }
}