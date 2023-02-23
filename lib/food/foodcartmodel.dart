import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodCartModel extends StatefulWidget {
  final String status;
  final String image;
  final int quantity;
  final String foodname;
  final String orderid;
  final dynamic price;
  final String shopid;
  final String user;
  final List sides;
  const FoodCartModel(
      {Key? key,
      required this.user,
      required this.sides,
      required this.shopid,
      required this.orderid,
      required this.price,
      required this.image,
      required this.foodname,
      required this.quantity,
      required this.status})
      : super(key: key);

  factory FoodCartModel.fromDocument(DocumentSnapshot doc, user) {
    return FoodCartModel(
      user: user,
      sides: doc.get('sides'),
      status: doc.get('status'),
      shopid: doc.get('shopid'),
      price: doc.get('total'),
      orderid: doc.get('orderid'),
      foodname: doc.get('ordername'),
      quantity: doc.get('quantity'),
      image: doc.get('image'),
    );
  }

  @override
  State<FoodCartModel> createState() => _FoodCartModelState();
}

class _FoodCartModelState extends State<FoodCartModel> {
  @override
  void initState() {
    super.initState();
    setState(() {
      count = widget.quantity;
    });
  }

  int count = 1;

  buttons() {
    return Padding(
        padding: const EdgeInsets.only(top: 17.0),
        child: Row(children: [
          Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              height: 56,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (count == 1) {
                                foodCartRef
                                    .doc(widget.user)
                                    .collection('Orders')
                                    .doc(widget.orderid)
                                    .delete();
                                foodCartRef
                                    .doc(widget.user)
                                    .collection('Orders')
                                    .doc(widget.orderid)
                                    .update({'quantity': count});
                              } else {
                                count -= 1;
                                foodCartRef
                                    .doc(widget.user)
                                    .collection('Orders')
                                    .doc(widget.orderid)
                                    .update({'quantity': count});
                              }
                            });
                          },
                          child: Container(
                            width: 21,
                            height: 21,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xffE7E4E4)),
                                borderRadius: BorderRadius.circular(100)),
                            child: const Icon(Icons.remove,
                                size: 10, color: Colors.black),
                          ),
                        ),
                      ),
                      Text(
                        '$count',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              count += 1;
                              foodCartRef
                                  .doc(widget.user)
                                  .collection('Orders')
                                  .doc(widget.orderid)
                                  .update({'quantity': count});
                            });
                          },
                          child: Container(
                            width: 21,
                            height: 21,
                            decoration: BoxDecoration(
                                color: kPrimary,
                                border:
                                    Border.all(color: const Color(0xffE7E4E4)),
                                borderRadius: BorderRadius.circular(100)),
                            child: const Icon(
                              Icons.add,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ]);
              }))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, right: 20),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 64,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(widget.image))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.foodname,
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        "GHC ${widget.price.toString()}",
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: const Color(0xff8B8380)),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: const SizedBox(),
              ),
              buttons()
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Divider(
            height: 2,
          ),
        )
      ],
    );
  }
}
