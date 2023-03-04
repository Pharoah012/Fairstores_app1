import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartInfoProvider = StateProvider<Map<String, FoodOrdersModel>>((ref) => {});

final subTotalProvider = StateProvider<double>((ref){
  double subTotal = 0;

  for (FoodOrdersModel order in ref.read(cartInfoProvider).values){
    subTotal += order.price * order.quantity;
  }

  // ref.read(subTotalProvider.notifier).state = subTotal;

  return subTotal;
});
