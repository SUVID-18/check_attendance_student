import 'package:check_attendance_student/model/lecture.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 출결진행 페이지의 동작을 담당하는 클래스
class AttendanceViewModel {
  /// 강의실 정보를 가진 태그 UUID
  final String uuid;

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
  factory AttendanceViewModel({required String uuid}) =>
      AttendanceViewModel._init(uuid: uuid);

  /// 현재 강의실에서 오늘 진행하는 모든 강의 정보를 반환하는 메서드
  ///
  /// 특정 강의실에서 오늘 존재하는 과목을 [List]로 모두 반환하고 존재하지 않을 시 `null`을 반환한다.
  ///
  /// ## 같이보기
  /// * [FutureBuilder]
  /// * [Lecture]
  Future<List<Lecture>?> getAllLectures() async {
    try {
      var subjects = await FirebaseFunctions.instance
          .httpsCallable('get_all_subjects')
          .call({
        'tag_uuid': uuid,
      });
      return compute(_parseLecture, subjects.data as List);
    } on FirebaseFunctionsException {
      return null;
    }
  }

  /// 출결을 진행하는 버튼
  ///
  /// 로그인한 사용자의 출결을 진행합니다. [FutureBuilder]를 통해 출석 완료 후
  /// 문제 없을 시 종료되며 문제 발생 시 [FirebaseFunctionsException]형태의 오류를 발생시킨다.
  ///
  /// 아래 방식으로 오류를 사용자에게 알릴 수 있다.
  ///
  ///
  /// ```dart
  /// var error = snapshot.error as FirebaseFunctionsException;
  /// print(err.message);
  /// print(err.code);
  ///```
  ///
  /// ## 같이보기
  /// * [FutureBuilder]
  /// * [FirebaseFunctionsException]
  ///
  Future<HttpsCallableResult> onSubmit() async {
    var preference = await SharedPreferences.getInstance();
    var deviceToken = preference.getString('attendanceStudentId');
    return FirebaseFunctions.instance
        .httpsCallableFromUrl(
            'https://check-attendance-jygftfr24a-uc.a.run.app')
        .call({
      'device_uuid': deviceToken,
      'tag_uuid': uuid,
    });
  }

  /// 현재 출결 대상인 강의 정보를 반환하는 메서드
  ///
  /// 현재 출결 대상인 강의 정보를 반환하고 존재하지 않을 시 `null`을 반환한다.
  ///
  /// ## 같이보기
  /// * [FutureBuilder]
  /// * [Lecture]
  Future<Lecture?> getLecture() async {
    var preference = await SharedPreferences.getInstance();
    var deviceToken = preference.getString('attendanceStudentId');
    try {
      var subject = await FirebaseFunctions.instance
          .httpsCallable('check_available_subject')
          .call({
        'device_uuid': deviceToken,
        'tag_uuid': uuid,
      });
      return Lecture.fromJson(subject.data);
    } on FirebaseFunctionsException {
      return null;
    }
  }

  List<Lecture> _parseLecture(List result) =>
      result.map((subject) => Lecture.fromJson(subject)).toList();

  AttendanceViewModel._init({required this.uuid});
}
