import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ----------- Text Colors ------------
const Color kPrimary = Color(0xffF25E37);
const Color kWhite = Colors.white;
const Color kBlack = Colors.black;
const Color kBrownText = Color(0xff180602);
const Color kDarkGrey = Color(0xff374151);
const Color kPurple = Color(0xff4B4EFC);
const Color kBlue = Color(0xff048EBF);
const Color kGrey = Color(0xff6B7280);
const Color kScaffoldColor = Color(0xFFE5E5E5);


// ----------- Button Colors ------------
const Color kLabelColor = Color(0xff8B8380);
const Color kEnabledBorderColor = Color(0xffE4DFDF);
const Color kDisabledBorderColor = Color(0xffD1D5DB);


// ------------- Firestore References ----------------
final schoolRef = FirebaseFirestore.instance.collection('Schools');
final tokensRef = FirebaseFirestore.instance.collection('UserTokens');
final menuRef = FirebaseFirestore.instance.collection('FoodMenu');
final sideOptions = FirebaseFirestore.instance.collection('FoodSideOptions');
final jointsRef = FirebaseFirestore.instance.collection('foodJoints');
final eventsContentRef = FirebaseFirestore.instance.collection('EventsContent');
final foodCartRef = FirebaseFirestore.instance.collection('FoodCart');