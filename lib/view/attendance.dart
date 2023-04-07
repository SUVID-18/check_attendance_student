import 'package:flutter/material.dart';

/// 태그 시 간단한 강의실 정보와 출석하기 버튼을 출력하는 페이지입니다.
class AttendancePage extends StatelessWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/swu_att_bg.png')
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: const [
                            Icon(Icons.school_outlined),
                            Text('  출석체크', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23.0
                            ))
                          ],
                        ),
                      ),
                      Text('강의실 이름: ', style: Theme.of(context).textTheme.headlineSmall),
                      Text('과목 이름: ', style: Theme.of(context).textTheme.headlineSmall,),
                      // 출석을 진행하는 동작을 수행하는 버튼
                      SizedBox(height: MediaQuery.of(context).size.width - 300,),
                      OutlinedButton(onPressed: null, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check, color: Colors.green,),
                          Text(' 출석하기')
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

