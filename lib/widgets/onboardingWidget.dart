import 'package:fairstores/constants.dart';
import 'package:fairstores/models/onboarding_model.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';


class OnboardingWidget extends StatelessWidget {
  final OnboardingModel onboardModel;
 
  const OnboardingWidget({
    Key? key,
    required this.onboardModel
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          onboardModel.onboardingImage,
        ),
        CustomText(
          text: onboardModel.onboardingHeader,
          fontSize: 24,
          isBold: true,
          color: kBlack,
        ),
        CustomText(
          text: onboardModel.onboardingText,
          isCenter: true,
          color: kBlack,
        )
      ],
    );
  }
}