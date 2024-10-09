import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  void signOut() {
    print("signOut() 호출됨");
    state = true;  // 탈퇴 상태로 변경
    print("상태가 true로 업데이트됨");
  }
}