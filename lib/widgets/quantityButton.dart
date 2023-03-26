import 'dart:developer';

import 'package:fairstores/constants.dart';
import 'package:fairstores/providers/cartInfoProvider.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityButton extends ConsumerStatefulWidget {
  final AutoDisposeStateProvider<int> quantityProvider;
  final bool inCart;
  final String? orderID;

  const QuantityButton({
    Key? key,
    required this.quantityProvider,
    this.inCart = false,
    this.orderID

  }) : super(key: key);

  @override
  ConsumerState<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends ConsumerState<QuantityButton> {
  @override
  Widget build(BuildContext context) {
    final _cartInfo = ref.watch(cartInfoProvider);
    final _count = ref.watch(widget.quantityProvider);

    if (widget.inCart){

      return cartQuantityButton();
    }


    return ElevatedButton(
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: (){
              if (_count > 1){
                ref.read(widget.quantityProvider.notifier).state = _count - 1;
              }
            },
            icon: Icon(
              Icons.remove,
              color: kBlack,
              size: 20,
            )
          ),
          CustomText(
            text: _count.toString(),
            color: kBlack,
            fontSize: 20,
          ),
          IconButton(
              onPressed: (){
                ref.read(widget.quantityProvider.notifier).state = _count + 1;
              },
              icon: Icon(
                Icons.add,
                color: kBlack,
                size: 20,
              )
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: kEnabledBorderColor
          ),
          borderRadius: BorderRadius.circular(40.0),
        ),
        fixedSize: Size.fromHeight(56),
      ),
    );
  }

  Widget cartQuantityButton(){
    final _cartList = ref.watch(cartInfoProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 16.5,
          backgroundColor: kGrey,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: kScaffoldColor,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: (){
                // decrease the quantity when this button is closed
                if (_cartList[widget.orderID]!.quantity > 0){

                  _cartList[widget.orderID]!.quantity
                  = _cartList[widget.orderID]!.quantity - 1;

                  // update the quantity of the current order
                  ref.read(widget.quantityProvider.notifier).state
                  = _cartList[widget.orderID]!.quantity - 1;

                  // update the cart items with the updated order
                  ref.read(cartInfoProvider.notifier).state = _cartList;

                  // refresh the subtotal
                  ref.invalidate(subTotalProvider);
                }
              },
              icon: Icon(
                Icons.remove,
                color: kGrey,
                size: 20,
              )
            ),
          ),
        ),
        SizedBox(width: 5,),
        CustomText(
          text: ref.read(widget.quantityProvider).toString(), // _cartList[widget.orderID]!.quantity.toString(),
          color: kBlack,
          fontSize: 20,
        ),
        SizedBox(width: 5,),
        CircleAvatar(
          radius: 16.5,
          backgroundColor: kPrimary,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: (){

              // increase the quantity when this button is closed
              _cartList[widget.orderID]!.quantity
              = _cartList[widget.orderID]!.quantity + 1;

              // update the quantity of the current order
              ref.read(widget.quantityProvider.notifier).state
              = _cartList[widget.orderID]!.quantity + 1;

              // update the cart items with the updated order
              ref.read(cartInfoProvider.notifier).state = _cartList;

              // refresh the subtotal
              ref.invalidate(subTotalProvider);

            },
            icon: Icon(
              Icons.add,
              color: kBlack,
              size: 20,
            )
          ),
        ),
      ],
    );
  }
}
