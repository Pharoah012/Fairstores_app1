import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventDetails.dart';
import 'package:fairstores/models/eventModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _favoriteProvider = StateProvider<bool>((ref) => false);

class CustomEventTile extends ConsumerStatefulWidget {
  final EventModel event;

  const CustomEventTile({
    Key? key,
    required this.event
  }) : super(key: key);

  @override
  ConsumerState<CustomEventTile> createState() => _CustomEventTileState();
}

class _CustomEventTileState extends ConsumerState<CustomEventTile> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(_favoriteProvider.notifier).state = widget.event.isFavorite;
    });

    super.initState();
  }

  eventModelImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          SizedBox(
            child: CachedNetworkImage(
              imageUrl: widget.event.eventheaderimage,
              height: 131,
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.cover,
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: kWhite.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 10
                    ),
                    child: CustomText(
                      text: '${widget.event.eventdate
                          .toDate()
                          .day} ${widget.event.eventmonth}',
                      color: kWhite,
                      isMediumWeight: true,
                      fontSize: 10,
                    )
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    try{

                      // update the favorite status of this item
                      bool updateFavorite = await widget.event.updateFavorites(
                          userID: ref.read(userProvider).uid,
                          school: ref.read(userProvider).school!
                      );

                      ref.read(_favoriteProvider.notifier).state = updateFavorite;
                    }
                    catch(exception){
                      log(exception.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "An error occurred while updating this favorite"
                              )
                          )
                      );
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xffFFFFFF).withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.bookmark,
                      size: 20,
                      color: widget.event.isFavorite
                        ? kPrimary
                        : kBlack,
                    )
                  ),
                ),
              ],
            ),
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return widget.event.lockevent
    ? SizedBox.shrink()
    : GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              EventDetails(
                event: widget.event,
              ),
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(18),
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              eventModelImage(),
              SizedBox(height: 14,),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: CustomText(
                  text: widget.event.eventname,
                  fontSize: 18,
                  isMediumWeight: true,
                )
              ),
              SizedBox(height: 14,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: kPrimary,
                            border:
                            Border.all(color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(100)
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border:
                            Border.all(color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(100)
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border:
                            Border.all(color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(100)
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(width: 5,),
                  CustomText(
                    text:  '${widget.event.attendeeNumber}+ going',
                    fontSize: 12,
                    color: kPurple,
                  )
                ],
              ),
              SizedBox(height: 14,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: kGrey,
                    size: 16,
                  ),
                  SizedBox(width: 7,),
                  CustomText(
                    text: widget.event.eventlocation,
                    fontSize: 13,
                    color: kGrey,
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}