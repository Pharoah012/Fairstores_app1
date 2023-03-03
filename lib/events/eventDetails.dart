import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/ticketpurchase.dart';
import 'package:fairstores/models/eventModel.dart';
import 'package:fairstores/models/videoModel.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/eventMediaItem.dart';
import 'package:fairstores/widgets/eventVideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videosProvider = FutureProvider.family<List<VideoModel>, EventModel>(
  (ref, event) async {
  return await event.getVideos();
});

class EventDetails extends ConsumerStatefulWidget {
  final EventModel event;

  const EventDetails({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  ConsumerState<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends ConsumerState<EventDetails> {

  eventBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('images/Calendar.png')
                ),
                borderRadius: BorderRadius.circular(12),
                color: kPrimary.withOpacity(0.1)
              ),
            ),
            title: CustomText(
              text: '${widget.event.eventdate.toDate().day} ${widget.event.eventmonth} ${widget.event.eventdate.toDate().year}',
              fontSize: 16,
              isMediumWeight: true,
              color: kBlack,
            ),
            subtitle: CustomText(
              text: '${widget.event.eventdateday}, '
                  '${widget.event.timebegin} - ${widget.event.timeend}',
              fontSize: 12,
              isMediumWeight: true,
              color: kBlack,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('images/Location.png')
                ),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffF25E37).withOpacity(0.1)
              ),
            ),
            title: CustomText(
              text: widget.event.eventlocation,
              fontSize: 16,
              isBold: true,
              color: kBlack,
            ),
            subtitle: CustomText(
              text: widget.event.eventgps,
              fontSize: 12,
              isMediumWeight: true,
              color: kBlack,
            )
          ),
        ],
      ),
    );
  }

  organizerInfo() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      horizontalTitleGap: 10,
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: kPrimary,
        backgroundImage: CachedNetworkImageProvider(
          widget.event.organizerimage
        ),
      ),
      title: CustomText(
        text: widget.event.organizername,
        isMediumWeight: true,
      ),
      subtitle: CustomText(
        text: 'Organizer',
        fontSize: 12,
      )
    );
  }

  eventHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              imageUrl: widget.event.eventheaderimage,
              height: 200,
              fit: BoxFit.cover,
            )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 15),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 63.0),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: kPrimary,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(100)
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 42.0),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(100)
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(100)),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(100)
                            ),
                          )
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: CustomText(
                        text: '${widget.event.attendeeNumber}+ going',
                        color: kBlue,
                      )
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  notAvailableButton() {
    return CustomButton(
      onPressed: (){},
      text: 'Tickets not Available',
      textColor: kPrimary,
    );
  }

  purchaseButton() {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketPurchase(
                eventpic: widget.event.eventheaderimage,
                eventname: widget.event.eventname,
                eticketavailable: widget.event.eticket,
                physicalticketavailable: widget.event.physicalticket,
                price: widget.event.eventprice,
                eventid: widget.event.eventid,
              ),
            )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.circular(100)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Purchase Ticket',
                  fontSize: 15,
                  isMediumWeight: true,
                  color: kWhite,
                ),
                CustomText(
                  text: 'GHS ${widget.event.eventprice}',
                  fontSize: 15,
                  isMediumWeight: true,
                  color: kWhite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(videosProvider(widget.event));

    return Scaffold(
      appBar: CustomAppBar(title: "Event Details",),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  eventHeader(),
                  SizedBox(height: 15,),
                  organizerInfo(),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: widget.event.eventname,
                          fontSize: 20,
                          isBold: true,
                          color: kBlack,
                        ),
                        SizedBox(height: 4,),
                        CustomText(
                          text: widget.event.eventdescription,
                          lineHeight: 1.5,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 28,),
                  eventBody(),
                  SizedBox(height: 28,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: CustomText(
                      text: "Media",
                      color: kBlack,
                    ),
                  ),
                  SizedBox(height: 10),
                  Builder(builder: (context){
                    if (widget.event.eventimages.isEmpty){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          height: 121,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: CustomText(
                            text: "This event has no media"
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 121,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.event.eventimages.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: EdgeInsets.only(left: index == 0 ? 20 : 0),
                            child: EventMediaItem(
                              image: widget.event.eventimages[index]
                            ),
                          );
                        }
                      ),
                    );
                  }),
                  SizedBox(height: 15),
                  videos.when(
                    data: (data){
                      if (data.isEmpty){
                        return SizedBox.shrink();
                      }

                      if (data.length == 1){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: EventVideoItem(
                            video: data.first
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: EdgeInsets.only(left: index == 0 ? 20 : 0),
                            child: EventVideoItem(
                              video: data[index],
                            ),
                          );
                        }
                      );
                    },
                    error: (_, err){
                      log(err.toString());
                      return SizedBox.shrink();
                    },
                    loading: () => Container(
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Center(
                        child: CustomText(
                          text: "Loading videos"
                        ),
                      ),
                    )
                  ),
                  SizedBox(height: 100,),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: widget.event.issellingtickets ? purchaseButton() : notAvailableButton(),
            )
          )
        ],
      ),
    );
  }
}