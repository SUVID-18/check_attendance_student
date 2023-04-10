import 'dart:convert';

import 'package:check_attendance_student/model/student.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('학생 객체 테스트', () {
    test('학생 객체가 정상적으로 생성되는지 테스트', () {
      final student = Student(
          studentId: '18017xxx',
          attendanceStudentId: const Uuid().v4(),
          department: '컴퓨터학부',
          subject: '컴퓨터 SW',
          name: '수원대');
      expect(student.name, '수원대');
    });
    test('학생 객체의 학생 식별용 UUID 변경 테스트', () {
      final student = Student(
          studentId: '18017xxx',
          attendanceStudentId: const Uuid().v4(),
          department: '컴퓨터학부',
          subject: '컴퓨터 SW',
          name: '수원대');
      var newUuid = const Uuid().v4();
      var newStudent = student.updateStudentUuid(newUuid);
      expect(newStudent.attendanceStudentId, newUuid);
    });
    test('학생 객체의 직렬화 테스트', () {
      final student = Student(
          studentId: '18017xxx',
          attendanceStudentId: const Uuid().v4(),
          department: '컴퓨터학부',
          subject: '컴퓨터 SW',
          name: '수원대');
      final jsonData = jsonEncode(student);
      expect(student, Student.fromJson(jsonDecode(jsonData)));
    });
  });
}
