import 'package:fairstores/constants.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/otpTimerProvider.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextButton.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomOTPDrawer extends ConsumerStatefulWidget {
  final String phoneNumber;
  final TextEditingController otpController;
  final VoidCallback verificationLogic;

  const CustomOTPDrawer({
    Key? key,
    required this.phoneNumber,
    required this.verificationLogic,
    required this.otpController
  }) : super(key: key);

  @override
  ConsumerState<CustomOTPDrawer> createState() => _CustomOTPDrawerState();
}

class _CustomOTPDrawerState extends ConsumerState<CustomOTPDrawer> {
  @override
  Widget build(BuildContext context) {
    final duration = ref.watch(durationProvider);
    final _otpTimer = ref.watch(otpTimerProvider);
    final _minutes = ref.watch(minuteProvider);
    final _seconds = ref.watch(secondsProvider);
    final _resendToken = ref.watch(resendTokenProvider);
    final _receivedVerificationID = ref.watch(receivedVerificationIDProvider);
    final _auth = ref.watch(authProvider);

    ref.listen(durationProvider, (previous, Duration next) {
      ref.read(minuteProvider.notifier).state = strDigits(next.inMinutes.remainder(60));
      ref.read(secondsProvider.notifier).state = strDigits(next.inSeconds.remainder(60));
    });

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.0,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20
          ),
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
                    'phone number ${widget.phoneNumber}',
                color: kDarkGrey,
              ),
              SizedBox(height: 8,),
              CustomTextFormField(
                  labelText: "Enter the OTP",
                  controller: widget.otpController
              ),
              SizedBox(height: 20,),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            text: "Resend code in"
                        ),
                        SizedBox(width: 5,),
                        CustomText(
                          text: '$_minutes:$_seconds',
                          color: kPrimary,
                          isBold: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    CustomTextButton(
                      isEnabled: !(_otpTimer != null && _otpTimer.isActive),
                      title: "Resend OTP",
                      onPressed: (){
                        // send the OTP again
                        _auth.sendOTPForVerification(
                            phoneNumber: widget.phoneNumber,
                            ref: ref
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              CustomButton(
                width: MediaQuery.of(context).size.width,
                onPressed: widget.verificationLogic,
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
        ),
      )
    );
  }
}
