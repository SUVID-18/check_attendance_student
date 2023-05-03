class AttendanceViewModel{

  // 싱글톤 패턴 선언부
  AttendanceViewModel._privateConstructor({required String uuid});
  static final AttendanceViewModel _instance = AttendanceViewModel._privateConstructor(uuid: '');

  /// ManagementViewModel의 생성자이다.
  ///
  /// ```dart
  /// viewmodel = ManagementViewmodel();
  /// ```
  factory AttendanceViewModel({required String uuid}) {
    _instance._uuid = uuid;
    return _instance;
  }

  late final String _uuid;
  String get uuid => _uuid;
}