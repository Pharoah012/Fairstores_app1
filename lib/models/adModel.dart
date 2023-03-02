import 'package:cloud_firestore/cloud_firestore.dart';

final adsRef = FirebaseFirestore.instance.collection('Ads');

class AdModel {
  final String content;
  final String id;
  final String name;


  const AdModel({
    required this.content,
    required this.id,
    required this.name
  });

  factory AdModel.fromDocument(DocumentSnapshot doc){
    return AdModel(
        content: doc.get('ad_content'),
        id: doc.get('ad_id'),
        name: doc.get('ad_name'));
  }

  static Future<List<AdModel>> getAds({
    required String school
  }) async {

    // get the general ads
    QuerySnapshot generalAds =
        await adsRef.doc('General').collection('content').get();

    // get the school specific ads
    QuerySnapshot schoolSpecificAds = await adsRef
        .doc(school)
        .collection('content')
        .get();

    List<AdModel> adsList = [];

    for (var doc in generalAds.docs) {
      adsList.add(AdModel.fromDocument(doc));
    }

    for (var doc in schoolSpecificAds.docs) {
      adsList.add(AdModel.fromDocument(doc));
    }

    return adsList;
  }
}