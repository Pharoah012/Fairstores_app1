import 'package:cloud_firestore/cloud_firestore.dart';

final transactionsRef = FirebaseFirestore.instance.collection('ActiveOrders');

class VideoModel{
  final String videourl;
  final String thumbnail;
  final String videoid;

  const VideoModel({
    required this.videourl,
    required this.thumbnail,
    required this.videoid,
  });

  factory VideoModel.fromDocument(DocumentSnapshot doc) {
    return VideoModel(
      videourl: doc.get('videourl'),
      thumbnail: doc.get('thumbnail'),
      videoid: doc.get('videoid')
    );
  }
}