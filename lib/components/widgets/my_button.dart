import 'package:face2face/components/const/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onChange;
  final String buttonName;

  const MyButton({super.key, required this.onChange, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onChange();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.accent,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 23),
        textStyle: TextStyle(fontSize: 18),
        minimumSize: Size(170, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        buttonName,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
