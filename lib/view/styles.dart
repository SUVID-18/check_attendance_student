import 'package:flutter/material.dart';

/// 강의실 정보와 출석하기 버튼이 포함된 위젯
///
/// 강의실 이름과 과목 이름과 출결하기 버튼을 출력하는 카드 형태의 위젯이다.
/// 강의실 이름에 해당되는 변수
//lectureRoomName;
/// 과목 이름에 해당되는 변수
//lectureName;
/// 출석하기 버튼을 누를 시 수행되는 동작
//onAttendance;
/// 강의실 정보와 출석하기 버튼이 포함된 위젯
///
/// 강의실 이름에 대한 정보를 [lectureRoomName]를 통해 전달받으며, 과목 이름에 대한 정보를
/// [lectureName]을 통해 전달받는 카드 형태의 위젯으로 출석하기 버튼이 포함되어있다.
/// 출석하기 버튼을 누를 시 수행될 동작은 [onAttendance]를 통해 제공하면 된다.

/// ///CheckAttendanceCard 위젯을 StatefulWidget으로 변경하여 내부 상태를 관리.
///_CheckAttendanceCardState 클래스에서 _isButtonEnabled라는 변수를 추가하여 출석 버튼의 활성화 상태를 추적.
///_handleAttendance 메서드는 버튼이 활성화되어 있고 onAttendance 콜백이 제공된 경우에만 호출됨
///이후 버튼을 비활성화하고 onAttendance 콜백을 실행.
///출석 버튼의 onPressed 콜백과 버튼 스타일에 _isButtonEnabled 변수를 사용하여 버튼의 활성화 상태에 따라 색상을 조정.
/// 번 출석 버튼을 누르면 버튼이 비활성화되도록 구현함.

class CheckAttendanceCard extends StatefulWidget {
  final String lectureRoomName;
  final String lectureName;
  final void Function()? onAttendance;

  const CheckAttendanceCard({
    required this.lectureRoomName,
    required this.lectureName,
    this.onAttendance,
    Key? key,
  }) : super(key: key);

  @override
  _CheckAttendanceCardState createState() => _CheckAttendanceCardState();
}

class _CheckAttendanceCardState extends State<CheckAttendanceCard> {
  bool _isButtonEnabled = true;

  void _handleAttendance() {
    if (_isButtonEnabled && widget.onAttendance != null) {
      setState(() {
        _isButtonEnabled = false;
      });
      widget.onAttendance!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Icon(Icons.school_outlined),
                  Text(
                    '  출석체크',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '강의실 이름: ${widget.lectureRoomName}',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '과목 이름: ${widget.lectureName}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20.0),
            OutlinedButton(
              onPressed: _handleAttendance,
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    _isButtonEnabled ? null : Theme.of(context).disabledColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: _isButtonEnabled ? Colors.green : Colors.grey,
                  ),
                  const Text(' 출석하기'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
