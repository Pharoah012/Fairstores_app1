import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodhome.dart';
import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/models/foodModel.dart';
import 'package:fairstores/models/securityModel.dart';
import 'package:fairstores/whatsappchat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryFoodDetail extends StatefulWidget {
  final FoodModel foodTile;
  final String user;
  final String deliverylocation;
  final String school;
  final dynamic ordertotal;
  final List orderdetails;
  final String status;

  const HistoryFoodDetail(
      {Key? key,
      required this.orderdetails,
      required this.deliverylocation,
      required this.status,
      required this.foodTile,
      required this.ordertotal,
      required this.school,
      required this.user})
      : super(key: key);

  @override
  State<HistoryFoodDetail> createState() => _HistoryFoodDetailState();
}

class _HistoryFoodDetailState extends State<HistoryFoodDetail> {
  dynamic delivery = 0;
  String deliverytime = '';
  double taxes = 0;
  double servicecharge = 0;

  @override
  void initState() {
    super.initState();

    getdeliveryprice();
    getservicecharge();
  }

  getservicecharge() async {
    DocumentSnapshot doc = await securityRef.doc('Security_keys').get();
    SecurityModel securityModel = SecurityModel.fromDocument(doc);
    setState(() {
      taxes = securityModel.taxFee.toDouble();
      servicecharge = securityModel.serviceCharge;
    });
  }

  getdeliveryprice() async {
    FoodModel food = await FoodModel.getDeliveryPrice(
      school: widget.school,
      foodID: widget.foodTile.tileid,
      userID: ""
    );

    setState(() {
      delivery = food.tileprice.toDouble();
      deliverytime = food.tiledistancetime;
    });
  }

  orderheader() {
    return Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 20),
        child: ListTile(
            subtitle: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    widget.foodTile.location,
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ],
            ),
            leading: CircleAvatar(
              backgroundColor: kPrimary,
              radius: 25,
              backgroundImage: NetworkImage(widget.foodTile.headerimage),
            ),
            trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => Foodhome(
                              deliverytime: widget.foodTile.tiledistancetime,
                              rating: widget.foodTile.rating,
                              jointid: widget.foodTile.tileid,
                              school: widget.school,
                              favourites: widget.foodTile.favourites,
                              user: widget.user,
                              logo: widget.foodTile.logo,
                              headerimage: widget.foodTile.headerimage,
                              jointname: widget.foodTile.tilename,
                              location: widget.foodTile.location))));
                },
                icon: const Icon(Icons.arrow_forward_ios)),
            title: Text(widget.foodTile.tilename,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ))));
  }

  orderdetails() {
    List<Row> receipt = [];
    for (var element in widget.orderdetails) {
      receipt.add(Row(
        children: [
          Flexible(
            child: Container(
                padding: const EdgeInsets.only(left: 20.0, right: 12),
                child: Text(
                  element,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.manrope(
                      fontSize: 16, fontWeight: FontWeight.w500),
                )),
          ),
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(children: receipt),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.black,
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Order Details',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orderheader(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kPrimary.withOpacity(0.1),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text('Order Cost: GHS ${widget.ordertotal}',
                        style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kPrimary)),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 8),
            child: Text('Order Status: ${widget.status}',
                style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 23),
            child: Text('Delivery Address',
                style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.5))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 12),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 17,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                ),
                Text(widget.deliverylocation,
                    style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.5))),
              ],
            ),
          ),
          Expanded(child: const SizedBox()),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 23),
            child: Text('Order Details',
                style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
          ),
          orderdetails(),
          Expanded(child: const SizedBox()),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: Row(
              children: [
                Text('Delivery',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )),
                Expanded(child: const SizedBox()),
                Text('GHS $delivery',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 16),
            child: Row(
              children: [
                Text('Taxes',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )),
                Expanded(child: const SizedBox()),
                Text('GHC $taxes',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 16),
            child: Row(
              children: [
                Text('Service Fee',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )),
                Expanded(child: const SizedBox()),
                Text('GHS ${servicecharge * widget.ordertotal}',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 16),
            child: Row(
              children: [
                Text('Total Price',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    )),
                Expanded(child: SizedBox()),
                Text('GHS ${widget.ordertotal}',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, bottom: 30, top: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE7E4E4)),
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(100)),
              child: TextButton(
                onPressed: () {
                  openwhatsapp(context);
                  //     //  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const PurchsaeSuccessful(),));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Text(
                    'Customer Care',
                    style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
