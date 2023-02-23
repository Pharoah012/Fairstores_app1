import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodcartmodel.dart';
import 'package:fairstores/homescreen/historyfooddetails.dart';
import 'package:fairstores/main.dart';
import 'package:fairstores/whatsappchat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewOrder extends StatefulWidget {
  final String userid;
  final String orderid;
  final dynamic total;
  final dynamic taxes;
  final dynamic servicecharge;
  final dynamic deliveryfee;
  const ViewOrder(
      {Key? key,
      required this.orderid,
      required this.deliveryfee,
      required this.userid,
      required this.total,
      required this.servicecharge,
      required this.taxes})
      : super(key: key);

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  List<String> orderdetails = [];

  receipt() {
    return FutureBuilder<QuerySnapshot>(
        future: foodCartRef
            .doc(widget.userid)
            .collection('Orders')
            .where('userid', isEqualTo: widget.userid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          List<Widget> foodcartlist = [];
          List<String> orderdetails = [];
          for (var doc in snapshot.data!.docs) {
            List<Padding> foodsidelist = [];
            FoodCartModel foodCartModel =
                FoodCartModel.fromDocument(doc, widget.userid);
            foodsidelist = foodCartModel.sides
                .map((e) => Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 15),
                      child: Text(
                        '+ $e.',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.4)),
                      ),
                    ))
                .toList();
            orderdetails.add(
                '${foodCartModel.quantity}x ${foodCartModel.foodname} + $foodsidelist');
            print(orderdetails);

            foodcartlist.add(Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 13, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${foodCartModel.quantity}x ${foodCartModel.foodname}',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        'GHS ${foodCartModel.price}',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: foodsidelist,
                  ),
                ],
              ),
            ));
          }

          this.orderdetails = orderdetails;
          print(orderdetails);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 23),
                child: Text('Delivery Address',
                    style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.5))),
              ),
              Column(
                children: foodcartlist,
              ),
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
                    Text('GHS ${widget.deliveryfee}',
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
                    Text('GHC ${widget.taxes}',
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
                    Expanded(child: SizedBox()),
                    Text('GHS ${widget.servicecharge * widget.total}',
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
                    Expanded(child: const SizedBox()),
                    Text(
                        'GHS ${widget.total + widget.taxes + (widget.total * widget.servicecharge)}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 22.0),
                child: Divider(
                  color: Colors.white,
                  height: 1.7,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: TextButton(
                    onPressed: () {
                      openwhatsapp(context);
                      //     //  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const PurchsaeSuccessful(),));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Text(
                        'Contact Customer Care',
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff374151)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'FairStores',
            style: GoogleFonts.manrope(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () async {
              QuerySnapshot snapshot = await foodCartRef
                  .doc(widget.userid)
                  .collection('Orders')
                  .get();
              for (var e in snapshot.docs) {
                e.reference.delete();
              }

              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 12,
                  ),
                ),
                Text(
                  'Back',
                  style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 23),
              child: Text('Order Details',
                  style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 23, bottom: 23, right: 20),
              child: Text(
                  'You will recieve a call once your order has been delivered',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                      fontSize: 16, fontWeight: FontWeight.w500, color: kPrimary)),
            ),
            receipt()
          ]),
        ));
  }
}
