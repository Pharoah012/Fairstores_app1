import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/models/adModel.dart';
import 'package:flutter/material.dart';

class AdTile extends StatelessWidget {
  final AdModel ad;

  const AdTile({
    Key? key,
    required this.ad
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      padding: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        image:  DecorationImage(
          fit: BoxFit.cover,
          image: Image.network(
            ad.content
          ).image
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      // child: Image.network(ad.content),
    );
  }
}
