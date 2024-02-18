import 'dart:io';
import 'package:riverpod/riverpod.dart';

final camerasProvider = StateNotifierProvider<CameraStateNotifier, File?>((ref) {
  return CameraStateNotifier();
});


class CameraStateNotifier extends StateNotifier<File?> {
  CameraStateNotifier() : super(null);

  void setResponseImage(File? responsimage) {
    state = responsimage;
  }

  File? getResponseImage() {
    return state;
  }
}


