import 'dart:ffi';

import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isOrange;
  final double? width;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isOrange = false,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: width == null
        ? MediaQuery.of(context).size.width
        : width,
      decoration: BoxDecoration(
        border: isOrange ? null : Border.all(
          color: kDisabledBorderColor,
        ),
        borderRadius: isOrange ? null : BorderRadius.circular(40)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isOrange ? kPrimary : kWhite,
            elevation: 0
          ),
          child: CustomText(
            text: text,
            isMediumWeight: true,
            color: isOrange ? kWhite : kDarkGrey,
          )
        ),
      ),
    );
  }
}
