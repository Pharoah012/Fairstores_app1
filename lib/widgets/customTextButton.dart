import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  VoidCallback? onPressed;
  final String? title;
  Color labelColor;
  final double fontSize;
  final bool isBold;
  final Widget? child;
  final bool isEnabled;

  CustomTextButton({
    Key? key,
    this.onPressed,
    this.child,
    this.title,
    this.labelColor = kPrimary,
    this.fontSize = 14,
    this.isBold = true,
    this.isEnabled = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width ?? MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: isEnabled ? onPressed : (){},
        child: child == null
          ? CustomText(
            text: title!,
            fontSize: fontSize,
            color: isEnabled ? labelColor : kDarkGrey,
          )
          : child!
      ),
    );
  }
}