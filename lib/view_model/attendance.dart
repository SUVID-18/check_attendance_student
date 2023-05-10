

/// 출결진행 페이지의 동작을 담당하는 클래스
class AttendanceViewModel {
  /// 강의실 이름에 해당되는 읽기전용 속성
  String get lectureName => _lectureName;

  /// 강의실 호수에 해당되는 읽기전용 속성
  String get lectureRoomName => _lectureRoomName;

  late final String _lectureName;
  late final String _lectureRoomName;
  static final _instance = AttendanceViewModel._init();

  /// 출결진행 페이지의 동작을 담당하는 클래스의 생성자
  ///
  /// 출결진행 페이지에서 필요한 부분에 대입시키면 된다.
  ///
  /// ```dart
  ///var viewModel = AttendanceViewModel();
  ///CheckAttendanceCard(
  ///     lectureRoomName: viewModel.lectureRoomName,
  ///     lectureName: viewModel.lectureName,
  ///   )
  ///```
  factory AttendanceViewModel() => _instance;

  /// 출석하기 버튼을 누르는 경우 수행할 동작
  ///
  /// 출석체크를 하는 동작을 수행합니다.
  ///
  /// ```dart
  /// TextButton(
  ///   child: Text('출석하기'),
  ///   onPressed: () => onSubmit(),
  /// )
  ///```
  void onSubmit() {}

  AttendanceViewModel._init() {
    _lectureName = '';
    _lectureRoomName = '';
  }
}
