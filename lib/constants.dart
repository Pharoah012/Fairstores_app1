import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ----------- Text Colors ------------
const Color kPrimary = Color(0xffF25E37);
const Color kWhite = Colors.white;
const Color kBlack = Colors.black;
const Color kBrownText = Color(0xff180602);
const Color kDarkGrey = Color(0xff374151);


// ----------- Button Colors ------------
const Color kLabelColor = Color(0xff8B8380);
const Color kEnabledBorderColor = Color(0xffE4DFDF);
const Color kDisabledBorderColor = Color(0xffD1D5DB);


// ------------- Firestore References ----------------
DateTime timestamp = DateTime.now();
final userRef = FirebaseFirestore.instance.collection('Users');
final schoolRef = FirebaseFirestore.instance.collection('Schools');
final notificationsRef = FirebaseFirestore.instance.collection('Notifications');
final tokensRef = FirebaseFirestore.instance.collection('UserTokens');
final securityRef = FirebaseFirestore.instance.collection('Security');
final menuRef = FirebaseFirestore.instance.collection('FoodMenu');
final sideOptions = FirebaseFirestore.instance.collection('FoodSideOptions');
final adsRef = FirebaseFirestore.instance.collection('Ads');
final jointsRef = FirebaseFirestore.instance.collection('foodJoints');
final eventsRef = FirebaseFirestore.instance.collection('EventsPrograms');
final eventsContentRef = FirebaseFirestore.instance.collection('EventsContent');
final foodCartRef = FirebaseFirestore.instance.collection('FoodCart');
final transactionsRef = FirebaseFirestore.instance.collection('ActiveOrders');
final categoryRef = FirebaseFirestore.instance.collection('Categories');
final eventhistoryRef = FirebaseFirestore.instance.collection('Eventshistory');
final historyRef = FirebaseFirestore.instance.collection('History');
final eventTicketsPurchaseRef = FirebaseFirestore.instance.collection('EventsTicketPurchases');