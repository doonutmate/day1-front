import 'package:flutter/material.dart';

class MypageListTile extends StatelessWidget {
  String text;

  void Function()? func;

  MypageListTile({
    required this.text,
    this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      minVerticalPadding: 16,
      title: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
      onTap: func,
    );
  }
}