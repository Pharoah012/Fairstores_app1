import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/authentication/onboardingScreen.dart';
import 'package:fairstores/backend/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Color color = const Color(0xffF25E37);
DateTime timestamp = DateTime.now();
final userref = FirebaseFirestore.instance.collection('Users');
final schoolref = FirebaseFirestore.instance.collection('Schools');
final notificationsref = FirebaseFirestore.instance.collection('Notifications');
final tokensref = FirebaseFirestore.instance.collection('UserTokens');
final onboardingref = FirebaseFirestore.instance.collection('Onboarding');
final securityref = FirebaseFirestore.instance.collection('Security');
final menuref = FirebaseFirestore.instance.collection('FoodMenu');
final sideoptions = FirebaseFirestore.instance.collection('FoodSideOptions');
final adsref = FirebaseFirestore.instance.collection('Ads');
final jointsref = FirebaseFirestore.instance.collection('foodJoints');
final eventsref = FirebaseFirestore.instance.collection('EventsPrograms');
final eventcontentref = FirebaseFirestore.instance.collection('EventsContent');
final foodcartref = FirebaseFirestore.instance.collection('FoodCart');
final transactionsref = FirebaseFirestore.instance.collection('ActiveOrders');
final categoryref = FirebaseFirestore.instance.collection('Categories');
final eventhisoryref = FirebaseFirestore.instance.collection('Eventshistory');
final historyref = FirebaseFirestore.instance.collection('History');
final eventticketspurchaseref =
    FirebaseFirestore.instance.collection('EventsTicketPurchases');

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "fair_stores", "fair_stores notification",
    description: "fair_stores", importance: Importance.max, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//This methoed is to subscribe them to a particular topic

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Fairstores",
    options: DefaultFirebaseOptions.currentPlatform,
  );

//  await postDetailsToFirestore();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  // Create customized instance which can be registered via dependency injection

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });

//  await postDetailsToFirestore();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FairStores',
        theme: ThemeData(focusColor: color, primaryColor: color
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            ),
        home: const OnboardingScreen());
  }
}

Future<void> execute(
  InternetConnectionChecker internetConnectionChecker,
) async {
  // Simple check to see if we have Internet
  // ignore: avoid_print
  print('''The statement 'this machine is connected to the Internet' is: ''');
  final bool isConnected = await InternetConnectionChecker().hasConnection;
  // ignore: avoid_print
  print(
    isConnected.toString(),
  );
  // returns a bool

  // We can also get an enum instead of a bool
  // ignore: avoid_print
  print(
    'Current status: ${await InternetConnectionChecker().connectionStatus}',
  );
  // Prints either InternetConnectionStatus.connected
  // or InternetConnectionStatus.disconnected

  final StreamSubscription<InternetConnectionStatus> listener =
      InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          // ignore: avoid_print
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
          Fluttertoast.showToast(
              msg: 'You are disconnected from the internet.');
          break;
      }
    },
  );

  // close listener after 30 seconds, so the program doesn't run forever
  await Future<void>.delayed(const Duration(seconds: 1));
}
