import 'package:cloud_firestore/cloud_firestore.dart';

final onboardingRef = FirebaseFirestore.instance.collection('Onboarding');

class OnboardingModel{

  final String onboardingText;
  final String onboardingHeader;
  final String onboardingImage;
  final String id;

  OnboardingModel({
    required this.onboardingText,
    required this.onboardingHeader,
    required this.onboardingImage,
    required this.id
  });

  factory OnboardingModel.fromDocument(DocumentSnapshot doc){
    return OnboardingModel(
      id: doc.get('id'),
      onboardingHeader: doc.get('onboarding_header'),
      onboardingImage: doc.get('onboarding_image'),
      onboardingText: doc.get('onboarding_text')
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "onboardingText": this.onboardingText,
      "onboardingHeader": this.onboardingHeader,
      "onboardingImage": this.onboardingImage,
      "id": this.id,
    };
  }

  // Query onboarding info from database
  Future<List<OnboardingModel>> getOnboardingInfo() async {
    QuerySnapshot snapshot = await onboardingRef
        .doc('Onboarding_info')
        .collection('information')
        .get();

    List<OnboardingModel> onboardingList = await snapshot.docs.map(
      (doc) => OnboardingModel.fromDocument(doc)
    ).toList();

    return onboardingList;
  }
}