import 'package:fairstores/models/foodModel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteFoodsProvider = FutureProvider<List<FoodModel>>((ref) async {
  UserModel user = ref.read(userProvider);

  return await FoodModel.getFavoriteFoods(
      school: user.school!,
      userID: user.uid
  );
});