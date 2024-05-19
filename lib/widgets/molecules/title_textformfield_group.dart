import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/size.dart';

class TitleTextformfieldGroup extends StatefulWidget {
  String title;
  FocusNode focusNode;
  GlobalKey<FormState> formKey;
  TextEditingController myController;
  String? Function(String?) validateTextFormField;
  bool isError;
  String errorText;
  TitleTextformfieldGroup({required this.title, required this.focusNode, required this.formKey, required this.myController,
    required this.validateTextFormField, required this.isError, required this.errorText, super.key});

  @override
  State<TitleTextformfieldGroup> createState() => _TitleTextformfieldGroupState();
}

class _TitleTextformfieldGroupState extends State<TitleTextformfieldGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: changeProfileGroupTitle,
            color: gray600,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Form(
          key: widget.formKey,
          child: TextFormField(
            focusNode: widget.focusNode,
            controller: widget.myController,
            style: TextStyle(
              fontSize: 16,
            ),
            validator: widget.validateTextFormField,
            onChanged: (value) {
              widget.formKey.currentState?.validate();
            },
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: (){
                  widget.myController.clear();
                  widget.formKey.currentState?.validate();
                },
                child: Image.asset("assets/icons/icn_clear_24.png"),
              ),
              contentPadding:
              EdgeInsets.only(left: 12, top: 12, bottom: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: editProfileBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primary),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: red500),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: red500),
              ),
              errorStyle: TextStyle(fontSize: 0),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          widget.errorText,
          style: TextStyle(
              fontSize: 14,
              color: widget.isError == true ? red500 : Colors.transparent
          ),
        ),
      ],
    );
  }
}
