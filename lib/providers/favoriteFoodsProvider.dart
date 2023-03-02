import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteFoodsProvider = FutureProvider<List<JointModel>>((ref) async {
  UserModel user = ref.read(userProvider);

  return await JointModel.getFavoriteJoints(
      school: user.school!,
      userID: user.uid
  );
});