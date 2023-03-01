import 'package:cloud_firestore/cloud_firestore.dart';

final notificationsRef = FirebaseFirestore.instance.collection('Notifications');

class CustomNotificationModel{
  final String title;
  final String message;

  CustomNotificationModel({
    required this.title,
    required this.message
  });

  factory CustomNotificationModel.fromDocument(DocumentSnapshot doc) {
    return CustomNotificationModel(
      title: doc.get("title"),
      message: doc.get("message")
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": this.title,
      "message": this.message,
    };
  }

  static Future<void> clearNotifications({
    required String userID
  }) async {
    QuerySnapshot snapshot = await notificationsRef
        .doc(userID)
        .collection('Notifications')
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (var element in snapshot.docs) {
        element.reference.delete();
      }
    }
  }

  static Future<List<CustomNotificationModel>> getNotifications({
    required String userID
  }) async {
    QuerySnapshot snapshot = await notificationsRef
        .doc(userID)
        .collection('Notifications')
        .get();

    List<CustomNotificationModel> notifications = snapshot.docs.map(
            (e) => CustomNotificationModel.fromDocument(e)).toList();

    return notifications;
  }

}