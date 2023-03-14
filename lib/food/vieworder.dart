import 'dart:developer';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/models/menuItemOptionItemModel.dart';
import 'package:fairstores/providers/cartInfoProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customErrorWidget.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/orderStatusDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewOrder extends ConsumerStatefulWidget {
  final JointModel joint;
  final HistoryModel history;

  const ViewOrder({
    Key? key,
    required this.joint,
    required this.history
  }) : super(key: key);

  @override
  ConsumerState<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends ConsumerState<ViewOrder> {

  Widget receipt() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: "Receipts",
          isMediumWeight: true,
          color: kBlack,
        ),
        SizedBox(height: 10,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ref.read(cartProvider(widget.joint)).when(
                data: (data){
                  if (data.isEmpty){
                    return Center(
                      child: CustomText(
                          text: "There are no items in the cart"
                      ),
                    );
                  }

                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ref.read(cartInfoProvider).values.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "${ref.read(cartInfoProvider)
                                        .values.elementAt(index).quantity}} "
                                        "x ${ref.read(cartInfoProvider)
                                        .values.elementAt(index).foodName}",
                                    fontSize: 16,
                                    color: kBlack,
                                  ),
                                  CustomText(
                                    text: "GHS ${ref.read(cartInfoProvider)
                                        .values.elementAt(index).price}",
                                    fontSize: 16,
                                    color: kBlack,
                                  )
                                ],
                              ),
                              Builder(
                                  builder: (context){
                                    List<dynamic> sides = ref.read(cartInfoProvider).values.elementAt(index).sides;

                                    // check if the are sides and display them
                                    if (sides.isNotEmpty){
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: ListView.builder(
                                                itemCount: sides.length,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, sideIndex){
                                                  MenuItemOptionItemModel side
                                                  = MenuItemOptionItemModel.fromJson(sides[sideIndex]);

                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        CustomText(
                                                          text: "+ ${side.name}",
                                                          fontSize: 12,
                                                        ),
                                                        CustomText(
                                                          text: "${side.price}",
                                                          fontSize: 12,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    return SizedBox.shrink();
                                  }
                              )
                            ],
                          ),
                        );
                      }
                  );
                },
                error: (_, err){
                  log(err.toString());
                  return Center(
                    child: CustomText(
                        text: "An error occurred while retrieving your orders"
                    ),
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: kPrimary,
                  ),
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Delivery Fee",
                  fontSize: 16,
                  color: kBlack,
                ),
                CustomText(
                  text: "GHS ${widget.joint.price.toString()}",
                  fontSize: 16,
                  color: kBlack,
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Taxes",
                  fontSize: 16,
                  color: kBlack,
                ),
                CustomText(
                  text: "GHS ${widget.history.tax}",
                  fontSize: 16,
                  color: kBlack,
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Service Fee",
                  fontSize: 16,
                  color: kBlack,
                ),
                CustomText(
                  text: "GHS ${widget.history.serviceCharge}",
                  fontSize: 16,
                  color: kBlack,
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: "Total Price",
                    fontSize: 18,
                    color: kBlack,
                    isBold: true
                ),
                CustomText(
                  text: "GHS ${widget.history.total}",
                  fontSize: 18,
                  color: kBlack,
                  isBold: true,
                ),
              ],
            ),
            SizedBox(height: 20,),
          ],
        )
      ],
    );
  }

  Widget trackingOrder(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Tracking Order",
              color: kBlack,
              isMediumWeight: true,
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(
               Icons.keyboard_arrow_up,
               color: kBlack,
              )
            )
          ],
        ),
        SizedBox(height: 20,),
        OrderStatusDisplay(
          status: widget.history.status,
          orderDate: widget.history.timestamp,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final cartInfo = ref.watch(cartInfoProvider);
    final cart = ref.watch(cartProvider(widget.joint));

    return Scaffold(
      backgroundColor: kWhite,
        appBar: CustomAppBar(
          title: 'FairStores',
          color: kWhite,
          onBackTap: () async {
            try{
              await FoodOrdersModel.clearCart(
                  userID: user.uid,
                  jointID: widget.joint.jointID
              );

              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

            }
            catch(exception){
              log(exception.toString());
              showDialog(
                context: context,
                builder: (_) => CustomError(
                    errorMessage: "An error occurred during processing"
                )
              );
            }
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Order Details',
                  fontSize: 16,
                  isBold: true,
                  color: kBlack,
                ),
                SizedBox(height: 23,),
                CustomText(
                  text: 'You will receive a call once your '
                      'order has been delivered',
                  fontSize: 16,
                  isMediumWeight: true,
                  color: kPrimary,
                ),
                SizedBox(height: 23,),
                trackingOrder(),
                receipt()
              ]
            ),
          ),
        )
    );
  }
}
