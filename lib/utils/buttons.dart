import 'package:flutter/material.dart';
import 'package:to_do/data/colors.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDarkMode;

  MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 40,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      color: isDarkMode
          ? colors.lightBtn
          : colors.darkBtn, // Use lightBtn color for both modes
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
}
