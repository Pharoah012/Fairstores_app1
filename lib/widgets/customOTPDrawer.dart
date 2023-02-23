import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';

class CustomOTPController extends StatelessWidget {
  final String phoneNumber;
  final TextEditingController otpController;
  final VoidCallback verificationLogic;

  const CustomOTPController({
    Key? key,
    required this.phoneNumber,
    required this.verificationLogic,
    required this.otpController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "OTP Verification",
              fontSize: 20,
              isMediumWeight: true,
              color: kBrownText,
            ),
            SizedBox(height: 8,),
            CustomText(
              text: 'Enter the 6 digits code sent to your '
                  'phone number ${phoneNumber}',
              color: kWhiteButtonTextColor,
            ),
            SizedBox(height: 8,),
            CustomTextFormField(
                labelText: "Enter the OTP",
                controller: otpController
            ),
            SizedBox(height: 20,),
            CustomButton(
                onPressed: verificationLogic,
                text: "Continue",
                isOrange: true
            ),
            SizedBox(height: 8,),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: CustomText(
                    text: "Close",
                    color: kBlack,
                    isMediumWeight: true,
                  ),
                )
            ),
          ],
        ),
      )
    );
  }
}
