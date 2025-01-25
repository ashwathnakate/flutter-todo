import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:to_do/utils/buttons.dart';
import 'package:to_do/data/colors.dart';

class DialogueBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isDarkMode;

  DialogueBox({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: colors.lightTextIconAll, width: 1)),
        backgroundColor:
            isDarkMode ? colors.lightDialogueBox : colors.darkDialogueBox,
        content: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                style: TextStyle(color: colors.lightTextIconAll),
                controller: controller,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  hintText: 'New task....',
                  hintStyle: TextStyle(
                    color: colors.lightTextIconAll,
                    letterSpacing: 1,
                  ),
                ),
              ),

              //save and cancel button
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //save button
                  MyButton(
                    text: 'Save',
                    onPressed: onSave,
                    isDarkMode: isDarkMode,
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  //cancel button
                  MyButton(
                    text: 'Cancel',
                    onPressed: onCancel,
                    isDarkMode: isDarkMode,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
