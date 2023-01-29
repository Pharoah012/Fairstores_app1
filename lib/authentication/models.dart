import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class OnboardingModel extends StatelessWidget {
  final String onboardingText;
  final String onboardingHeader;
  final String onboardingImage;
  final String id;
 
  const OnboardingModel({Key? key,required this.id, required this.onboardingHeader, required this.onboardingImage, required this.onboardingText}) : super(key: key);

factory OnboardingModel.fromDocument(DocumentSnapshot doc){
  return
  OnboardingModel(id: doc.get('id'), onboardingHeader: doc.get('onboarding_header'), onboardingImage: doc.get('onboarding_image'), onboardingText: doc.get('onboarding_text'));
}
  @override
  Widget build(BuildContext context) {
    return 
     SizedBox(
       child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(

                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.41,
              ),
              Image.network(
                onboardingImage,
              ),
            ],
          ),
          Text(onboardingHeader,
              style:
                  GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 24)),
          Text(
              onboardingText,
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.manrope(fontWeight: FontWeight.w400, fontSize: 14)),
        ],
    ),
     )
    ;
  }
}