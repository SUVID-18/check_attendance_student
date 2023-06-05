import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 기기변경 페이지의 동작을 담당하는 클래스
class RegisterDeviceViewModel {
  /// 이름에 해당되는 컨트롤러
  final nameController = TextEditingController();

  /// 전화번호에 해당되는 컨트롤러
  final phoneNumberController = TextEditingController();

  /// 학번에 해당되는 컨트롤러
  final studentIDController = TextEditingController();

  /// 이메일에 해당되는 컨트롤러
  final emailIDController = TextEditingController();

  /// 특정 메서드에서 위젯을 띄우기 위한 [BuildContext]
  final BuildContext context;

  /// 기기변경 페이지의 동작을 담당하는 생성자
  ///
  /// 기기변경 페이지에서 필요한 부분에 대입시키면 된다.
  ///
  /// ```dart
  ///var viewModel = RegisterDeviceViewModel();
  ///TextField(
  ///        controller: viewModel.nameController,
  ///        decoration: InputDecoration(
  ///            filled: true,
  ///            labelText: 'ID'
  ///        ),
  ///      ),
  ///```
  factory RegisterDeviceViewModel({required BuildContext context}) =>
      RegisterDeviceViewModel._init(context: context);

  /// 기기변경 페이지에서 기기변경 버튼을 누른 경우 수행할 동작
  ///
  /// 기기변경 버튼의 `onPressed`에 해당 메서드를 등록하면 된다.
  /// 입력칸 중 하나라도 비어있을 시 [blankDialog]에 제공된 `Dialog`를 띄우고
  /// 정상 입력을 할 시 기기변경이 진행된다.
  ///
  /// ```dart
  /// ElevatedButton(
  ///      onPressed: () => viewModel.onSubmitPressed(
  ///          loginBlankDialog: AlertDialog(
  ///              title: Text('안내'),
  ///              content: Text('모든 항목을 입력하십시오'),
  ///              actions: <Widget>[
  ///                TextButton(
  ///                    onPressed: () => Navigator.pop(context),
  ///                    child: Text('확인'))
  ///              ])),
  ///      child: Text('기기 등록'))
  ///```
  void onSubmitPressed({required AlertDialog blankDialog}) {
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        studentIDController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => blankDialog,
      );
    } else {
      var user = FirebaseAuth.instance.currentUser;
      // 기존 회원이 아닌 경우
      if (user != null) {
        var db = FirebaseFirestore.instance;
        var batch = db.batch();
        var document = db.collection('students').doc(user.uid);
        SharedPreferences.getInstance().then((pref) {
          // 설정 저장소에 저장된 값 읽기(로그인 과정에서 저장되기에 없으면 오류)
          var attendanceStudentId = pref.getString('attendanceStudentId');
          if (attendanceStudentId != null) {
            batch
                .update(document, {'attendanceStudentId': attendanceStudentId});
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('무결성 오류'),
                content:
                    const Text('기기변경 작업 수행 도중 문제가 발생하였습니다. 앱을 재설치 해주시기 바랍니다.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'))
                ],
              ),
            );
            return;
          }
        });
        batch.commit().then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
                content: const Text('기기변경이 완료 되었습니다.'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)))));
      }
    }
  }

  RegisterDeviceViewModel._init({required this.context});
}
