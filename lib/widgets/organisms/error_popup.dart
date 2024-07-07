import 'package:day1/constants/colors.dart';
import 'package:flutter/material.dart';
import '../atoms/radio_text_button.dart';

class ErrorPopup extends StatelessWidget {
  String errorMassage;
  VoidCallback? navigate;
  ErrorPopup({required this.errorMassage, this.navigate, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 222,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: white,
      ),
      child: Column(
        children: [
          SizedBox(height: 24,),
          Image(image: AssetImage("assets/icons/error.png")),
          SizedBox(height: 8,),
          Text(
            "오류 발생",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            errorMassage,
            style: TextStyle(
                fontSize: 16,
                color: gray600
            ),
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              if(navigate != null){
                navigate!();
              }
            },
            child: RadiusTextButton(
              width: 140,
              height: 42,
              backgroudColor: primary,
              radius: 5,
              text: "확인",
              textColor: white,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
