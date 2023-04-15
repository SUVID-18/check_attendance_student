import 'package:flutter/foundation.dart';

/// 학생에 대한 인적 사항을 담고 있는 클래스
@immutable
class Student {
  /// 학번
  final String studentId;

  /// 출결 앱에서 사용되는 학생 식별용 UUID
  final String attendanceStudentId;

  /// 학생의 학부
  final String department;

  /// 학생의 학과
  final String subject;

  /// 학생의 이름
  final String name;

  /// 학생 객체를 생성한다.
  ///
  /// [studentId], [department], [subject], [name]에 학생 인적 사항에 대한 정보를 넣고
  /// [attendanceStudentId]에서는 `UUID`로 생성된 값을 집어넣는다.
  const Student(
      {required this.studentId,
      required this.attendanceStudentId,
      required this.department,
      required this.subject,
      required this.name});

  /// 출결 앱에서 사용되는 학생 식별용 `UUID`를 변경 시 사용하는 메서드
  ///
  /// 기기 변경등을 이유로 `UUID` 재설정이 필요할 시 [attendanceStudentId]에
  /// 새로운 `UUID`로 생성된 값을 집어넣는다.
  ///
  /// ```dart
  /// var newStudent = student.updateStudentUuid(const Uuid().v4());
  /// ```
  Student updateStudentUuid(String attendanceStudentId) => Student(
      studentId: studentId,
      attendanceStudentId: attendanceStudentId,
      department: department,
      subject: subject,
      name: name);

  /// [json]에서 객체를 역직렬화 하는 경우(학생 객체로 가져오기) 사용되는 `factory` 생성자
  ///
  /// `Firestore`에서 받은 데이터를 [Student]객체로 반환하는 메서드로 [json]에
  /// `Firestore`에서 받은 데이터를 넣으면 된다.
  ///
  /// ```dart
  /// final studentRef = db.collection('students').doc('test');
  /// studentRef.get().then(
  ///   (DocumentSnapshot doc) {
  ///     final student = Student.fromJson(jsonDecode(doc.data()));
  ///    },
  ///    onError: (e) => print('Error Detected: $e'),
  ///   );
  /// ```
  factory Student.fromJson(Map<String, dynamic> json) => Student(
      studentId: json['studentId'],
      attendanceStudentId: json['attendanceStudentId'],
      department: json['department'],
      subject: json['subject'],
      name: json['name']);

  /// 객체를 `JSON`으로 직렬화 하는 메서드
  ///
  /// 객체를 `Firestore`에게 쉽게 올릴 수 있도록 직렬화를 수행한다.
  /// 이 메서드는 별도로 호출될 필요 없이 `jsonEncode()`메서드에 사용된다.
  ///
  /// ```dart
  /// String json = jsonEncode(student);
  /// ```
  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'attendanceStudentId': attendanceStudentId,
        'department': department,
        'subject': subject,
        'name': name
      };

  /// 학생이 같은지 판단하기 위한 수단으로 학번을 비교한다.
  @override
  bool operator ==(Object other) =>
      (other is Student) && (studentId == other.studentId);

  @override
  int get hashCode => studentId.hashCode;
}
