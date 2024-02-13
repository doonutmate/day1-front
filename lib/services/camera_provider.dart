import 'package:camera/camera.dart';
import 'package:riverpod/riverpod.dart';

final camerasProvider = StateNotifierProvider<CameraStateNotifier, List<CameraDescription>>((ref) {
  return CameraStateNotifier();
});


class CameraStateNotifier extends StateNotifier<List<CameraDescription>> {
  CameraStateNotifier() : super([]);

  void setCameras(List<CameraDescription> _cameras) {
    state = _cameras;
  }

  List<CameraDescription> getCameras() {
    return state;
  }
}


