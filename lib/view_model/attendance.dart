import 'package:check_attendance_student/model/lecture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    var now = DateTime.now();
    var subjects = FirebaseFirestore.instance.collection('subjects');
    var query = await subjects
        .where('tag_uuid', isEqualTo: uuid)
        .where('day_week', isEqualTo: now.weekday - 1)
        .get();
    if (query.docs.isEmpty) {
      return null;
    }
    return compute(_parseLecture, query.docs);
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
    var now = DateTime.now();
    var subjects = FirebaseFirestore.instance.collection('subjects');
    var query = await subjects
        .where('tag_uuid', isEqualTo: uuid)
        .where('day_week', isEqualTo: now.weekday - 1)
        .where('start_at',
            isGreaterThan:
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(6, '0')}')
        .get();
    if (query.docs.isEmpty) {
      return null;
    } else {
      var data = query.docs.first.data();
      var roomName = await FirebaseFirestore.instance
          .collection('classroom')
          .where('tag_uuid', isEqualTo: uuid)
          .get();
      if (roomName.docs.isEmpty) {
        return null;
      } else {
        data.putIfAbsent('room', () => roomName.docs.first.data()['name']);
      }
      return Lecture.fromJson(data);
    }
  }

  List<Lecture> _parseLecture(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> result) =>
      result.map((document) => Lecture.fromJson(document.data())).toList();

  AttendanceViewModel._init({required this.uuid});
}
