import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/quantityButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem extends ConsumerWidget {
  final FoodOrdersModel order;
  final AutoDisposeStateProvider<int> quantityProvider;

  const CartItem({
    Key? key,
    required this.order,
    required this.quantityProvider
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: order.image,
                  fit: BoxFit.cover,
                  // width: MediaQuery.of(context).size.width ,
                  height: 64,
                  width: 72,
                ),
              ),
              SizedBox(width: 12,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 150,
                    child: CustomText(
                      text: order.foodName,
                      fontSize: 14,
                      color: kBlack,
                      isMediumWeight: true,
                    ),
                  ),
                  SizedBox(height: 6,),
                  CustomText(
                    text: "GHS ${order.price}",
                    fontSize: 12,
                    color: kBlack,
                    isMediumWeight: true,
                  )
                ],
              )
            ],
          ),
          QuantityButton(
            inCart: true,
            orderID: order.orderID,
            quantityProvider: quantityProvider,
          )
        ],
      ),
    );
  }
}
