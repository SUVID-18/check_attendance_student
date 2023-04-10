import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 로그인 페이지의 동작을 담당하는 클래스
///
/// 로그인 페이지에서 필요한 부분에 대입시키면 된다.
///
/// ```dart
///var viewModel = LoginViewModel();
///TextField(
///             controller: viewModel.usernameController,
///             decoration: InputDecoration(
///                 filled: true,
///                 labelText: 'ID'
///             ),
///           ),
///```
class LoginViewModel {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  /// 로그인 버튼을 누른 경우 수행할 동작
  ///
  /// 로그인 버튼의 `onPressed`에 해당 메서드를 등록하면 된다.
  /// ID와 비밀번호가 비어있을 시 [loginBlankDialog]에 제공된 `Dialog`를 띄우고
  /// 정상 입력을 할 시 로그인이 진행된다. 본 메서드는 [showDialog]메서드를 포함하기에
  /// [context]에 [BuildContext]를 넘겨주여야 한다.
  ///
  /// ```dart
  /// ElevatedButton(
  ///      onPressed: () => viewModel.onSubmitPressed(
  ///          context: context,
  ///          loginBlankDialog: AlertDialog(
  ///              title: Text('안내'),
  ///              content: Text('ID와 비밀번호를 모두 입력하십시요'),
  ///              actions: <Widget>[
  ///                TextButton(
  ///                    onPressed: () => Navigator.pop(context),
  ///                    child: Text('확인'))
  ///              ])),
  ///      child: Text('Next'))
  ///```
  void onSubmitPressed(
      {required BuildContext context, required AlertDialog loginBlankDialog}) {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => loginBlankDialog,
      );
    }
  }

  /// 로그인 페이지 하단에 기기변경 신청 버튼 누를 시 동작
  ///
  /// 기기변경 신청 버튼의 `onPressed`에 해당 메서드를 등록하면 된다.
  /// 페이지 이동을 위해 [context]가 필요하다.
  ///
  /// ```dart
  /// ElevatedButton(
  ///        child: Text(
  ///          '기기변경 신청',
  ///          style: TextStyle(fontSize: 15),
  ///        ),
  ///        onPressed: () => viewModel.onChangePressed(context),
  ///      ),
  ///```
  void onChangePressed(BuildContext context) =>
      context.push('/register_device');
}
