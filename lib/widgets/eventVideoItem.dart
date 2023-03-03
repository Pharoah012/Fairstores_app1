import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/events/videoplayer.dart';
import 'package:fairstores/models/videoModel.dart';
import 'package:flutter/material.dart';


class EventVideoItem extends StatelessWidget {
  final VideoModel video;

  const EventVideoItem({
    Key? key,
    required this.video
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(
                videourl: video.videourl,
              ),
            )
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: video.thumbnail,
                width: MediaQuery.of(context).size.width,
                height: 170,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset('images/playcircle.png'),
            )
          ],
        ),
      )
    );
  }
}
