import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// 출결 기록을 확인하는 페이지 입니다.
///
/// 이곳에서 본인의 출결 내역 확인이 가능합니다.

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class Event {
  String title;
  bool complete;
  Event(this.title, this.complete);

  @override
  String toString() => title;
}

Map<DateTime,dynamic> eventSource = {
  DateTime(2023,4,3) : [Event('5분 기도하기',false),Event('교회 가서 인증샷 찍기',true),Event('QT하기',true),Event('셀 모임하기',false),],
  DateTime(2023,4,4) : [Event('5분 기도하기',false),Event('치킨 먹기',true),Event('QT하기',true),Event('셀 모임하기',false),],
  DateTime(2023,4,5) : [Event('5분 기도하기',false),Event('자기 셀카 올리기',true),Event('QT하기',false),Event('셀 모임하기',false),],
  DateTime(2023,4,11) : [Event('5분 기도하기',false),Event('가족과 저녁식사 하기',true),Event('QT하기',true)],
  DateTime(2023,4,13) : [Event('5분 기도하기',false),Event('교회 가서 인증샷 찍기',true),Event('QT하기',false),Event('셀 모임하기',false),],
  DateTime(2023,4,15) : [Event('5분 기도하기',false),Event('치킨 먹기',false),Event('QT하기',true),Event('셀 모임하기',false),],
  DateTime(2023,4,18) : [Event('5분 기도하기',false),Event('자기 셀카 올리기',true),Event('QT하기',false),Event('셀 모임하기',false),],
  DateTime(2023,4,20) : [Event('5분 기도하기',true),Event('자기 셀카 올리기',true),Event('QT하기',true),Event('셀 모임하기',true),],
  DateTime(2023,4,21) : [Event('5분 기도하기',false),Event('가족과 저녁식사 하기',true),Event('QT하기',false)]
};

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('출결 관리 페이지'),
      ),
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime(2023,4,1),
        lastDay: DateTime(2023,12,31),
        locale: 'ko-KR',
        daysOfWeekHeight: 30,
      ));
  }
}
