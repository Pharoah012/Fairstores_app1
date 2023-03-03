import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventMediaItem extends StatelessWidget {
  final String image;

  const EventMediaItem({
    Key? key,
    required this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          width: 121,
          height: 121,
        )
      ),
    );
  }
}
