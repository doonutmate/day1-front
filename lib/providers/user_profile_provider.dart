// 사용자 프로필 상태 관리자
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

final userProfileProvider = StateProvider<UserProfile?>((ref) => null);