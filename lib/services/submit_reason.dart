import 'dart:convert';
import 'package:http/http.dart' as http;


Future<void> submitReason(String reason) async {
  var url = Uri.parse(
      'https://script.google.com/macros/s/AKfycbxgn7Bg_KDp40D5njgnBOcAA8QJteEPSSKTDjh6SwCXA-K6VEdqeoPFxuPHTBFMAK1_Ew/exec');
  var response = await http.post(url, body: json.encode({'reason': reason}));

  if (response.statusCode == 200) {
    print('성공적으로 탈퇴 사유가 저장되었습니다.');
  } else {
    print('탈퇴 사유 저장에 실패했습니다: ${response.body}');
  }
}
