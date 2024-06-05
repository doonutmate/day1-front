import 'dart:convert';
import 'dart:io';
import 'package:day1/constants/colors.dart';
import 'package:day1/services/dio.dart';
import 'package:day1/widgets/atoms/edit_profile_image.dart';
import 'package:day1/widgets/atoms/radius_text_button.dart';
import 'package:day1/widgets/molecules/title_textformfield_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/size.dart';
import '../../models/token_information.dart';
import '../../models/user_profile.dart';
import '../../providers/user_profile_provider.dart';
import '../../services/server_token_provider.dart';

class ChangeProfileScreen extends ConsumerStatefulWidget {
  const ChangeProfileScreen({super.key});

  @override
  ConsumerState<ChangeProfileScreen> createState() =>
      _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends ConsumerState<ChangeProfileScreen> {
  late TextEditingController myController; // Textformfield controller
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isError = false;
  String currentText = "";
  String profileUrl = "";
  late ImageProvider profileImage;
  String? token;
  late FocusNode focusNode;
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  XFile? pickedFile;

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    pickedFile = await picker.pickImage(source: imageSource, imageQuality:30);
    if (pickedFile != null) {
      setState(() {
        profileImage = FileImage(File(pickedFile!.path)); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
    token = ref.read(ServerTokenProvider.notifier).getServerToken();
    final userProfile = ref.read(userProfileProvider); //사용자 프로필 구독
    focusNode = FocusNode();
    profileUrl = userProfile?.profileImageUrl ?? "";
    currentText = userProfile?.nickname ?? "";
    profileImage = (userProfile?.profileImageUrl != "" && userProfile != null)
        ? NetworkImage(userProfile!.profileImageUrl)
        : AssetImage('assets/icons/mypage_profile.png') as ImageProvider;
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void showChooseAlbumSheet() {
    showModalBottomSheet(
      barrierColor: Color(0x80222222),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 34, left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: RadiusTextButton(
                  height: 61,
                  backgroudColor: Color(0xB3F5F5F5),
                  radius: 13,
                  text: "앨범에서 선택",
                  textColor: Color(0xFF007AFF),
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: RadiusTextButton(
                  height: 61,
                  backgroudColor: white,
                  radius: 13,
                  text: "닫기",
                  textColor: Color(0xFF007AFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
      backgroundColor: Colors.transparent, // 앱 <=> 모달의 여백 부분을 투명하게 처리
    );
  }

  String? validateTextFormField(String? value) {
    if (value?.isEmpty ?? true) {
      isError = true;
      setState(() {
        currentText = "";
      });
      return '';
    } else if (value!.length > 8) {
      isError = true;

      setState(() {
        currentText = value.replaceRange(value.length - 1, value.length, "");
        ;
      });
      return '';
    }

    isError = false;

    setState(() {
      currentText = value;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    myController.text = currentText;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: appBarHeight,
            title: Text(
              "프로필 수정",
              style: TextStyle(
                fontSize: appBarTitleFontSize,
              ),
            ),
            leading: GestureDetector(
              onTap: (){
                if(focusNode.hasFocus == false)
                  Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios),
            ),
        ),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: mypageHorizontalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    showChooseAlbumSheet();
                  },
                  child: EditProfileImage(profileImage),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TitleTextformfieldGroup(
                focusNode: focusNode,
                title: "이름",
                formKey: formKey,
                myController: myController,
                validateTextFormField: validateTextFormField,
                isError: isError,
                errorText: '1자 이상 12자 이하로 작성해주세요.',
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  if(isError == false && myController.text != null && token != null){
                    Map<String, dynamic> tokenMap = jsonDecode(token!);
                    TokenInformation tokenInfo = TokenInformation.fromJson(tokenMap);
                    await DioService.uploadProfileInfo(pickedFile?.path ?? profileUrl , myController.text, tokenInfo.accessToken);
                    final userProfile = await fetchUserProfile(tokenInfo.accessToken);
                    ref.read(userProfileProvider.notifier).state = userProfile!;
                  }
                },
                child: RadiusTextButton(
                  height: 48,
                  backgroudColor: isError == true ? gray300 : primary,
                  radius: 4,
                  text: "수정하기",
                  textColor: white,
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
