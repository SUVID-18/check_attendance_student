import 'package:nfc_manager/nfc_manager.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

/// NFC 태깅을 감지했을 때, 태그 uuid를 읽어 attendance.dart 페이지를 Navigate하는 [dynamicLink]를 반환하는 뷰 모델이다.
///
/// ```dart
/// final DynamicLinkTagViewModel _viewModel = DynamicLinkTagViewModel();
///
/// onPressed: () async {
///   final dynamicLink = await _viewModel.readTag()
/// }


// dynamic link를 받아서 view에서 알아서 화면을 띄우게 하려고 했는데,
// 이러면 onPressed같은 반응형 위젯에만 적용이 되고, 백그라운드에서 nfc 태깅됐을 때 바로 페이지가 안떠오르지 않을까? 해서 자꾸 고민이 됐음.

// viewmodel에서 바로 context.go를 띄워야하나 고민했지만 해결 방향을 제대로 잡지 못함. 그래서 막힌듯..

class DynamicLinkTagViewModel {
  Map<String, dynamic> read_result = {};

  /// NFC 태깅을 감지했을 때, 태그 uuid를 읽어 attendance.dart 페이지를 Navigate한다.
  Future<Uri> readTag() async{
    dynamic uuid;
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async{
      read_result = tag.data;
      // uuid = tag.data.id ( 직렬화 후 uuid 정보를 가져옴. )
    });

    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('https://suvid.page.link/attendance?${uuid}'),
      uriPrefix: 'https://suvid.page.link',
      androidParameters: AndroidParameters(
        packageName: 'com.suvid.check_attendance_student',
      ),
    );

    /// NFC 태깅 시 반환되는 firebase DynamicLink.
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    return dynamicLink;
  }
}