import 'package:flutter/foundation.dart';

/// 강의에 대한 정보를 가지고 있는 클래스
@immutable
class Lecture {

  /// 강의명
  final String name;

  /// 강의 수강 대상 학부
  final String department;

  /// 강의 수강 대상 학과
  final String major;

  /// 강의실
  final String room;


  /// 강의 시작 시간
  final String startLesson;

  /// 강의 종료 시간
  final String endLesson;

  /// 강의 정보에 관한 객체를 생성한다.
  ///
  /// [id]에는 강의의 번호를 [name]에는 강의 이름을
  /// 넣는 식으로 강의 객체를 생성한다. 매개변수별 설명은 커서에 올리면
  /// 표시된다.
  const Lecture({
      required this.name,
      required this.department,
      required this.major,
      required this.room,
      required this.startLesson,
      required this.endLesson,
  });

  /// [json]에서 객체를 역직렬화 하는 경우(강의 객체로 가져오기) 사용되는 `factory` 생성자
  ///
  /// `Firestore`에서 받은 데이터를 [Lecture]객체로 반환하는 메서드로 [json]에
  /// `Firestore`에서 받은 데이터를 넣으면 된다.
  ///
  /// ```dart
  /// final lectureRef = db.collection('lectures').doc('test');
  /// lectureRef.get().then(
  ///   (DocumentSnapshot doc) {
  ///     final student = Lecture.fromJson(jsonDecode(doc.data()));
  ///    },
  ///    onError: (e) => print('Error Detected: $e'),
  ///   );
  /// ```
  factory Lecture.fromJson(Map json) => Lecture(
      name: json['name'],
      department: json['department'],
      major: json['major'],
      room: '',
      startLesson: json['start_at'],
      endLesson: json['end_at']);
}
