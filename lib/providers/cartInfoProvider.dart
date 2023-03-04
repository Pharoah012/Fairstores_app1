import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartInfoProvider = StateProvider<Map<String, FoodOrdersModel>>((ref) => {});
final subTotalProvider = StateProvider<double>((ref) => 0);