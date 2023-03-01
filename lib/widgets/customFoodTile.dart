import 'package:fairstores/models/foodModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomFoodTile extends StatelessWidget {
  final FoodModel food;

  const CustomFoodTile({
    Key? key,
    required this.food
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Center(
        child: CustomText(text: food.tilename),
      ),
    );
  }
}
