import 'dart:async';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fairstores/backend/firebase_options.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/credentials.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/offlineStatusProvider.dart';
import 'package:fairstores/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> initOneSignal() async {
  OneSignal.shared.setAppId(oneSignalAppId);
  OneSignal.shared
      .promptUserForPushNotificationPermission()
      .then((accepted) {});
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Fairstores",
    options: DefaultFirebaseOptions.currentPlatform,
  );

//  await postDetailsToFirestore();

  // Set up Awesome notifications
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
          ledColor: Colors.white
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );

  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  // set up one signal
  initOneSignal();

  // Make status bar transparent on Android
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  // Create customized instance which can be registered via dependency injection
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  // This function constantly checks the internet status of the user and alerts them
  Future<void> internetChecker() async {

    log(
      'Current status: ${await InternetConnectionChecker().connectionStatus}',
    );
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:

            // check if the current status is offline
            if (ref.read(offlineProvider)){
              Fluttertoast.showToast(
                  msg: 'You are back online.');

              ref.read(offlineProvider.notifier).state = false;
            }
          // ignore: avoid_print
            print('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            Fluttertoast.showToast(
                msg: 'You are disconnected from the internet.');
            ref.read(offlineProvider.notifier).state = true;
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    // await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      internetChecker();
    });

    super.initState();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(authProvider);
    final offlineChecker = ref.watch(offlineProvider);

    return MaterialApp(
        title: 'FairStores',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: kWhite
          ),
          scaffoldBackgroundColor: kWhite,
          focusColor: kPrimary,
          primaryColor: kPrimary
        ),
        home: SplashScreen(),
    );
  }
}