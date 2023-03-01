import 'package:fairstores/models/eventModel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteEventsProvider = FutureProvider<List<EventModel>>((ref) async {
  UserModel user = ref.read(userProvider);

  return await EventModel.getFavoriteEvents(
    school: user.school!,
    userID: user.uid
  );
});