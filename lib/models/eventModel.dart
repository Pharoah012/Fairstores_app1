import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/models/videoModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final eventsRef = FirebaseFirestore.instance.collection('EventsPrograms');

class EventModel{
  final String eventname;
  final String eventmonth;
  final String eventdescription;
  final String eventheaderimage;
  final String organizerimage;
  final Timestamp eventdate;
  final String eventid;
  final String organizername;
  final String timebegin;
  final String timeend;
  final List eventimages;

  final List favouriteslist;
  final int favouritescount;
  final String eventlocation;
  final String eventgps;
  final String eventdateday;
  final int eventprice;

  final bool lockevent;
  final bool eticket;
  final bool physicalticket;
  final bool issellingtickets;

  bool isFavorite;
  String? attendeeNumber;

  EventModel({
    required this.eventmonth,
    required this.eticket,
    required this.physicalticket,
    required this.eventdateday,
    required this.issellingtickets,
    required this.eventheaderimage,
    required this.lockevent,
    required this.eventprice,
    required this.eventdate,
    required this.eventdescription,
    required this.eventid,
    required this.eventimages,
    required this.eventname,
    required this.eventgps,
    required this.eventlocation,
    required this.favouritescount,
    required this.favouriteslist,
    required this.organizername,
    required this.organizerimage,
    required this.timebegin,
    required this.timeend,
    this.isFavorite = false,
    this.attendeeNumber
  });

  factory EventModel.fromDocument(DocumentSnapshot doc, String userID) {
    EventModel event = EventModel(
      issellingtickets: doc.get('issellingticket'),
      physicalticket: doc.get('physicalticket_available'),
      eticket: doc.get('eticket_available'),
      eventmonth: doc.get('eventmonth'),
      eventdateday: doc.get('eventdate_day'),
      eventheaderimage: doc.get('eventheaderimage'),
      organizerimage: doc.get('organizerimage'),
      lockevent: doc.get('lockevent'),
      eventprice: doc.get('eventprice'),
      eventdate: doc.get('eventdate'),
      eventdescription: doc.get('eventdescription'),
      eventid: doc.get('eventid'),
      eventimages: doc.get('eventimages'),
      eventname: doc.get('eventname'),
      eventgps: doc.get('eventgps'),
      eventlocation: doc.get('eventlocation'),
      favouritescount: doc.get('favourite_count'),
      favouriteslist: doc.get('favourites_list'),
      organizername: doc.get('organizername'),
      timebegin: doc.get('time_begin'),
      timeend: doc.get('time_end')
    );

    // check if the user has favorited this item
    // and update the isFavorite variable
    for (String element in event.favouriteslist) {
      if (element == userID) {
        event.isFavorite = true;
      }
    }

    final eventTicketsPurchaseRef = FirebaseFirestore
        .instance
        .collection('EventsTicketPurchases');

    eventTicketsPurchaseRef
      .doc(event.eventid)
      .collection('Purchases')
      .where('status', isEqualTo: 'Active')
      .get().then(
        (value) => event.attendeeNumber = value.size.toString()
    );




    return event;
  }

  static Future<List<EventModel>> getFavoriteEvents({
    required String school,
    required String userID
  }) async {
    QuerySnapshot snapshot = await eventsRef
      .doc(school)
      .collection('events')
      .where('favourites_list', arrayContains: userID)
      .get();

    List<EventModel> eventList = snapshot.docs
        .map((doc) =>
        EventModel.fromDocument(doc, userID))
        .toList();

    return eventList;
  }

  static Future<List<EventModel>> getSearchResults({
    required String school,
    required String searchValue,
    required String userID
  }) async {
    QuerySnapshot snapshot = await eventsRef
        .doc(school)
        .collection('events')
        .orderBy("eventname")
        .startAt([searchValue])
        .endAt([searchValue + '\uf8ff'])
        .get();

    List<EventModel> eventList = snapshot.docs
        .map((doc) =>
        EventModel.fromDocument(doc, userID))
        .toList();

    return eventList;
  }

  Future<bool> updateFavorites({
    required String userID,
    required String school
  }) async{

    // check if the user has favorited the food
    // and remove them from list of favorites
    if (this.isFavorite){
      this.favouriteslist.remove(userID);
    }
    else{
      // add the user to the favorites
      this.favouriteslist.add(userID);
    }

    // update the favorites list in the all category firestore
    await eventsRef
      .doc('All')
      .collection('events')
      .doc(this.eventid)
      .update({'favourites_list': this.favouriteslist});

    // update the favorites in the selected school favorites
    await eventsRef
        .doc(school)
        .collection('events')
        .doc(this.eventid)
        .update({'favourites_list': this.favouriteslist});

    //TODO: REMOVE THE FAVORITES COUNT
    await eventsRef
        .doc(school)
        .collection('events')
        .doc(this.eventid)
        .update({'favourite_count': this.favouriteslist.length});

    await eventsRef
        .doc('All')
        .collection('events')
        .doc(this.eventid)
        .update({'favourite_count': this.favouriteslist.length});

    // update the isFavorite variable
    this.isFavorite = !isFavorite;

    return this.isFavorite;
  }

  Future<List<VideoModel>> getVideos() async{

    QuerySnapshot snapshot = await transactionsRef
        .doc(this.eventid)
        .collection('videos')
        .get();

    List<VideoModel>  videoList = snapshot.docs
        .map((doc) => VideoModel.fromDocument(doc))
        .toList();

    return videoList;
  }
}