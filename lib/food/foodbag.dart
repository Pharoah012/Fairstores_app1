import 'dart:developer';

import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodCheckout.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/providers/cartInfoProvider.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/securityKeysProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/cartItem.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final currentTabProvider = StateProvider<String>((ref) => "Delivery");

class FoodBag extends ConsumerStatefulWidget {
  final JointModel joint;

  const FoodBag({
    Key? key,
    required this.joint,
  }) : super(key: key);

  @override
  ConsumerState<FoodBag> createState() => _FoodBagState();
}

class _FoodBagState extends ConsumerState<FoodBag> {

  bagHeader() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F9),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    ref.read(currentTabProvider.notifier).state = "Delivery";
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 8
                    ),
                    child: Container(
                      decoration: ref.read(currentTabProvider) == 'Delivery'
                       ? BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(40),
                      ) : null,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'Delivery',
                              fontSize: 12,
                              isBold: true,
                              color: ref.read(currentTabProvider) == 'Delivery'
                                ? kPrimary
                                : kBlack
                            ),
                            widget.joint.deliveryAvailable
                              ? const SizedBox.shrink()
                              : CustomText(
                              text: 'Not Available',
                              fontSize: 12,
                              color: ref.read(currentTabProvider) == 'Delivery'
                                ? kPrimary
                                : Colors.black
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(currentTabProvider.notifier).state = "Pickup";
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 8
                  ),
                  child: Container(
                    decoration: ref.read(currentTabProvider) == 'Pickup'
                      ? BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(40),
                    ) : null,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: 'Pick Up',
                            fontSize: 12,
                            isBold: true,
                            color: ref.read(currentTabProvider) == 'Pickup'
                                ? kPrimary
                                : Colors.black
                          ),
                          widget.joint.pickupAvailable
                            ? const SizedBox.shrink()
                            : CustomText(
                            text: 'Not Available',
                            fontSize: 12,
                            color: ref.read(currentTabProvider) == "Pickup"
                                ? kPrimary
                                : kBlack
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]
        )
    );
  }

  double totalAmount(){
    return ref.read(subTotalProvider)
      + ref.read(securityKeysProvider)!.taxFee
      + ref.read(securityKeysProvider)!.serviceCharge
      + widget.joint.price.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final _currentTab = ref.watch(currentTabProvider);
    final securityInfo = ref.watch(securityKeysProvider);
    final cartInfo = ref.watch(cartInfoProvider);
    final subTotal = ref.watch(subTotalProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: CustomAppBar(title: "Your Bag",),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                bagHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartInfo.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){

                      if (cartInfo.values.elementAt(index).quantity > 0){
                        final _quantityProvider = StateProvider.autoDispose<int>(
                                (ref) => cartInfo.values.elementAt(index).quantity
                        );

                        final quantity = ref.watch(_quantityProvider);
                        return Container(
                          decoration: BoxDecoration(
                              border: index != cartInfo.length -1
                                  ? Border(
                                  bottom:  BorderSide(
                                      color: kLabelColor
                                  )
                              ) : null
                          ),
                          child: CartItem(
                              order: cartInfo.values.elementAt(index),
                              quantityProvider: _quantityProvider
                          ),
                        );
                      }

                    }
                  )
                )
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.40,
            minChildSize: 0.1,
            maxChildSize: 0.40,
            builder: (BuildContext context, ScrollController scrollController) =>
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(21),
                      topRight: Radius.circular(21)
                  )
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    SizedBox(height: 14,),
                    Center(
                      child: Container(
                        color: Colors.white,
                        width: 40,
                        height: 4,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Subtotal",
                          fontSize: 18,
                          color: kWhite,
                          isBold: true,
                        ),
                        CustomText(
                          text: "GHS $subTotal",
                          fontSize: 18,
                          color: kWhite,
                          isBold: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Taxes",
                          fontSize: 16,
                          color: kWhite,
                        ),
                        CustomText(
                          text: "GHS ${securityInfo!.taxFee}",
                          fontSize: 16,
                          color: kWhite,
                        ),
                      ],
                    ),
                    SizedBox(height: 18,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Service Fee",
                          fontSize: 16,
                          color: kWhite,
                        ),
                        CustomText(
                          text: "GHS ${securityInfo.serviceCharge}",
                          fontSize: 16,
                          color: kWhite,
                        ),
                      ],
                    ),
                    SizedBox(height: 18,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Delivery",
                          fontSize: 16,
                          color: kWhite,
                        ),
                        CustomText(
                          text: 'GHS ${widget.joint.price.toDouble()}',
                          fontSize: 16,
                          color: kWhite,
                        ),
                      ],
                    ),
                    SizedBox(height: 22,),
                    Divider(
                      color: Colors.white,
                      height: 1.5,
                    ),
                    SizedBox(height: 16,),
                    CustomButton(
                      onPressed: (){

                        /// Checking if the cart is empty. If it is, it will return.
                        if (cartInfo.isEmpty){
                          return;
                        }

                        /// Checking if the current tab is Delivery and Delivery is
                        /// not available or if the current tab is Pickup and Pickup
                        /// is not available. If either of those conditions are
                        /// true, it will show a snackbar with the message that the
                        /// current tab is not available.
                        if (_currentTab == "Delivery" && !widget.joint.deliveryAvailable
                         || _currentTab == "Pickup" && !widget.joint.pickupAvailable){
                          ScaffoldMessenger.of(context)
                            .showSnackBar(
                              SnackBar(
                                content: Text(
                                    '$_currentTab is not available'
                                )
                              )
                          );

                          return;
                        }

                        try{
                          // update the cart
                          FoodOrdersModel.updateCart(
                              cartList: cartInfo.values.toList(),
                              userID: ref.read(userProvider).uid
                          ).then((value) {
                            log("cart updated");

                            // refresh the cart
                            ref.invalidate(cartProvider);

                            // redirect to checkout
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FoodCheckout(
                                          joint: widget.joint,
                                          taxes: double.parse(securityInfo.taxFee.toString()),
                                          total: totalAmount(),
                                          serviceCharge: securityInfo.serviceCharge
                                      ),
                                )
                            );

                          });
                        }
                        catch(exception){
                          log(exception.toString());
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'An error occurred while updating your cart'
                                  )
                              )
                          );

                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.ads_click_rounded,
                                  color: kPrimary,
                                ),
                              ),
                              Text('Checkout',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: kPrimary
                                )
                              ),
                            ],
                          ),
                          CustomText(
                            text: 'GHS ${totalAmount()}',
                            fontSize: 16,
                            color: kPrimary,
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),
          )
        ],
      )
    );
  }
}
