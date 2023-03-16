import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final Widget? child;
  final bool isOrange;
  final double? width;
  final Color textColor;
  final double textSize;
  final double height;

  const CustomButton({
    Key? key,
    required this.onPressed,
    this.text,
    this.child,
    this.isOrange = false,
    this.width,
    this.textColor = kDarkGrey,
    this.textSize = 14,
    this.height = 56
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromHeight(height),
          backgroundColor: isOrange ? kPrimary : kWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: BorderSide(
              color: isOrange ? Colors.transparent : kDisabledBorderColor
            )
          ),
        ),
        child: child ?? CustomText(
          text: text!,
          isMediumWeight: true,
          color: isOrange ? kWhite : textColor,
          fontSize: textSize,
        )
      ),
    );
  }
}
