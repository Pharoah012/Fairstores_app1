import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/ticketpurchase.dart';
import 'package:fairstores/events/videoplayer.dart';
import 'package:fairstores/models/eventModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetails extends StatefulWidget {
  final EventModel event;

  const EventDetails({
    Key? key,
    required this.event
  }) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<VideoModel> videolist = [];
  int eventgoers = 0;

  @override
  void initState() {
    super.initState();
    getvideos();
    // geteventgoers();
  }

  // geteventgoers() async {
  //   QuerySnapshot snapshot = await eventTicketsPurchaseRef
  //       .doc(widget.event.eventid)
  //       .collection('Purchases')
  //       .where('status', isEqualTo: 'Active')
  //       .get();
  //   for (var element in snapshot.docs) {
  //     eventgoers = eventgoers + 1;
  //   }
  // }

  getvideos() async {
    List<VideoModel> videolist = [];
    print(widget.event.eventid);
    QuerySnapshot snapshot =
        await transactionsRef.doc(widget.event.eventid).collection('videos').get();
    videolist = snapshot.docs.map((e) => VideoModel.fromDocument(e)).toList();

    setState(() {
      this.videolist = videolist;
    });
  }

  eventdetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('images/Calendar.png')),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xffF25E37).withOpacity(0.1)),
            ),
            title: Text(
              '${widget.event.eventdate.toDate().day} ${widget.event.eventmonth} ${widget.event.eventdate.toDate().year} ',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
                '${widget.event.eventdateday}, ${widget.event.timebegin} - ${widget.event.timeend}',
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: const Color(0xff374151))),
          ),
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('images/Location.png')),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xffF25E37).withOpacity(0.1)),
            ),
            title: Text(
              widget.event.eventlocation,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text("widget.event.eventlocationdescription",
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: const Color(0xff374151))),
          ),
        ],
      ),
    );
  }

  organizerinfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 3),
      child: ListTile(
          horizontalTitleGap: 10,
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: kPrimary,
            backgroundImage: CachedNetworkImageProvider(widget.event.organizerimage),
          ),
          title: Text(
            widget.event.organizername,
            style:
                GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          subtitle: Text('Organizer',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500, fontSize: 12))),
    );
  }

  eventheader() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: widget.event.eventheaderimage,
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                fit: BoxFit.cover,
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
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
                                  borderRadius: BorderRadius.circular(100)),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(left: 42.0),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(100)),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(left: 21),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(100)),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(100)),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        '+ ${5 + eventgoers.round()} Attending',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: const Color(0xff048EBF)),
                      ),
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

  // mediacontent() {
  //   List<ImageModel> imagemodel = [];
  //
  //   imagemodel = widget.event.images
  //       .map(
  //         (e) => ImageModel(image: e),
  //       )
  //       .toList();
  //
  //   print(widget.event.images);
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 0.0, top: 30),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 20.0, bottom: 11),
  //           child: Text('Media',
  //               style: GoogleFonts.manrope(
  //                   fontSize: 14, fontWeight: FontWeight.w400)),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(bottom: 10.0),
  //           child: SizedBox(
  //             width: MediaQuery.of(context).size.width,
  //             height: 127,
  //             child: ListView(
  //                 scrollDirection: Axis.horizontal, children: imagemodel),
  //           ),
  //         ),
  //         Column(
  //           children: videolist,
  //         )
  //       ],
  //     ),
  //   );
  // }

  notavailablebutton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: const Color(0xffFFFFFF).withOpacity(0.2),
            borderRadius: BorderRadius.circular(100)),
        child: TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Text(
                'Tickets not Available',
                style: GoogleFonts.manrope(
                    fontSize: 15, fontWeight: FontWeight.w500, color: kPrimary),
              ),
            )),
      ),
    );
  }

  purchasebutton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: kPrimary, borderRadius: BorderRadius.circular(100)),
        child: TextButton(
            onPressed: () {
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
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                children: [
                  Text(
                    'Purchase Ticket',
                    style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Expanded(child: const SizedBox()),
                  Text(
                    'GHS ${widget.event.eventprice}',
                    style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            )),
      ),
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
          'Event Details',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventheader(),
                organizerinfo(),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Text(
                    widget.event.eventname,
                    style: GoogleFonts.manrope(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Text(
                    widget.event.eventdescription,
                    style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff80898C),
                        height: 2),
                  ),
                ),
                eventdetails(),
                // mediacontent(),
              ],
            ),
          ),
          widget.event.issellingtickets ? purchasebutton() : notavailablebutton()
        ],
      ),
    );
  }
}

class ImageModel extends StatelessWidget {
  final String image;

  const ImageModel({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            width: 121,
            height: 121,
          )),
    );
  }
}

class VideoModel extends StatefulWidget {
  final String videourl;
  final String thumbnail;
  final String videoid;

  const VideoModel({
    Key? key,
    required this.videourl,
    required this.thumbnail,
    required this.videoid,
  }) : super(key: key);

  factory VideoModel.fromDocument(DocumentSnapshot doc) {
    return VideoModel(
        videourl: doc.get('videourl'),
        thumbnail: doc.get('thumbnail'),
        videoid: doc.get('videoid'));
  }

  @override
  State<VideoModel> createState() => _VideoModelState();
}

class _VideoModelState extends State<VideoModel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(
                        videourl: widget.videourl,
                      ),
                    ));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.thumbnail,
                        width: MediaQuery.of(context).size.width,
                        height: 170,
                      ),
                    ),
                  ),
                  Image.asset('images/playcircle.png'),
                ],
              ),
            )),
      ),
    );
  }
}
