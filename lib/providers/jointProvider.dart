import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

final jointProvider = FutureProvider.autoDispose.family<List<JointModel>, Tuple2?>(
  (ref, jointFilter) async {

    if (jointFilter == null){
      return await JointModel.getJoints(
          school: ref.read(userProvider).school!,
          category: "All",
          userID: ref.read(userProvider).uid
      );
    }

    return await JointModel.getJoints(
        school: jointFilter.item1,
        category: jointFilter.item2,
        userID: ref.read(userProvider).uid
    );
  }
);

final bestSellersProvider = FutureProvider.autoDispose.family<List<JointModel>, Map<String, String>?>(
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