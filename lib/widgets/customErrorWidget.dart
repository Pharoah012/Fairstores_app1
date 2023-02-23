import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomError extends StatelessWidget {
  final String errorMessage;
  final bool oneRemove;

  CustomError({
    Key? key,
    this.oneRemove = false,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: CustomText(
        text: "Error",
      ),
      content: CustomText(
        text: errorMessage,
      ),
      actions: [
        CustomButton(
          text: "Okay",
          onPressed: (){
            oneRemove == true ? null : Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
