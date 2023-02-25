import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomSocialAuthButton extends StatelessWidget {
  final bool isApple;
  final bool isSignIn;
  final VoidCallback onPressed;

  const CustomSocialAuthButton({
    Key? key,
    required this.onPressed,
    this.isApple = true,
    this.isSignIn = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: isApple ? null : Border.all(
          color: kDisabledBorderColor,
        ),
        borderRadius: BorderRadius.circular(40)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: isApple ? kBlack : kWhite,
                elevation: 0
            ),
            child: Center(
              child: isApple ? appleLabel() : googleLabel(),
            )
        ),
      ),
    );
  }

  Widget appleLabel(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("images/applelogo.png"),
        SizedBox(width: 10,),
        CustomText(
          text: isSignIn ? "Sign in with Apple" : "Sign up with Apple",
          color: kWhite,
            isBold: true
        )
      ],
    );
  }

  Widget googleLabel(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("images/google.png"),
        SizedBox(width: 10,),
        CustomText(
          text: isSignIn ? "Sign in with Google" : "Sign up with Google",
          color: kBlack,
          isBold: true
        )
      ],
    );
  }
}
