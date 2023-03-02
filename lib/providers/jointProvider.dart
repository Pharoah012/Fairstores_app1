import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jointProvider = FutureProvider.family<List<JointModel>, Map<String, String>?>(
  (ref, jointFilter) async {

    if (jointFilter == null){
      return await JointModel.getJoints(
          school: ref.read(userProvider).school!,
          category: "All",
          userID: ref.read(userProvider).uid
      );
    }

    return await JointModel.getJoints(
        school: jointFilter['school']!,
        category: jointFilter['category']!,
        userID: ref.read(userProvider).uid
    );
  }
);

final bestSellersProvider = FutureProvider.family<List<JointModel>, Map<String, String>?>(
        (ref, jointFilter) async {

      if (jointFilter == null){
        return await JointModel.getBestSellers(
            school: ref.read(userProvider).school!,
            category: "All",
            userID: ref.read(userProvider).uid
        );
      }

      return await JointModel.getBestSellers(
          school: jointFilter['school']!,
          category: jointFilter['category']!,
          userID: ref.read(userProvider).uid
      );
    }
);