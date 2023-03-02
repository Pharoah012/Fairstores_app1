import 'package:fairstores/models/eventHistoryModel.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeOrdersProvider = FutureProvider((ref) async {
  return await HistoryModel.activeOrders(
      userID: ref.read(userProvider).uid,
      school: ref.read(userProvider).school!
  );
});

final historyProvider = FutureProvider((ref) async {
  return await HistoryModel.history(
    userID: ref.read(userProvider).uid,
    school: ref.read(userProvider).school!
  );
});

final pendingEventTicketsProvider = FutureProvider((ref) async {
  return await EventHistoryModel.getPendingEventTickets(
      userID: ref.read(userProvider).uid
  );
});

final purchasedEventTicketsProvider = FutureProvider((ref) async {
  return await EventHistoryModel.getPurchasedEventTickets(
      userID: ref.read(userProvider).uid
  );
});