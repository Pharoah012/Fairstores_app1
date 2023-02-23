import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fairstores/authentication/onboardingScreen.dart';
import 'package:fairstores/backend/firebase_options.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/credentials.dart';
import 'package:fairstores/homescreen/homescreen.dart';
import 'package:fairstores/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
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

//  await postDetailsToFirestore();
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(authProvider);

    return MaterialApp(
        title: 'FairStores',
        theme: ThemeData(
          focusColor: kPrimary,
          primaryColor: kPrimary
        ),
        home: StreamBuilder<User?>(
            stream: _auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User? user = snapshot.data;

                //Check if the user has signed in
                if (user == null) {
                  //Display the signIn page if the user has not logged in
                  return const OnboardingScreen();
                }

                // Navigate to home page when the authentication is successful
                // Redirect the user to the main screen if they're logged in already
                return HomeScreen(
                  user: user,
                );
              }

              //Display a loading UI while the data is loading
              return const Scaffold(
                // backgroundColor: Colors.white,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
        )
    );
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
