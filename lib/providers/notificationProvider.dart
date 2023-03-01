import 'package:fairstores/models/notificationModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = FutureProvider<List<CustomNotificationModel>>(
  (ref) async {

  List<CustomNotificationModel> notifications = await CustomNotificationModel.getNotifications(
    userID: ref.read(userProvider).uid
  );

  return notifications;
});