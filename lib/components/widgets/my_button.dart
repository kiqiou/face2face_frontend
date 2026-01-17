import 'package:face2face/components/const/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onChange;
  final String buttonName;

  const MyButton({super.key, required this.onChange, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange();
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              MyColors.accent,
              MyColors.accentLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.accent.withOpacity(0.25),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
