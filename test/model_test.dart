import 'dart:convert';

import 'package:check_attendance_student/model/attendance_information.dart';
import 'package:check_attendance_student/model/lecture.dart';
import 'package:check_attendance_student/model/student.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('학생 객체 테스트', () {
    test('학생 객체가 정상적으로 생성되는지 테스트', () {
      final student = Student(
          studentId: '18017xxx',
          department: '컴퓨터학부',
          major: '컴퓨터 SW',
          name: '수원대');
      expect(student.name, '수원대');
    });
    test('학생 객체의 직렬화 테스트', () {
      final student = Student(
          studentId: '18017xxx',
          department: '컴퓨터학부',
          major: '컴퓨터 SW',
          name: '수원대');
      final jsonData = jsonEncode(student);
      expect(student, Student.fromJson(jsonDecode(jsonData)));
    });
  });
  group('강의 정보 객체 테스트', () {
    test('강의 객체가 정상적으로 생성되는지 테스트', () {
      const lecture = Lecture(
          id: '18000000',
          name: 'Flutter의 개발과 이해',
          department: '컴퓨터학부',
          major: '컴퓨터SW',
          room: 'IT 000호',
          professorId: '18000000',
          dayWeek: 1,
          startLesson: '11:15:00.000000',
          endLesson: '13:20:00.000000',
          validTime: 20);
      expect(lecture.name, 'Flutter의 개발과 이해');
    });
    test('강의 객체의 직렬화 테스트', () {
      const lecture = Lecture(
          id: '18000000',
          name: 'Flutter의 개발과 이해',
          department: '컴퓨터학부',
          major: '컴퓨터SW',
          room: 'IT 000호',
          professorId: '18000000',
          dayWeek: 1,
          startLesson: '11:15:00.000000',
          endLesson: '13:20:00.000000',
          validTime: 20);
      final jsonData = jsonEncode(lecture);
      expect(lecture.id, Lecture.fromJson(jsonDecode(jsonData)).id);
    });
  });
  group('출결 여부를 가진 객체 테스트', () {
    test('출결 여부를 가진 객체가 생성되는지 테스트', () {
      const attendanceInfo = AttendanceInformation(
          subjectName: '프로그래밍 언어론',
          professorName: '조영일',
          result: AttendanceResult.normal);
      expect(attendanceInfo.subjectName, '프로그래밍 언어론');
    });
    test('출결 여부를 가진 객체의 직렬화 테스트', () {
      const attendanceInfo = AttendanceInformation(
          subjectName: '프로그래밍 언어론',
          professorName: '조영일',
          result: AttendanceResult.normal);
      final jsonData = jsonEncode(attendanceInfo);
      expect(attendanceInfo.professorName,
          AttendanceInformation.fromJson(jsonDecode(jsonData)).professorName);
    });
  });
}
