import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodDetails.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/jointMenuItemModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/models/sideMenuOptionModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/quantityButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final sideOptionsListProvider = StateProvider<List<SideMenuOptionModel>>(
  (ref) => []
);

final sideOptionProvider = FutureProvider.family<List<SideMenuOptionModel>, Tuple2>(
  (ref, menuItemInfo) async {
  List<SideMenuOptionModel> sides = await menuItemInfo.item1.getSideMenuOptions(
    jointID: menuItemInfo.item2.jointID,
    categoryID: menuItemInfo.item2.categoryID
  );

  ref.read(sideOptionsListProvider.notifier).state = sides;

  return sides;
});

final _quantityProvider = StateProvider<int>((ref) => 1);

class JointMenuItemTile extends ConsumerStatefulWidget {
  final JointMenuItemModel menuItem;
  final JointModel joint;

  const JointMenuItemTile({
    required this.menuItem,
    required this.joint
  });

  @override
  ConsumerState<JointMenuItemTile> createState() => _JointMenuItemTileState();
}

class _JointMenuItemTileState extends ConsumerState<JointMenuItemTile> {
  // int count = 1;
  // SideMenuCategoryOption sideoptions = const SideMenuCategoryOption();
  String orderID = const Uuid().v4();
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getoptions();
  // }
  //
  // cartavailabiltypopup(parentcontext) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: parentcontext,
  //       builder: (context) {
  //         return AlertDialog(
  //             title: Center(
  //                 child: Text(
  //                   'Cart',
  //                   style: GoogleFonts.montserrat(
  //                       color: kPrimary, fontWeight: FontWeight.bold),
  //                 )),
  //             actions: [
  //               Text(
  //                 'Your cart is currently being used by another joint. Do you want to clear it?',
  //                 textAlign: TextAlign.center,
  //               ),
  //               TextButton(
  //                 onPressed: () async {
  //                   QuerySnapshot snapshot = await foodCartRef
  //                       .doc(widget.userid)
  //                       .collection('Orders')
  //                       .get();
  //                   for (var e in snapshot.docs) {
  //                     e.reference.delete();
  //                   }
  //                   Navigator.pop(context);
  //                   Navigator.pop(context);
  //                 },
  //                 child: Center(
  //                     child: Text(
  //                       'Clear Cart',
  //                       style: TextStyle(color: kPrimary),
  //                     )),
  //               )
  //             ]);
  //       });
  // }

  // Check if the cart can be used,
  // meaning that it not occupied by another joint
  Future<bool> checkCartAvailability() async {
    return await FoodOrdersModel.isCartAvailable(
      userID: ref.read(userProvider).uid,
      jointID: widget.joint.jointID
    );
  }

  //
  // getoptions() async {
  //   DocumentSnapshot snapshot = await menuRef
  //       .doc(widget.shopid)
  //       .collection('categories')
  //       .doc(widget.categoryid)
  //       .collection('options')
  //       .doc(widget.id)
  //       .collection('sideoptions')
  //       .doc('01')
  //       .get();
  //
  //   if (!snapshot.exists) {
  //   } else {
  //     setState(() {
  //       sideoptions = SideMenuCategoryOption.fromDocument(snapshot);
  //     });
  //   }
  // }
  //

  // Add the given item to the user's cart
  Future<void> addToBag(FoodOrdersModel order) async {
    try{
      await order.placeOrder(
          userID: ref.read(userProvider).uid
      );

      ref.invalidate(cartProvider(widget.joint));

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Your item has been added to cart"
              )
          )
      );
    } catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unable to add to cart. Please try again later."
          )
        )
      );
    }
  }


  orderFood() async {

    // check if the menu item doesn't have sides
    if (widget.menuItem.hassides == false) {

      return showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context){
          return SizedBox(
            height: 436,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 21.0,
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: widget.menuItem.tileimage,
                              fit: BoxFit.cover,
                              // width: MediaQuery.of(context).size.width ,
                              height: 200,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: CircleAvatar(
                                radius: 10,
                                backgroundColor: kWhite,
                                child: const Icon(
                                  Icons.close_outlined,
                                  size: 15,
                                  color: kGrey,
                                ),
                              )
                            ),
                          ),
                        ]
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    CustomText(
                      text: widget.menuItem.name,
                      fontSize: 20,
                      isBold: true,
                      color: kBlack,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    widget.menuItem.description.isEmpty
                      ? SizedBox.shrink()
                      : CustomText(
                        text: widget.menuItem.description,
                        fontSize: 12,
                        color: kBlack,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: 'GHS ${widget.menuItem.price.toDouble().toString()}',
                      fontSize: 18,
                      isMediumWeight: true,
                      color: kBlack,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QuantityButton(
                          quantityProvider: _quantityProvider),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomButton(
                            isOrange: true,
                            onPressed: () async {

                              FoodOrdersModel foodOrder = FoodOrdersModel(
                                  cartID: "cart${ref.read(userProvider).uid}",
                                  sides: [],
                                  jointID: widget.joint.jointID,
                                  orderID: orderID,
                                  price: widget.menuItem.price * ref.read(_quantityProvider),
                                  image: widget.menuItem.tileimage,
                                  foodName: widget.menuItem.name,
                                  quantity:
                                  ref.read(_quantityProvider),
                                  status: "pending"
                              );

                              // check if the cart is available
                              bool isCartAvailable = await checkCartAvailability();

                              if (isCartAvailable) {

                                // add the order to the user's bag
                                await addToBag(foodOrder);
                                Navigator.pop(context);
                              }
                              else{

                              }


                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  text: 'Add to Bag',
                                  fontSize: 16,
                                  color: kWhite,
                                  isMediumWeight: true,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ]
              ),
            ),
          );
        }
      );
    }

    showDialog(context: context, builder: (context) => AlertDialog(
      title: CustomText(text: "text"),
    ));

    //
    // // show the side options of the item for the user to pick
    // return showBarModalBottomSheet(
    //   isDismissible: false,
    //   enableDrag: false,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //   context: context,
    //   builder: (context) => SizedBox(
    //     height: MediaQuery.of(context).size.height * 0.90,
    //     child: FoodOptions(
    //       userid: widget.userid,
    //       mealheader: widget.tileimage,
    //       mealdescription: widget.description,
    //       mealname: widget.name,
    //       mealid: widget.id,
    //       mealprice: widget.price,
    //       school: widget.school,
    //       jointID: widget.jointID,
    //       categoryid: widget.categoryid,
    //     )),
    // );

  }

  @override
  Widget build(BuildContext context) {
    Tuple2<JointMenuItemModel, JointModel> menuItemInfo = Tuple2(
      widget.menuItem,
      widget.joint
    );
    final quantity = ref.watch(_quantityProvider);

    // watch the sides
    final sides = ref.watch(sideOptionProvider(menuItemInfo));
    final sidesList = ref.watch(sideOptionsListProvider);

    //load the sides
    sides.when(
      data: (data) => log("loaded the sides"),
      error: (_, err) => log("Sides Error: ${err.toString()}"),
      loading: () => log("loading sides")
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          orderFood();
        },
        child: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.menuItem.tileimage,
                  fit: BoxFit.cover,
                  width: 76,
                  height: 76,
                ),
              ),
              SizedBox(width: 12,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: widget.menuItem.name,
                      fontSize: 14,
                      isMediumWeight: true,
                      color: kBlack,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomText(
                      text: widget.menuItem.description,
                      fontSize: 10,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomText(
                      text: "GHC ${widget.menuItem.price.toDouble()}",
                      isMediumWeight: true,
                      fontSize: 10,
                      color: kBlack,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}