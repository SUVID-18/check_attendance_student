import 'package:nfc_manager/nfc_manager.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

/// NFC 태깅을 감지했을 때, 태그 uuid를 읽어 attendance.dart 페이지를 Navigate하는 [dynamicLink]를 반환하는 뷰 모델이다.
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