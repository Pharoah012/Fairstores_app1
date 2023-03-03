import 'package:fairstores/constants.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/models/securityModel.dart';
import 'package:fairstores/whatsappchat.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryDetails extends StatefulWidget {
  final HistoryModel history;

  const HistoryDetails({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
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
    SecurityModel securityModel = await SecurityModel.getSecurityKeys();

    setState(() {
      taxes = securityModel.taxFee.toDouble();
      servicecharge = securityModel.serviceCharge;
    });
  }

  getdeliveryprice() async {
    JointModel food = await JointModel.getDeliveryPrice(
      school: widget.history.school,
      foodID: widget.history.joint!.jointID,
      userID: ""
    );

    setState(() {
      delivery = food.price.toDouble();
      deliverytime = food.deliveryTime;
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
            SizedBox(width: 5.0,),
            CustomText(
              text: widget.history.joint!.location,
              fontSize: 12,
              isMediumWeight: true,
            )
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: kPrimary,
          radius: 25,
          backgroundImage: NetworkImage(
            widget.history.joint!.headerImage
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Foodhome(
            //         joint: widget.history.joint
            //     )
            //   )
            // );
          },
          icon: const Icon(
            Icons.arrow_forward_ios
          )
        ),
        title: CustomText(
          text: widget.history.joint!.name,
          fontSize: 18,
          isBold: true
        )
      )
    );
  }

  orderdetails() {
    List<Row> receipt = [];
    for (var element in widget.history.orderDetails) {
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
      appBar: CustomAppBar(title: 'Order Details'),
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
                    child: Text('Order Cost: GHS ${widget.history.total}',
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
            child: Text('Order Status: ${widget.history.status}',
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
                Text(widget.history.deliveryLocation,
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
                Text('GHS ${servicecharge * widget.history.total}',
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
                Text('GHS ${widget.history.total}',
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
