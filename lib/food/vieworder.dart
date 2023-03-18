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
  final bool inHistory;

  const ViewOrder({
    Key? key,
    required this.joint,
    required this.history,
    this.inHistory = false
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
            Builder(builder: (context){
              if (widget.history.orderDetails.isEmpty){
                return Center(
                  child: CustomText(
                      text: "There are no items in the cart"
                  ),
                );
              }

              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.history.orderDetails.length,
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
                                text: "${widget.history.orderDetails[index]['quantity']} "
                                    "x ${widget.history.orderDetails[index]['ordername']}",
                                fontSize: 16,
                                color: kBlack,
                              ),
                              CustomText(
                                text: "GHS ${widget.history.orderDetails[index]['total']}",
                                fontSize: 16,
                                color: kBlack,
                              )
                            ],
                          ),
                          Builder(
                              builder: (context){
                                List<dynamic> sides = widget.history.orderDetails[index]['sides'];

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
                                                      text: "${widget.history.orderDetails[index]['total'] - side.price}",
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

            }),
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
          orderDate: widget.history.orderTime,
          feedbackDate: widget.history.feedbackTime,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: kWhite,
        appBar: CustomAppBar(
          title: 'FairStores',
          color: kWhite,
          onBackTap: () async {
            try{

              if (widget.inHistory){
                Navigator.pop(context);
              }
              else{
                await FoodOrdersModel.clearCart(
                    userID: user.uid,
                    jointID: widget.joint.jointID
                );

                ref.refresh(cartProvider(widget.joint));
                ref.refresh(cartInfoProvider);

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
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
                SizedBox(height: 23,),
                receipt()
              ]
            ),
          ),
        )
    );
  }
}
