import 'package:fairstores/constants.dart';
import 'package:fairstores/models/JointMenuOption.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class JointMenuOption extends StatelessWidget {
  final bool isActive;
  final JointMenuOptionModel menuOption;

  const JointMenuOption({
    Key? key,
    this.isActive = false,
    required this.menuOption
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? kPrimary : Colors.transparent
          )
        )
      ),
      child: Center(
        child: CustomText(
          text: menuOption.name,
          color: isActive ? kPrimary : kBlack,
          isBold: true,
        ),
      ),
    );
  }
}
