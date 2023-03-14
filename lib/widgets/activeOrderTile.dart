import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/mainScreens/historyDetails.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActiveOrderTile extends StatefulWidget {
  final HistoryModel history;

  const ActiveOrderTile({
    Key? key,
    required this.history
  }) : super(key: key);

  @override
  State<ActiveOrderTile> createState() => _ActiveOrderTileState();
}

class _ActiveOrderTileState extends State<ActiveOrderTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kLabelColor)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    widget.history.joint?.headerImage ?? "",
                  )
              ),
              borderRadius: BorderRadius.circular(12)),
          ),
          SizedBox(width: 15.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: widget.history.joint?.name ?? "",
                fontSize: 16,
                isBold: true,
              ),
              CustomText(
                text: timeago.format(widget.history.timestamp.toDate()),
                isMediumWeight: true,
                fontSize: 10,
              ),
              SizedBox(height: 4,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: CustomButton(
                      onPressed: (){},
                      text: "Track Order",
                      textColor: kPrimary,
                      textSize: 10,
                      height: 30,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    child: CustomButton(
                      textSize: 10,
                      height: 30,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryDetails(
                              history: widget.history,
                            ),
                          )
                        );
                      },
                      text: 'Order Details'
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
