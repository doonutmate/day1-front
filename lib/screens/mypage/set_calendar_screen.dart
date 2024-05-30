import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';
import '../../widgets/atoms/radius_text_button.dart';
import '../../widgets/molecules/title_textformfield_group.dart';

class SetCalendarScreen extends StatefulWidget {
  const SetCalendarScreen({super.key});

  @override
  State<SetCalendarScreen> createState() => _SetCalendarScreenState();
}

class _SetCalendarScreenState extends State<SetCalendarScreen> {
  late TextEditingController myController; // Textformfield controller
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late FocusNode focusNode;
  bool isError = false;
  String currentText = "";

  @override
  void initState() {
    myController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  String? validateTextFormField (String? value){
    if (value?.isEmpty ?? true)
    {
      isError = true;
      setState(() {
        currentText = "";
      });
      return '';
    }
    else if (value!.length > 12){
      isError = true;

      setState(() {
        currentText = value.replaceRange(value.length - 1, value.length, "");;
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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: appBarHeight,
          title: Text(
            "캘린더 설정",
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
          padding: const EdgeInsets.symmetric(horizontal: mypageHorizontalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              TitleTextformfieldGroup(
                focusNode: focusNode,
                title: "제목",
                formKey: formKey,
                myController: myController,
                validateTextFormField: validateTextFormField,
                isError: isError,
                errorText: '1자 이상 8자 이하로 작성해주세요.',
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  formKey.currentState?.validate();
                },
                child: RadiusTextButton(
                  height: 48,
                  backgroudColor: isError == true ? gray300 : primary,
                  radius: 4,
                  text: "저장하기",
                  textColor: white,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}
