import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartListProvider = StateProvider<List<FoodOrdersModel>>((ref) => []);