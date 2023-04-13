import 'package:check_attendance_student/model/attendance_information.dart';

class AttendanceHistoryViewModel {
  /// 출결 기록 리스트
  ///
  /// 강의실 번호, 과목명, 교수 이름, 출석여부가 포함되어있는 리스트이다.
  ///
  /// 추후 서버에서 정보를 받아오게 하는 `Future`형의 메서드를 제작할 때
  /// 데이터가 추가될 변수이다.
  ///
  /// 직접 수정이 불가능하다.
  List<AttendanceInformation> get attendanceHistoryList =>
      _attendanceHistoryList;
  final List<AttendanceInformation> _attendanceHistoryList = [
    const AttendanceInformation(
        subjectName: '소프트웨어 공학',
        professorName: '고혁진',
        result: AttendanceResult.normal),
    const AttendanceInformation(
        subjectName: '프로그래밍 언어론',
        professorName: '조영일',
        result: AttendanceResult.tardy),
    const AttendanceInformation(
        subjectName: '캡스톤 설계',
        professorName: '문승진',
        result: AttendanceResult.normal),
  ];
  static final AttendanceHistoryViewModel _instance =
      AttendanceHistoryViewModel._init();

  /// 출결 기록 페이지의 동작을 담당하는 클래스
  ///
  /// 출결 기록 페이지에서 필요한 부분에 대입시키면 된다.
  ///
  /// ```dart
  ///var viewModel = AttendanceHistoryViewModel();
  ///Card(
  ///      child: Column(
  ///        children: [
  ///          Text(viewModel.attendanceHistoryList[index].professorName),
  ///          Text(viewModel.attendanceHistoryList[index].subjectName),
  ///          Text(viewModel.attendanceHistoryList[index].result.toString()),
  ///          SizedBox(height: 30),
  ///        ],
  ///      ),
  ///    )
  ///```
  factory AttendanceHistoryViewModel() => _instance;

  AttendanceHistoryViewModel._init();
}
