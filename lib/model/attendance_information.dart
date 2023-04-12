import 'package:flutter/foundation.dart';

/// 출결 여부에 대한 정보를 가지고 있는 클래스
@immutable
class AttendanceInformation {
  /// 과목의 이름
  final String subjectName;

  /// 교수(강의자)의 이름
  final String professorName;

  /// 출결 여부(true: 출석)
  final bool attendance;

  /// 출결 여부를 가진 객체를 생성한다.
  ///
  /// [subjectName]에 과목 이름을 넣고, [professorName]에 교수나 강의자 이름을 넣고
  /// [attendance]에 부울 값으로 출결 여부를 넣으면 된다. 만일 [attendance]가 `true`인
  /// 경우 출결한 것으로 간주한다.
  const AttendanceInformation(
      {required this.subjectName,
      required this.professorName,
      required this.attendance});

  /// [json]에서 객체를 역직렬화 하는 경우(출결 여부를 가진 객체로 가져오기) 사용되는 `factory` 생성자
  ///
  /// `Firestore`에서 받은 데이터를 [AttendanceInformation]객체로 반환하는 메서드로 [json]에
  /// `Firestore`에서 받은 데이터를 넣으면 된다.
  ///
  /// ```dart
  /// final lectureRef = db.collection('attendances').doc('test');
  /// lectureRef.get().then(
  ///   (DocumentSnapshot doc) {
  ///     final student = AttendanceInformation.fromJson(jsonDecode(doc.data()));
  ///    },
  ///    onError: (e) => print('Error Detected: $e'),
  ///   );
  /// ```
  factory AttendanceInformation.fromJson(Map<String, dynamic> json) =>
      AttendanceInformation(
          subjectName: json['subjectName'],
          professorName: json['professorName'],
          attendance: json['attendance']);

  /// 객체를 `JSON`으로 직렬화 하는 메서드
  ///
  /// 객체를 `Firestore`에게 쉽게 올릴 수 있도록 직렬화를 수행한다.
  /// 이 메서드는 별도로 호출될 필요 없이 `jsonEncode()`메서드에 사용된다.
  ///
  /// ```dart
  /// String json = jsonEncode(lecture);
  /// ```
  Map<String, dynamic> toJson() => {
        'subjectName': subjectName,
        'professorName': professorName,
        'attendance': attendance
      };
}
