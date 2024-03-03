import 'package:day1/services/oauth_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';
import '../../screens/camera/camera.dart';
import '../../services/dio.dart';

class StoreTextButton extends ConsumerWidget {
  const StoreTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parent = context.findAncestorStateOfType<CameraScreenState>();
    //서버 토큰 불러오기
    String? token = ref.watch(ServerTokenProvider.notifier).getServerToken();
    return TextButton(
      onPressed: ()async{
        //camareascreen의 response이미지가 null이 아니고 서버토큰이 null이 아닐 시 서버에 이미지 업로드
        if(parent != null && parent.responseImage != null && token != null){
          bool uploadResult = await DioService.uploadImage(parent!.responseImage!, token);

          //이미지 업로드가 정상적으로 수행됐을 때 달력화면으로 전환
          if(uploadResult){
            Navigator.pushReplacementNamed(context, '/main');
          }
        }


      },
      child: Text(
        "저장",
        style: TextStyle(
            fontSize: cameraScreenTextSize,
            color: textButtonColor
        ),
      ),
    );
  }
}