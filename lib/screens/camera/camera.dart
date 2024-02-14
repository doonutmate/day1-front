import 'dart:io';
import 'package:camera/camera.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/widgets/atoms/flash_change_button.dart';
import 'package:day1/widgets/atoms/flip_button.dart';
import 'package:day1/widgets/atoms/shutter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import '../../widgets/atoms/day1_camera.dart';

const int targetWidth = 48;
const int targetHeight = 48;

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen(List<CameraDescription> this.cameras, {super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();


}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  String formatDate = "";
  bool isFrontCamera = false;
  File? responseImage;


  @override
  void initState() {
    super.initState();
    setCamera(isFrontCamera);



  }

  @override
  void dispose() {
    // 카메라 컨트롤러 해제
    controller.dispose();
    super.dispose();
  }

  void setCamera(bool isFront) {
    String camera1 = widget.cameras[0].lensDirection.name;
    String camera2 = widget.cameras[1].lensDirection.name;

    controller = CameraController(
      isFront ? widget.cameras[1] : widget.cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.bgra8888
    );

    _initializeControllerFuture = controller.initialize().then((_) {
      // 카메라가 작동되지 않을 경우
      if (!this.mounted) {
        print("이니셜라이즈 실패");
        return;
      }
      controller.setFlashMode(FlashMode.off);
      // 카메라가 작동될 경우
      setState(() {
        // 코드 작성
      });
    })
    // 카메라 오류 시
        .catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("CameraController Error : CameraAccessDenied");
            // Handle access errors here.
            break;
          default:
            print("CameraController Error");
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Future<void> _takePicture() async {
    if (!controller.value.isInitialized || controller == null) {
      return;
    }
    try {
      // 사진 촬영
      final file = await controller.takePicture();

      final _reduceFile;
      _reduceFile = await compressFile(file);

      final _resizeFile;
      _resizeFile = await resizeImage(_reduceFile!);

      if(_resizeFile != null){
        await DioService.uploadImage(_resizeFile);
        setState(() {
          responseImage = _resizeFile;
        });
      }

      /*//final bytes = await File(path).readAsBytes();
      //final img.Image? image = img.decodeImage(bytes);

      // import 'dart:io';
      // 사진을 저장할 경로 : 기본경로(storage/emulated/0/)
      Directory directory = Directory('storage/emulated/0/DCIM/MyImages');

      // 지정한 경로에 디렉토리를 생성하는 코드
      // .create : 디렉토리 생성    recursive : true - 존재하지 않는 디렉토리일 경우 자동 생성
      await Directory(directory.path).create(recursive: true);

      // 지정한 경로에 사진 저장
      await File(file.path).copy('${directory.path}/${file.name}');*/
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<File?> resizeImage(XFile _image) async {
    late final img.Image resizedImage;
    final path = _image.path;
    final bytes = await File(path).readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      resizedImage =
          img.copyResize(image, width: targetWidth, height: targetHeight);

      String tempPath = (await getTemporaryDirectory()).path;
      var now = new DateTime.now();
      formatDate = DateFormat('yyMMdd_HH:mm:ss').format(now);
      final tempFile = File('$tempPath/${formatDate}_resized_image.jpg');

      return tempFile.writeAsBytes(img.encodeJpg(resizedImage));
    } else {
      return null;
    }
  }

  Future<XFile?> compressFile(XFile file) async {
    var fileFromImage = File(file.path);
    var basename = path.basenameWithoutExtension(fileFromImage.path);
    var pathString = fileFromImage.path.split(path.basename(fileFromImage.path))[0];

    var pathStringWithExtension = "$pathString${basename}_image.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      pathStringWithExtension,
      quality: 5,
    );

    //if (result != null) print(await result.length());

    return result;
  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CloseButton(
                onPressed: (){
                  Navigator.of(context, rootNavigator: true)
                      .pop();
                },
              ),
              Text(formatDate),
              Day1Camera(initializeControllerFuture: _initializeControllerFuture, controller: controller),
              Expanded(flex: 1, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlashChangeButton(controller: controller),
                    ShutterButton(func: _takePicture),
                    FlipButton(func: setCamera),
                  ],
                ),
              ),
              if(responseImage != null)
              Image.file(responseImage!),
              Expanded(flex: 2, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}


