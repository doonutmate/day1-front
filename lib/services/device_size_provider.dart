import 'dart:io';
import 'package:riverpod/riverpod.dart';

import '../models/device_size_model.dart';

// 실제 화면 크기 State 관리 프로바이더
final deviceSizeProvider = StateNotifierProvider<deviceSizeStateNotifier, DeviceSize>((ref) {
  return deviceSizeStateNotifier();
});


class deviceSizeStateNotifier extends StateNotifier<DeviceSize> {
  deviceSizeStateNotifier() : super(DeviceSize());

  void setDeviceWidth(double _width) {
    state.width = _width;
  }

  double getDeviceWidth() {
    return state.width;
  }

  void setDeviceHeight(double _height) {
    state.height = _height;
  }

  double getDeviceHeight() {
    return state.height;
  }
}




