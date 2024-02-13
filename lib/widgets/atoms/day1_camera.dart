import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Day1Camera extends StatelessWidget {
  const Day1Camera({
    super.key,
    required Future<void> initializeControllerFuture,
    required this.controller,
  }) : _initializeControllerFuture = initializeControllerFuture;

  final Future<void> _initializeControllerFuture;
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              // 미리보기
              return CameraPreview(controller);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}