import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/mainScreens/historyDetails.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryTile extends StatefulWidget {
  final HistoryModel history;

  const HistoryTile({
    Key? key,
    required this.history
  }) : super(key: key);

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryDetails(
              history: widget.history,
            ),
          )
        );
      },
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          widget.history.joint!.headerImage.toString(),
                        )),
                    borderRadius: BorderRadius.circular(12)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 11.0, top: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: widget.history.joint!.name,
                      fontSize: 16,
                      isBold: true,
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: timeago.format(
                            widget.history.orderTime.toDate()
                          ),
                          fontSize: 10,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const CircleAvatar(
                          radius: 1,
                          backgroundColor: Colors.black,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomText(
                          text: widget.history.status,
                          fontSize: 10,
                          isMediumWeight: true,
                          color: widget.history.status == 'Success'
                              ? const Color(0xff1F8B24)
                              : Colors.red,
                        )
                      ]
                    ),
                    SizedBox(height: 6.0,),
                    CustomText(
                      text: 'GHS ${widget.history.total}',
                      fontSize: 10,
                      color: kPrimary,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
