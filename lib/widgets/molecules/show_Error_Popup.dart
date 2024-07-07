import 'package:flutter/material.dart';
import 'package:day1/widgets/organisms/error_popup.dart';

void showErrorPopup(BuildContext context, String msg, {VoidCallback? navigate}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: ErrorPopup(
            errorMassage: msg,
            navigate: navigate,
          ),
        );
      });
}