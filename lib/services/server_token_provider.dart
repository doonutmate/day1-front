import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/kakao_token_model.dart';

//토큰 관리 프로바이더
final ServerTokenProvider = StateNotifierProvider<ServerTokenStateNotifier, KakaoTokenState>((ref) {
  return ServerTokenStateNotifier();
});

class ServerTokenStateNotifier extends StateNotifier<KakaoTokenState> {
  ServerTokenStateNotifier() : super(KakaoTokenState());


  void setServerToken(String? token) {
    state.token = token;
  }


  String? getServerToken() {
    return state.token;
  }


}





