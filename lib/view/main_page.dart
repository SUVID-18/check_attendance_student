import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 홈 화면을 나타내는 페이지 입니다.
///
/// 홈 화면에서는 기본적으로 출결을 위한 태그 인식하기 버튼을 누를 수 있으며, 현재 출석을 하는 과목이 표시됩니다.
/// 또한 태그 접촉 완료 시의 화면도 표시됩니다.(이 부분은 백엔드 작업이 선행되어야 가능할 수도 있음)
class MainPage extends StatelessWidget {
  /// 앱의 이름에 해당되는 변수입니다.
  final String appName;

  const MainPage({required this.appName, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('페이지 이동 버튼모음')),
        body: Column(
          children: const <Widget>[
            Spacer(),
            ElevatedCardExample(),
            FilledCardExample(),
            OutlinedCardExample(),
            ElevatedCardExample_2(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class ElevatedCardExample extends StatelessWidget {
  const ElevatedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('로그인 페이지로')),
        ),
      ),
    );
  }
}

class FilledCardExample extends StatelessWidget {
  const FilledCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('설정 페이지로')),
        ),
      ),
    );
  }
}

class OutlinedCardExample extends StatelessWidget {
  const OutlinedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('디바이스 등록 페이지로')),
        ),
      ),
    );
  }
}

class ElevatedCardExample_2 extends StatelessWidget {
  const ElevatedCardExample_2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('출결 기록 페이지')),
        ),
      ),
    );
  }
}