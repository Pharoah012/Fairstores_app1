import 'package:cloud_firestore/cloud_firestore.dart';

class SecurityModel {
  final String appversion;
  final String aboutus;
  final String deliverydetails;
  final String vendordetails;
  final dynamic servicecharge;
  final int taxfee;
  final String eventsdetails;

  SecurityModel({required this.aboutus, required this.taxfee, required this.servicecharge,
   required this.appversion, required this.deliverydetails, required this.eventsdetails, required this.vendordetails});

  factory SecurityModel.fromDocument(DocumentSnapshot doc) {
    return SecurityModel(
      servicecharge: doc.get('Servicefee'),
      taxfee: doc.get('Taxfee'),
      aboutus: doc.get('aboutus'),
      deliverydetails: doc.get('deliverydetails'),
      eventsdetails:doc.get('eventsdetails'),
      vendordetails: doc.get('vendordetails'),
   appversion: doc.get('Appversion')
   
    );
  }
}
