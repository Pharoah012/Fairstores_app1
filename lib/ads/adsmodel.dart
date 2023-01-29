
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class AdsModel extends StatelessWidget {
  final String content;
final String id;
final String name;


  const AdsModel({Key? key,  required this.content,  required this.id,  required this.name}) : super(key: key);

  factory AdsModel.fromDocument(DocumentSnapshot doc){
    return AdsModel(
      content: doc.get('ad_content'),
      id: doc.get('ad_id'),
      name: doc.get('ad_name'));
    
  }

  @override
  Widget build(BuildContext context) {
    adstile(){
      return
      Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        
      ),
      child: Container(
        alignment: Alignment.bottomLeft,

        height: 157,
        decoration: BoxDecoration(
            image:  DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  content
                )),
            borderRadius: BorderRadius.circular(10)),
      ));
    }
    return adstile();
  }
  
}