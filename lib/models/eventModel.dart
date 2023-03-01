import 'package:cloud_firestore/cloud_firestore.dart';


final eventsRef = FirebaseFirestore.instance.collection('EventsPrograms');

class EventModel{
  final String eventname;
  final String user;
  final String school;
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

  const EventModel({
    required this.eventmonth,
    required this.eticket,
    required this.physicalticket,
    required this.eventdateday,
    required this.issellingtickets,
    required this.eventheaderimage,
    required this.user,
    required this.school,
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
    required this.timeend
  });

  factory EventModel.fromDocument(DocumentSnapshot doc, school, user) {
    return EventModel(
      user: user,
      school: school,
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
        EventModel.fromDocument(doc, school, userID))
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
        .where('eventname', isGreaterThanOrEqualTo: searchValue)
        .get();

    List<EventModel> eventList = snapshot.docs
        .map((doc) =>
        EventModel.fromDocument(doc, school, userID))
        .toList();

    return eventList;
  }
}