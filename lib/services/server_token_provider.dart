import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/server_token_model.dart';

//토큰 관리 프로바이더
final ServerTokenProvider = StateNotifierProvider<ServerTokenStateNotifier, ServerTokenState>((ref) {
  return ServerTokenStateNotifier();
});

class ServerTokenStateNotifier extends StateNotifier<ServerTokenState> {
  ServerTokenStateNotifier() : super(ServerTokenState());


  void setServerToken(String? token) {
    state.token = token;
  }


  String? getServerToken() {
    return state.token;
  }


}





