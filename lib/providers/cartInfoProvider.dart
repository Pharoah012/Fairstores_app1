import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartInfoProvider = StateProvider<Map<String, FoodOrdersModel>>((ref) => {});

// this provider gets the user's cart at the given joint
final cartProvider = FutureProvider.family.autoDispose<Map<String, FoodOrdersModel>, JointModel>(
        (ref, joint) async {

      // get the cart items
      Map<String, FoodOrdersModel> orders = await FoodOrdersModel.getCart(
          jointID: joint.jointID,
          userID: ref.read(userProvider).uid
      );

      // load the orders into the cart list provider
      ref.read(cartInfoProvider.notifier).state = orders;

      return orders;
    }
);

final subTotalProvider = StateProvider<double>((ref){
  double subTotal = 0;

  for (FoodOrdersModel order in ref.read(cartInfoProvider).values){
    subTotal += order.price * order.quantity;
  }

  // ref.read(subTotalProvider.notifier).state = subTotal;

  return subTotal;
});
