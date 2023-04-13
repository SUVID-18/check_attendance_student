import 'package:flutter/material.dart';

/// 기기변경 페이지의 동작을 담당하는 클래스
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
class RegisterDeviceViewModel {
  /// 이름에 해당되는 컨트롤러
  final nameController = TextEditingController();

  /// 전화번호에 해당되는 컨트롤러
  final phoneNumberController = TextEditingController();

  /// 학번에 해당되는 컨트롤러
  final studentIDController = TextEditingController();

  static final RegisterDeviceViewModel _instance =
      RegisterDeviceViewModel._init();

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
  factory RegisterDeviceViewModel() => _instance;

  /// 기기변경 페이지에서 기기변경 버튼을 누른 경우 수행할 동작
  ///
  /// 기기변경 버튼의 `onPressed`에 해당 메서드를 등록하면 된다.
  /// 입력칸 중 하나라도 비어있을 시 [loginBlankDialog]에 제공된 `Dialog`를 띄우고
  /// 정상 입력을 할 시 기기변경이 진행된다. 본 메서드는 [showDialog]메서드를 포함하기에
  /// [context]에 [BuildContext]를 넘겨주여야 한다.
  ///
  /// ```dart
  /// ElevatedButton(
  ///      onPressed: () => viewModel.onSubmitPressed(
  ///          context: context,
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
  void onSubmitPressed(
      {required BuildContext context, required AlertDialog loginBlankDialog}) {
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        studentIDController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => loginBlankDialog,
      );
    }
  }

  RegisterDeviceViewModel._init();
}
