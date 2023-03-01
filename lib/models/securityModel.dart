import 'package:cloud_firestore/cloud_firestore.dart';

final securityRef = FirebaseFirestore.instance.collection('Security');

class SecurityModel {
  final String appVersion;
  final String aboutUs;
  final String deliveryDetails;
  final String vendorDetails;
  final dynamic serviceCharge;
  final int taxFee;
  final String eventsDetails;

  SecurityModel({
    required this.aboutUs,
    required this.taxFee,
    required this.serviceCharge,
    required this.appVersion,
    required this.deliveryDetails,
    required this.eventsDetails,
    required this.vendorDetails
  });

  factory SecurityModel.fromDocument(DocumentSnapshot doc) {
    return SecurityModel(
      serviceCharge: doc.get('Servicefee'),
      taxFee: doc.get('Taxfee'),
      aboutUs: doc.get('aboutus'),
      deliveryDetails: doc.get('deliverydetails'),
      eventsDetails:doc.get('eventsdetails'),
      vendorDetails: doc.get('vendordetails'),
      appVersion: doc.get('Appversion')
    );
  }

  static Future<SecurityModel> getSecurityKeys() async {
    return SecurityModel.fromDocument(
        await securityRef.doc('Security_keys').get()
    );
  }




}
