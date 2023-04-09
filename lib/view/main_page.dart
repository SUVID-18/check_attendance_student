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
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
      ),
      body: Center(
        child: Column(
          children: [
            Text('페이지 이동 버튼 모음', style: Theme.of(context).textTheme.headlineLarge,),
            MaterialButton(
                child: Text('로그인 페이지로'),
                onPressed: () => context.push('/login')),
            MaterialButton(
                child: Text('설정 페이지로'),
                onPressed: () => context.push('/settings')),
            MaterialButton(
                child: Text('디바이스 등록 페이지로'),
                onPressed: () => context.push('/register_device')),
            MaterialButton(
                child: Text('출결 기록 페이지로'),
                onPressed: () => context.push('/history')),
          ],
        ),
      ),
    );
  }
}
