import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

/// 강의실 정보와 출석하기 버튼이 포함된 위젯
///
/// 강의실 이름과 과목 이름과 출결하기 버튼을 출력하는 카드 형태의 위젯이다.
class CheckAttendanceCard extends StatefulWidget {
  /// 강의실 이름에 해당되는 변수
  final String lectureRoomName;

  /// 과목 이름에 해당되는 변수
  final String lectureName;

  /// 출석하기 버튼을 누를 시 수행되는 동작
  final Future<HttpsCallableResult> checkAttendance;

  /// 강의실 정보와 출석하기 버튼이 포함된 위젯
  ///
  /// 강의실 이름에 대한 정보를 [lectureRoomName]를 통해 전달받으며, 과목 이름에 대한 정보를
  /// [lectureName]을 통해 전달받는 카드 형태의 위젯으로 출석하기 버튼이 포함되어있다.
  /// 출석하기 버튼을 누를 시 수행될 동작은 [checkAttendance]를 통해 제공하면 된다.
  const CheckAttendanceCard({
    required this.lectureRoomName,
    required this.lectureName,
    required this.checkAttendance,
    super.key,
  });

  @override
  State<CheckAttendanceCard> createState() => _CheckAttendanceCardState();
}

class _CheckAttendanceCardState extends State<CheckAttendanceCard> {
  /// 버튼이 눌리기 전 상태인지에 대한 변수
  bool _initButton = true;

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
            Text('강의실 이름: ${widget.lectureRoomName}',
                style: Theme.of(context).textTheme.headlineSmall),
            Text(
              '과목 이름: ${widget.lectureName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width - 300,
            ),
            if (_initButton) ...[
              OutlinedButton(
                  onPressed: () => setState(() {
                        _initButton = false;
                      }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      Text(' 출석하기')
                    ],
                  ))
            ] else ...[
              FutureBuilder<HttpsCallableResult>(
                future: widget.checkAttendance,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const OutlinedButton(
                        onPressed: null,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                  } else if (snapshot.hasError) {
                    var error = snapshot.error as FirebaseFunctionsException;
                    return Column(
                      children: [
                        Text('오류정보: ${error.message}'),
                        OutlinedButton(
                            onPressed: null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.warning_amber_outlined,
                                  color: Colors.orangeAccent,
                                ),
                                Text(' 출석을 완료할 수 없음')
                              ],
                            ))
                      ],
                    );
                  } else {
                    return OutlinedButton(
                        onPressed: null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.check,
                              color: Colors.blueAccent,
                            ),
                            Text(' 출석 완료됨')
                          ],
                        ));
                  }
                },
              )
            ]
          ],
        ),
      ),
    );
  }
}
