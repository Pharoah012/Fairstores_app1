import 'package:fairstores/constants.dart';
import 'package:fairstores/models/jointMenuItemModel.dart';
import 'package:fairstores/models/optionModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class JointMenuItemTile extends StatefulWidget {
  final JointMenuItemModel menuOption;

  const JointMenuItemTile({
    required this.menuOption
  });

  @override
  State<JointMenuItemTile> createState() => _JointMenuItemTileState();
}

class _JointMenuItemTileState extends State<JointMenuItemTile> {
  // int count = 1;
  // SideMenuCategoryOption sideoptions = const SideMenuCategoryOption();
  // String orderid = const Uuid().v4();
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
  //
  // checkcartavailability() async {
  //   QuerySnapshot snapshot = await foodCartRef
  //       .doc(widget.userid)
  //       .collection('Orders')
  //       .where('shopid', isNotEqualTo: widget.shopid)
  //       .get();
  //   if (snapshot.docs.isNotEmpty) {
  //     cartavailabiltypopup(context);
  //     return false;
  //   } else {}
  //   return true;
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
  //   FoodCartModel.fromDocument(snapshot, widget.userid);
  //   if (foodCartModel.status == '') {
  //     snapshot.reference.delete();
  //     Navigator.pop(context);
  //   } else {
  //     Navigator.pop(context);
  //   }
  // }
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
  // orderfood() {
  //   if (widget.hassides == false) {
  //     checkcartavailability();
  //     foodCartRef.doc(widget.userid).collection('Orders').doc(orderid).set({
  //       'cartid': 'cart${widget.userid}',
  //       'orderid': orderid,
  //       'shopid': widget.shopid,
  //       'sides': [],
  //       'ordername': widget.name,
  //       'isrequired': false,
  //       'total': widget.price,
  //       'status': '',
  //       'instructions': '',
  //       'image': widget.tileimage,
  //       'quantity': 1,
  //       'userid': widget.userid
  //     });
  //     showMaterialModalBottomSheet(
  //       isDismissible: false,
  //       enableDrag: false,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       context: context,
  //       builder: (context) => SizedBox(
  //         height: 436,
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 20.0),
  //           child:
  //           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //             Padding(
  //               padding: const EdgeInsets.only(
  //                 top: 21.0,
  //               ),
  //               child: Stack(alignment: Alignment.topRight, children: [
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(20),
  //                   child: CachedNetworkImage(
  //                     imageUrl: widget.tileimage,
  //                     fit: BoxFit.cover,
  //                     width: MediaQuery.of(context).size.width * 0.9,
  //                     height: 200,
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(14.0),
  //                   child: IconButton(
  //                     onPressed: () {
  //                       closeorder();
  //                     },
  //                     icon: Container(
  //                       width: 20,
  //                       height: 20,
  //                       decoration: BoxDecoration(
  //                           border: Border.all(color: const Color(0xffE7E4E4)),
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(100)),
  //                       child: const Icon(
  //                         Icons.close_outlined,
  //                         size: 15,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ]),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 18.0),
  //               child: Text(
  //                 widget.name,
  //                 style: GoogleFonts.manrope(
  //                     fontWeight: FontWeight.w700, fontSize: 20),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 4.0),
  //               child: Text(
  //                 widget.description,
  //                 style: GoogleFonts.manrope(
  //                     fontWeight: FontWeight.w400,
  //                     fontSize: 12,
  //                     color: const Color(0xff8B8380)),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 10.0),
  //               child: Text(
  //                 'GHS ${widget.price}',
  //                 style: GoogleFonts.manrope(
  //                     fontWeight: FontWeight.w600, fontSize: 18),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 10.0),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                       decoration: const BoxDecoration(
  //                         color: Colors.white,
  //                       ),
  //                       width: MediaQuery.of(context).size.width * 0.4,
  //                       height: 56,
  //                       child: MaterialButton(
  //                           onPressed: null,
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(100),
  //                               side:
  //                               const BorderSide(color: Color(0xffE7E4E4))),
  //                           child: StreamBuilder<DocumentSnapshot>(
  //                               stream: foodCartRef
  //                                   .doc(widget.userid)
  //                                   .collection('Orders')
  //                                   .doc(orderid)
  //                                   .snapshots(),
  //                               builder: (context, snapshot) {
  //                                 if (!snapshot.hasData) {
  //                                   Row(
  //                                       mainAxisAlignment:
  //                                       MainAxisAlignment.center,
  //                                       children: [
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(
  //                                               right: 20.0),
  //                                           child: GestureDetector(
  //                                             onTap: () {},
  //                                             child: const Icon(Icons.remove,
  //                                                 size: 20,
  //                                                 color: Colors.black),
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           '1',
  //                                           style: GoogleFonts.manrope(
  //                                               fontWeight: FontWeight.w400,
  //                                               fontSize: 20,
  //                                               color: Colors.black),
  //                                         ),
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(
  //                                               left: 20.0),
  //                                           child: GestureDetector(
  //                                             onTap: () {},
  //                                             child: const Icon(
  //                                               Icons.add,
  //                                               size: 20,
  //                                               color: Colors.black,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ]);
  //                                 }
  //
  //                                 FoodCartModel foodCartModel =
  //                                 FoodCartModel.fromDocument(
  //                                     snapshot.data!, widget.userid);
  //                                 int count = foodCartModel.quantity;
  //
  //                                 return StatefulBuilder(builder:
  //                                     (BuildContext context,
  //                                     StateSetter setState) {
  //                                   return Row(
  //                                       mainAxisAlignment:
  //                                       MainAxisAlignment.center,
  //                                       children: [
  //                                         Padding(
  //                                           padding:
  //                                           const EdgeInsets.only(right: 0),
  //                                           child: IconButton(
  //                                             onPressed: () {
  //                                               setState(() {
  //                                                 if (count == 1) {
  //                                                 } else {
  //                                                   count -= 1;
  //                                                   foodCartRef
  //                                                       .doc(widget.userid)
  //                                                       .collection('Orders')
  //                                                       .doc(orderid)
  //                                                       .update({
  //                                                     'quantity': count
  //                                                   });
  //                                                 }
  //                                               });
  //                                             },
  //                                             icon: const Icon(Icons.remove,
  //                                                 size: 20,
  //                                                 color: Colors.black),
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           '$count',
  //                                           style: GoogleFonts.manrope(
  //                                               fontWeight: FontWeight.w400,
  //                                               fontSize: 20,
  //                                               color: Colors.black),
  //                                         ),
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(
  //                                               left: 0.0),
  //                                           child: IconButton(
  //                                             onPressed: () {
  //                                               count += 1;
  //                                               foodCartRef
  //                                                   .doc(widget.userid)
  //                                                   .collection('Orders')
  //                                                   .doc(orderid)
  //                                                   .update(
  //                                                   {'quantity': count});
  //                                             },
  //                                             icon: const Icon(
  //                                               Icons.add,
  //                                               size: 20,
  //                                               color: Colors.black,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ]);
  //                                 });
  //                               }))),
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                       left: 14.0,
  //                     ),
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                           color: kPrimary,
  //                           borderRadius: BorderRadius.circular(100)),
  //                       height: 56,
  //                       width: MediaQuery.of(context).size.width * 0.45,
  //                       child: MaterialButton(
  //                           onPressed: () {
  //                             foodCartRef
  //                                 .doc(widget.userid)
  //                                 .collection('Orders')
  //                                 .doc(orderid)
  //                                 .update({'status': 'pending'});
  //                             Navigator.pop(context);
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) => FoodBag(
  //                                     shopid: widget.shopid,
  //                                     user: widget.userid,
  //                                     schoolname: widget.school,
  //                                   ),
  //                                 ));
  //                           },
  //                           child: Center(
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   const Padding(
  //                                     padding: EdgeInsets.only(right: 6.0),
  //                                     child: Icon(
  //                                       Icons.shopping_bag,
  //                                       color: Colors.white,
  //                                       size: 15,
  //                                     ),
  //                                   ),
  //                                   Text(
  //                                     'Add to Bag',
  //                                     style: GoogleFonts.manrope(
  //                                         fontWeight: FontWeight.w600,
  //                                         fontSize: 12,
  //                                         color: Colors.white),
  //                                   ),
  //                                 ],
  //                               ))),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ]),
  //         ),
  //       ),
  //     );
  //   } else if (widget.hassides == true) {
  //     checkcartavailability();
  //
  //     showBarModalBottomSheet(
  //       isDismissible: false,
  //       enableDrag: false,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       context: context,
  //       builder: (context) => SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.90,
  //           child: FoodOptions(
  //             userid: widget.userid,
  //             mealheader: widget.tileimage,
  //             mealdescription: widget.description,
  //             mealname: widget.name,
  //             mealid: widget.id,
  //             mealprice: widget.price,
  //             school: widget.school,
  //             shopid: widget.shopid,
  //             categoryid: widget.categoryid,
  //           )),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          // orderfood();
        },
        child: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.menuOption.tileimage,
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
                      text: widget.menuOption.name,
                      fontSize: 14,
                      isMediumWeight: true,
                      color: kBlack,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomText(
                      text: widget.menuOption.description,
                      fontSize: 10,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomText(
                      text: "GHC ${widget.menuOption.price.toDouble()}",
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