import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodcartmodel.dart';
import 'package:fairstores/food/foodcheckout.dart';
import 'package:fairstores/models/cartListProvider.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/securityKeysProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final currentTabProvider = StateProvider<String>((ref) => "delivery");
final subTotalProvider = StateProvider<double>((ref) => 0);

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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSubtotal();
    });
    super.initState();
  }
  // dynamic delivery = 0;
  // String deliverytime = '';
  // bool deliveryavailable = false;
  // bool pickupavailable = false;
  // double taxes = 0;
  // double servicecharge = 0;
  // @override
  // void initState() {
  //   super.initState();
  //   // getdeliveryprice();
  //   // getservicecharge();
  // }

  // getservicecharge() async {
  //   SecurityModel securityModel = await SecurityModel.getSecurityKeys();
  //   setState(() {
  //     taxes = securityModel.taxFee.toDouble();
  //     servicecharge = securityModel.serviceCharge;
  //   });
  // }

  // getdeliveryprice() async {
  //   DocumentSnapshot doc = await jointsRef
  //       .doc(widget.schoolname)
  //       .collection('Joints')
  //       .doc(widget.shopid)
  //       .get();
  //   FoodTile foodtile =
  //       FoodTile.fromDocument(doc, widget.user, widget.schoolname);
  //   print(foodtile.pickupavailable);
  //   setState(() {
  //     delivery = foodtile.tileprice.toDouble();
  //     deliverytime = foodtile.tiledistancetime;
  //     deliveryavailable = foodtile.deliveryavailable;
  //     pickupavailable = foodtile.pickupavailable;
  //   });
  // }

  // String page = 'Delivery';
  // // List<bool> visible = [true, false];
  // int count = 0;

  Widget setPage() {
    if (ref.read(currentTabProvider) == 'Delivery' && widget.joint.deliveryAvailable) {
      return getCartItems();

    } else if (ref.read(currentTabProvider) == 'Pickup' && widget.joint.pickupAvailable) {
      return getCartItems();
    }
    else{
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 4,),
          CustomText(
            text: '${ref.read(currentTabProvider)} Unavailable',
            color: kBlack,
          )
        ],
      );
    }
  }

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

  Widget getCartItems() {
    return SizedBox.shrink();
    // return StreamBuilder<QuerySnapshot>(
    //     stream: foodCartRef
    //         .doc(widget.user)
    //         .collection('Orders')
    //         .where('status', isEqualTo: 'pending')
    //         .snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return SizedBox();
    //       }
    //
    //       List<FoodCartModel> foodcartlist = [];
    //       for (var doc in snapshot.data!.docs) {
    //         foodcartlist.add(FoodCartModel.fromDocument(doc, ref.read(userProvider).uid));
    //       }
    //       return Column(
    //         children: foodcartlist,
    //       );
    //     }
    //     );
  }

  void getSubtotal(){
    double subTotal = 0;

    for (FoodOrdersModel order in ref.read(cartListProvider)){
      subTotal += order.price;
    }

    ref.read(subTotalProvider.notifier).state = subTotal;
  }

  @override
  Widget build(BuildContext context) {
    final _currentTab = ref.watch(currentTabProvider);
    final securityInfo = ref.watch(securityKeysProvider);
    final cartList = ref.watch(cartListProvider);
    final subTotal = ref.watch(subTotalProvider);

    return Scaffold(
        appBar: CustomAppBar(title: "Your Bag",),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    bagHeader(),
                    setPage()
                  ],
                ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // if (page == 'Delivery' &&
                              //     deliveryavailable == true) {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             FoodCheckout(
                              //               userid: widget.user,
                              //               shopid: widget.shopid,
                              //               deliveryfee: delivery,
                              //               taxes: taxes,
                              //               total: total,
                              //               school: widget.schoolname,
                              //               servicecharge: servicecharge,
                              //               deliverytime: deliverytime,
                              //             ),
                              //       ));
                              //   print('available');
                              // } else if (page == 'Pickup' &&
                              //     pickupavailable == true) {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             FoodCheckout(
                              //               userid: widget.user,
                              //               shopid: widget.shopid,
                              //               deliveryfee: delivery,
                              //               taxes: taxes,
                              //               total: total,
                              //               school: widget.schoolname,
                              //               servicecharge: servicecharge,
                              //               deliverytime: deliverytime,
                              //             ),
                              //       ));
                              //   print('pick available');
                              // } else {
                              //   ScaffoldMessenger.of(context)
                              //       .showSnackBar(const SnackBar(
                              //       content: Text(
                              //           'Select an available option')));
                              // }
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.ads_click_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                Text('Checkout',
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                          CustomText(
                            text: 'GHS ${
                              subTotal
                              + securityInfo.taxFee
                              + securityInfo.serviceCharge
                              + widget.joint.price.toDouble()
                            }',
                            fontSize: 16,
                            color: kWhite,
                          )
                        ],
                      )
                    ],
                  )
              ),
            )

            // StreamBuilder<QuerySnapshot>(
            //     stream: foodCartRef
            //         .doc(widget.user)
            //         .collection('Orders')
            //         .where('status', isEqualTo: 'pending')
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const SizedBox();
            //       }
            //
            //       List<FoodCartModel> foodcartlist = [];
            //       dynamic subtotal = 0;
            //       dynamic total = 0;
            //       for (var doc in snapshot.data!.docs) {
            //         FoodCartModel foodCartModel =
            //             FoodCartModel.fromDocument(doc, widget.user);
            //         subtotal = subtotal +
            //             (foodCartModel.price * foodCartModel.quantity);
            //         total = subtotal + delivery;
            //         foodcartlist
            //             .add(FoodCartModel.fromDocument(doc, widget.user));
            //       }
            //       return ;
            //     }
            //     )
          ],
        ));
  }
}
