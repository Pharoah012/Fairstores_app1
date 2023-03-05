import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodDetails.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/jointMenuItemModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/models/menuItemOptionItemModel.dart';
import 'package:fairstores/models/menuItemOptionModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:fairstores/widgets/menuItemOptionItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

final selectedSidesProvider = StateProvider<List<MenuItemOptionItemModel>>(
  (ref) => []);

final requiredCheckerProvider = StateProvider<Map<String, StateProvider<int>>>((ref) => {});

final menuItemOptionItemsProvider = FutureProvider.family<List<MenuItemOptionItemModel>, Tuple3>(
  (ref, menuItemInfo) async {

  List<MenuItemOptionItemModel> sidesList = await menuItemInfo.item1.getMenuItemOptionList(
    jointID: menuItemInfo.item2.jointID,
    categoryID: menuItemInfo.item2.categoryID,
    menuItemOptionID: menuItemInfo.item3
  );

  return sidesList;
});


class FoodOptions extends ConsumerStatefulWidget {
  final JointMenuItemModel menuItem;
  final JointModel joint;
  final StateProvider<List<MenuItemOptionModel>> menuItemOptionsList;
  final FutureProviderFamily menuOptions;

  const FoodOptions({
    required this.joint,
    required this.menuItem,
    required this.menuOptions,
    required this.menuItemOptionsList
  });

  @override
  ConsumerState<FoodOptions> createState() => _FoodOptionsState();
}

class _FoodOptionsState extends ConsumerState<FoodOptions> {
  // bool isrequired = false;
  // bool selected = false;

  String orderID = const Uuid().v4();
  TextEditingController instructionController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   openorder();
  // }
  //
  // openorder() {
  //   //open order to be prepared
  //   foodCartRef.doc(widget.userid).collection('Orders').doc(orderid).set({
  //     'cartid': 'cart${widget.userid}',
  //     'orderid': orderid,
  //     'shopid': widget.shopid,
  //     'sides': [],
  //     'ordername': widget.mealname,
  //     'isrequired': false,
  //     'total': widget.mealprice,
  //     'status': '',
  //     'instructions': '',
  //     'image': widget.mealheader,
  //     'quantity': 1,
  //     'userid': widget.userid
  //   });
  // }
  //
  // closeorder() async {
  //   //open order to be prepared
  //   DocumentSnapshot snapshot = await foodCartRef
  //       .doc(widget.userid)
  //       .collection('Orders')
  //       .doc(orderid)
  //       .get();
  //   FoodCartModel foodCartModel =
  //       FoodCartModel.fromDocument(snapshot, widget.userid);
  //   if (foodCartModel.status == '') {
  //     snapshot.reference.delete();
  //   } else {}
  // }

  Widget optionsHeader() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                widget.menuItem.tileimage,
              )
            )
          ),
          width: MediaQuery.of(context).size.width,
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // closeorder();
            },
            icon: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                // border: Border.all(color: const Color(0xffE7E4E4)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(100)),
              child: const Icon(
                Icons.close,
                size: 15,
                color: kDarkGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget menuItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: widget.menuItem.name,
          isBold: true,
          fontSize: 20,
          color: kBlack,
        ),
        SizedBox(height: 4,),
        CustomText(
          text: "GHS ${widget.menuItem.price.toDouble()}",
          fontSize: 12,
          color: kBlack,
          isMediumWeight: true,
        ),
        SizedBox(height: 8,),
        CustomText(
          text: widget.menuItem.description,
          fontSize: 10,
        )
      ],
    );
  }

  // sideOptionHeader() {
  //   // print(widget.shopid);
  //   // print(widget.categoryid);
  //   // print(widget.mealid);
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: menuRef
  //           .doc(widget.shopid)
  //           .collection('categories')
  //           .doc(widget.categoryid)
  //           .collection('options')
  //           .doc(widget.mealid)
  //           .collection('sideoptions')
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return const SizedBox();
  //         }
  //         List<Column> optionslist = [];
  //         List maxitems = [];
  //
  //         for (var doc in snapshot.data!.docs) {
  //           SideMenuOption jointmenucategory = SideMenuOption.fromDocument(doc);
  //
  //           maxitems.add(jointmenucategory.maxitems);
  //
  //           optionslist.add(Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 20.0),
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: 50,
  //                   color: const Color(0xffF7F7F9),
  //                   child: Center(
  //                       child: Row(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 20.0),
  //                         child: Text(
  //                           jointmenucategory.name,
  //                           style: GoogleFonts.manrope(
  //                               fontWeight: FontWeight.w600, fontSize: 14),
  //                         ),
  //                       ),
  //                       Expanded(child: SizedBox()),
  //                       jointmenucategory.isrequired == true
  //                           ? Padding(
  //                               padding: const EdgeInsets.only(right: 20.0),
  //                               child: Container(
  //                                 child: Center(
  //                                   child: Text(
  //                                     'Required',
  //                                     style: GoogleFonts.manrope(
  //                                         fontSize: 8,
  //                                         fontWeight: FontWeight.w600),
  //                                   ),
  //                                 ),
  //                                 width: 63,
  //                                 height: 27,
  //                                 decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(100),
  //                                     color: const Color(0xff8B8380)
  //                                         .withOpacity(0.1)),
  //                               ),
  //                             )
  //                           : const SizedBox()
  //                     ],
  //                   )),
  //                 ),
  //               ),
  //               StreamBuilder<QuerySnapshot>(
  //                   stream: menuRef
  //                       .doc(widget.shopid)
  //                       .collection('categories')
  //                       .doc(widget.categoryid)
  //                       .collection('options')
  //                       .doc(widget.mealid)
  //                       .collection('sideoptions')
  //                       .doc(jointmenucategory.id)
  //                       .collection('items')
  //                       .snapshots(),
  //                   // stream: sideoptions.doc(widget.shopid).collection('SideMenuOption').doc(widget.).snapshots(),
  //                   builder: ((context, snapshot) {
  //                     if (!snapshot.hasData) {
  //                       return const SizedBox();
  //                     }
  //
  //                     List<Widget> sideMenuOptionlist = [];
  //                     for (var doc in snapshot.data!.docs) {
  //                       sideMenuOptionlist.add(SideOption.fromDocument(
  //                           doc,
  //                           widget.shopid,
  //                           orderid,
  //                           widget.userid,
  //                           jointmenucategory.isrequired,
  //                           jointmenucategory.index,
  //                           widget.mealprice));
  //                     }
  //                     return Column(
  //                       children: sideMenuOptionlist,
  //                     );
  //                   }))
  //             ],
  //           ));
  //         }
  //
  //         foodCartRef
  //             .doc(widget.userid)
  //             .collection('Orders')
  //             .doc(orderid)
  //             .update({'maxitems': maxitems});
  //
  //         return Column(
  //           children: optionslist,
  //         );
  //       });
  // }


  
  // check if options have been selected in required fields
  bool areAllRequiredFieldsFilled(){
    bool result = true;
    
    // iterate though the required fields to check if an option has been selected
    for (StateProvider<int> numberOfSelectedFields in ref.read(requiredCheckerProvider).values){
      if (ref.read(numberOfSelectedFields) < 1){
        result = false;
      }
    }
    
    return result;
  }

  Widget menuItemOptionItems(List<MenuItemOptionModel> options){

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (context, index){
        
        // initialize the info needed to get the menu item option items
        Tuple3<JointMenuItemModel, JointModel, String> menuItemOptionItemInfo = Tuple3(
          widget.menuItem,
          widget.joint,
          options[index].id
        );

        final _menuItemOptionItemProvider = ref.watch(menuItemOptionItemsProvider(menuItemOptionItemInfo));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: options[index].name,
                    isMediumWeight: true,
                    color: kBrownText,
                  ),
                  options[index].isrequired
                    ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: kLabelColor.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: CustomText(
                        text: "Required",
                        fontSize: 8,
                        color: kBlack,
                      ),
                    ),
                  )
                    : SizedBox.shrink()
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: kWhite,
              child: _menuItemOptionItemProvider.when(
                data: (data){

                  if (data.isEmpty){
                    Center(
                        child: CustomText(
                            text: "There are no options"
                        )
                    );
                  }

                  // track the number of selected options
                  final selectedOptionsCountProvider = StateProvider<int>(
                          (ref) => 0
                  );

                  // check if the option is required and create a field for it in the required
                  // field checker provider
                  if (options[index].isrequired){
                    ref.read(requiredCheckerProvider.notifier)
                      .state[options[index].id] = selectedOptionsCountProvider;
                  }

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, itemIndex){

                      return MenuItemOptionItem(
                        menuItemOptionItem: data[itemIndex],
                        selectedOptionsCountProvider: selectedOptionsCountProvider,
                        selectedSidesProvider: selectedSidesProvider,
                        menuItemMaxSidesNumber: options[index].maxitems
                      );
                    }
                  );
                },
                error: (_, err){
                  log(err.toString());
                  return Container(
                    height: 200,
                    color: kWhite,
                    child: Center(
                      child: CustomText(
                        text: "An error occurred while fetching the options"
                      )
                    ),
                  );
                },
                loading: () => Container(
                  height: 200,
                  color: kWhite,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kPrimary,
                    ),
                  ),
                )
              ),
            )
          ],
        );
      }
    );
  }

  Widget optionsFooter() {
    return SafeArea(
      bottom: false,
      child: Container(
        color: kWhite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "Instructions",
                fontSize: 16,
                color: kBlack,
                isMediumWeight: true,
              ),
              CustomText(
                text: 'Let us know if you have specific things in mind',
              ),
              SizedBox(height: 15,),
              CustomTextFormField(
                labelText: 'Leave a note for the kitchen',
                controller: instructionController,
                isRequired: false,
              ),
              SizedBox(height: 18,),
              CustomButton(
                onPressed: () async {

                  // check if all the required option are selected
                  if (!areAllRequiredFieldsFilled()){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select all required options')
                      )
                    );
                  }

                  // Create the order model
                  FoodOrdersModel order = FoodOrdersModel(
                    sides: ref.read(selectedSidesProvider).map(
                      (object) => object.toJson()
                    ).toList(),
                    jointID: widget.joint.jointID,
                    orderID: orderID,
                    price: widget.menuItem.price,
                    image: widget.menuItem.tileimage,
                    foodName: widget.menuItem.name,
                    quantity: 1,
                    status: "pending",
                    cartID: "cart${ref.read(userProvider).uid}"
                  );

                  // add the order to the cart
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

                    // remove the drawer
                    Navigator.of(context).pop();
                  } catch (exception) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Unable to add to cart. Please try again later."
                            )
                        )
                    );
                  }
                },
                isOrange: true,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Tuple3<
        JointMenuItemModel,
        JointModel,
        StateProvider<List<MenuItemOptionModel>>
    > menuItemInfo = Tuple3(
        widget.menuItem,
        widget.joint,
        widget.menuItemOptionsList
    );

    // watch the sides
    final sides = ref.watch(widget.menuOptions(menuItemInfo));
    final sidesList = ref.watch(widget.menuItemOptionsList);
    
    // watch the required fields
    final _requiredFieldChecker = ref.watch(requiredCheckerProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: kWhite,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                        bottom: 20
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 23,),
                          optionsHeader(),
                          SizedBox(height: 12,),
                          menuItemDetails()
                        ],
                      ),
                    ),
                  ),
                  menuItemOptionItems(sidesList),
                ]
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: optionsFooter()
          )
        ],
      ),
    );
  }
}

//
// class SideOption extends StatefulWidget {
//   final String id;
//   final String name;
//   final int mealprice;
//   final int price;
//   final String shopid;
//   final bool isrequired;
//   final String orderid;
//   final String userid;
//   final int indexmaxitems;
//
//   const SideOption(
//       {required this.id,
//       required this.shopid,
//       required this.orderid,
//       required this.indexmaxitems,
//       required this.userid,
//       required this.price,
//       required this.mealprice,
//       required this.isrequired,
//       required this.name});
//
//   factory SideOption.fromDocument(DocumentSnapshot doc, shopid, orderid, userid,
//       isrequired, indexmaxitems, mealprice) {
//     return SideOption(
//         mealprice: mealprice,
//         shopid: shopid,
//         orderid: orderid,
//         isrequired: isrequired,
//         userid: userid,
//         indexmaxitems: indexmaxitems,
//         price: doc.get('price'),
//         id: doc.get('id'),
//         name: doc.get('name'));
//   }
//
//   @override
//   State<SideOption> createState() => _SideOptionState();
// }
//
// class _SideOptionState extends State<SideOption> {
//   bool selected = false;
//   int indexmaxitems = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       indexmaxitems = widget.indexmaxitems;
//     });
//
//     // getsideslist();
//   }
//
//   checkisrequiredsatisfied(istrue) {
//     if (widget.isrequired == true) {
//       foodCartRef
//           .doc(widget.userid)
//           .collection('Orders')
//           .doc(widget.orderid)
//           .update({'isrequired': istrue});
//     } else {}
//   }
//
//   getsideamount(amount) {
//     double totalprice = 0;
//     totalprice = widget.price.toDouble() - amount;
//
//     return totalprice;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//         stream: foodCartRef
//             .doc(widget.userid)
//             .collection('Orders')
//             .doc(widget.orderid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const SizedBox();
//           }
//           List sidesselection = [];
//           List maxitems = [];
//           bool isrequired = false;
//           dynamic total = 0;
//
//           SideslistModel sideslistModel =
//               SideslistModel.fromDocument(snapshot.data!);
//           sidesselection = sideslistModel.sides;
//           maxitems = sideslistModel.maxitems;
//           isrequired = sideslistModel.isrequired;
//           total = sideslistModel.total;
//
//           firebaseprocesses() {
//             if (selected == true) {
//               setState(() {
//                 selected = !selected;
//               });
//               total = total - getsideamount(widget.mealprice);
//               sidesselection.remove(widget.name);
//               maxitems[indexmaxitems] = maxitems[indexmaxitems] + 1;
//               checkisrequiredsatisfied(false);
//               foodCartRef
//                   .doc(widget.userid)
//                   .collection('Orders')
//                   .doc(widget.orderid)
//                   .update({'sides': sidesselection});
//               foodCartRef
//                   .doc(widget.userid)
//                   .collection('Orders')
//                   .doc(widget.orderid)
//                   .update({'maxitems': maxitems});
//               foodCartRef
//                   .doc(widget.userid)
//                   .collection('Orders')
//                   .doc(widget.orderid)
//                   .update({'total': total});
//             } else if (selected == false) {
//               if (maxitems[indexmaxitems] == 0) {
//               } else {
//                 setState(() {
//                   selected = !selected;
//                 });
//                 total = total + getsideamount(widget.mealprice);
//                 sidesselection.add(widget.name);
//                 checkisrequiredsatisfied(true);
//                 maxitems[indexmaxitems] = maxitems[indexmaxitems] - 1;
//
//                 foodCartRef
//                     .doc(widget.userid)
//                     .collection('Orders')
//                     .doc(widget.orderid)
//                     .update({'sides': sidesselection});
//                 foodCartRef
//                     .doc(widget.userid)
//                     .collection('Orders')
//                     .doc(widget.orderid)
//                     .update({'maxitems': maxitems});
//                 foodCartRef
//                     .doc(widget.userid)
//                     .collection('Orders')
//                     .doc(widget.orderid)
//                     .update({'total': total});
//               }
//             } else {}
//           }
//
//           return ListTile(
//             onTap: firebaseprocesses,
//             trailing: SizedBox(
//               width: 100,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     '+GHC ${getsideamount(widget.mealprice)}',
//                     style: GoogleFonts.montserrat(
//                         fontSize: 10, fontWeight: FontWeight.w500),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 9.0),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(40)),
//                           width: 20,
//                           height: 20,
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: selected == true
//                                       ? Colors.grey
//                                       : Colors.white),
//                               color: selected == true
//                                   ? Colors.green
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(40)),
//                           width: 15,
//                           height: 15,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             title: Text(
//               widget.name,
//               style: GoogleFonts.manrope(
//                   fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//           );
//         });
//   }
// }

// class SideslistModel {
//   final List sides;
//   final bool isrequired;
//   final List maxitems;
//   final dynamic total;
//   final String status;
//
//   SideslistModel(
//       {required this.sides,
//       required this.status,
//       required this.total,
//       required this.maxitems,
//       required this.isrequired});
//
//   factory SideslistModel.fromDocument(DocumentSnapshot doc) {
//     return SideslistModel(
//         maxitems: doc.get('maxitems'),
//         status: doc.get('status'),
//         sides: doc.get('sides'),
//         total: doc.get('total'),
//         isrequired: doc.get('isrequired'));
//   }
// }
