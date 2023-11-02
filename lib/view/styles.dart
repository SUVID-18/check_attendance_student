import 'package:check_attendance_student/model/lecture.dart';
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
  final Future<List<Lecture>?> Function()? run;
  final String lectureRoomName;
  final String lectureName;
  final void Function()? onAttendance;

  const CheckAttendanceCard({
    this.run,
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '과목 이름: ${widget.lectureName}',
              style: Theme.of(context).textTheme.titleLarge,
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
            if (widget.run != null)
              SubjectListExpansionTile(
                  child: FutureBuilder(
                future: widget.run!(),
                // TODO: null처리 및 데이터 출력
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator.adaptive();
                  } else if (snapshot.data == null) {
                  } else {
                    return Text(snapshot.data!.toString());
                  }
                },
              ))
          ],
        ),
      ),
    );
  }
}

/// 과목의 정보를 출력하는 용도로 만들어진 위젯
///
/// 전체 과목의 목록을 출력하는 타일로 화살표가 가운데 있으며, 터치 시 표시할 내용이 나타난다.
class SubjectListExpansionTile extends StatefulWidget {
  /// 확장될 때 표시할 [Widget]을 추가하는 곳
  ///
  /// 확장 아이콘을 누르면 해당 위젯이 출력됩니다. [null]이 될 수 없습니다.
  final Widget child;

  /// 확장 아이콘 위에 나타낼 위젯
  ///
  /// 어떤 내용을 표시할 지 나타내는 용도로 사용됩니다. 일반적으로 [Text]가 사용됩니다.
  final Widget? subTitle;

  /// 화살표가 가운데 있는 형태의 ExpansionTile이라 보면 된다. [child]에 버튼을 누른 후 표시할
  /// 위젯을 삽입하면 된다.
  const SubjectListExpansionTile(
      {required this.child, this.subTitle, super.key});

  @override
  State<SubjectListExpansionTile> createState() =>
      _SubjectListExpansionTileState();
}

class _SubjectListExpansionTileState extends State<SubjectListExpansionTile>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);
  late Animation<double> _iconTurn;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _iconTurn = _animationController.drive(_halfTween.chain(_easeInTween));
    _heightFactor = _animationController.drive(_easeInTween);
    _isExpanded =
        PageStorage.maybeOf(context)?.readState(context) as bool? ?? false;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (_isExpanded) {
                  _animationController.forward();
                } else {
                  _animationController.reverse().then((_) {
                    setState(() {});
                  });
                }
              });
              PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (widget.subTitle != null) widget.subTitle!,
                    RotationTransition(
                        turns: _iconTurn, child: const Icon(Icons.expand_more)),
                  ],
                ),
              ),
            )),
        AnimatedBuilder(
          animation: _animationController.view,
          child: widget.child,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            );
          },
        )
      ],
    );
  }
}
