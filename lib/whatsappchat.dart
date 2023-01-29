
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';



openwhatsapp(context) async{
  var whatsapp ="+233209312735";
  var whatsappURlAndroid = "whatsapp://send?phone="+whatsapp+"&text=hello";
  var whatappURLIos ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  if(Platform.isIOS){
    // for iOS phone only
    if( await canLaunchUrlString(whatappURLIos)){
       await launchUrlString(whatappURLIos, );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content:  Text("whatsapp no installed")));

    }

  }else{
    // android , web
    if( await canLaunchUrlString(whatsappURlAndroid)){
      await launchUrlString(whatsappURlAndroid);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:  Text("whatsapp no installed")));

    }


  }

}