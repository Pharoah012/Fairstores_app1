import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodhome.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/providers/securityKeysProvider.dart';
import 'package:fairstores/whatsappchat.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryDetails extends ConsumerStatefulWidget {
  final HistoryModel history;

  const HistoryDetails({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  ConsumerState<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends ConsumerState<HistoryDetails> {

  orderHeader() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Foodhome(
                joint: widget.history.joint!
              )
            )
          );
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final security = ref.watch(securityKeysGeneratorProvider);
    final securityDetails = ref.watch(securityKeysProvider);
    return Scaffold(
      appBar: CustomAppBar(title: 'Order Details'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orderHeader(),
            Container(
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kPrimary.withOpacity(0.1),
              ),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: CustomText(
                        text: 'Order Cost: GHS ${widget.history.total}',
                        fontSize: 12,
                        isMediumWeight: true,
                        color: kPrimary,
                      )
                    ),
                  ],
                ),
              ),
            ),
            CustomText(
              text: 'Order Status: ${widget.history.status}',
              fontSize: 12,
              color: kBlack,
              isBold: true,
            ),
            SizedBox(height: 23,),
            CustomText(
              text: 'Delivery Address',
              fontSize: 12,
              isBold: true,
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 17,
                  child: Icon(
                    Icons.location_on,
                    color: kDarkGrey,
                  ),
                ),
                SizedBox(width: 5,),
                CustomText(
                  text: widget.history.deliveryLocation,
                  fontSize: 12,
                  isBold: true,
                )
              ],
            ),
            SizedBox(height: 23,),
            CustomText(
              text: 'Order Details',
              fontSize: 16,
              color: kBlack,
              isBold: true,
            ),
            SizedBox(height: 16,),
            ...List.generate(
              widget.history.orderDetails.length,
              (index) => CustomText(
                text: widget.history.orderDetails[index].toString(),
                fontSize: 16,
                isMediumWeight: true,
                overflow: TextOverflow.visible,
              )
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Delivery',
                  fontSize: 16,
                ),
                CustomText(
                  text: 'GHS ${widget.history.joint!.price.toString()}',
                  fontSize: 16,
                ),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Taxes',
                  fontSize: 16,
                ),
                CustomText(
                  text: 'GHC ${securityDetails!.taxFee.toString()}',
                  fontSize: 16,
                ),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Service Fee",
                  fontSize: 16,
                  color: kBlack,
                ),
                CustomText(
                  text: 'GHS ${securityDetails.serviceCharge * widget.history.total}',
                  fontSize: 16,
                  color: kBlack,
                ),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Total Price',
                  fontSize: 18,
                  color: kBlack,
                  isBold: true,
                ),
                CustomText(
                  text: 'GHS ${widget.history.total}',
                  fontSize: 18,
                  color: kBlack,
                  isBold: true
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onPressed: () => openwhatsapp(context),
                  text: "Customer Care"
                ),
                SizedBox(width: 5,),
                CustomButton(
                  onPressed: (){},
                  text: "Order Again",
                  isOrange: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
