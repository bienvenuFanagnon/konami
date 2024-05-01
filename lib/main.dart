import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konami_bet/pages/admin/home.dart';
import 'package:konami_bet/pages/auth/phone.dart';
import 'package:konami_bet/pages/auth/registration.dart';
import 'package:konami_bet/pages/auth/verify.dart';
import 'package:konami_bet/pages/chargement_login.dart';
import 'package:konami_bet/pages/commentCaMarche.dart';
import 'package:konami_bet/pages/contact.dart';
import 'package:konami_bet/pages/home.dart';
import 'package:konami_bet/pages/intoPage.dart';
import 'package:konami_bet/pages/profil/profile.dart';
import 'package:konami_bet/providers/equipe_provider.dart';
import 'package:konami_bet/services/soccer_services.dart';
import 'firebase_options.dart';
import 'providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);
  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("eeab82ff-8f16-445d-b907-75188cf4f56d");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);


  //Remove this method to stop OneSignal Debugging

  // Planifier une tâche récurrente toutes les 10 secondes
  //final scheduler = IntervalScheduler(delay: Duration(seconds: 5));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ChangeNotifierProvider(create: (_) => EquipeProvider()),
      // ChangeNotifierProvider(create: (_) => MyProvider2()),
    ],
    child: MyApp(),
  ));

//kIsWeb?
  //:null;
}

// Overrides a label for en locale
// To add localization for a custom language follow the guide here:
// https://flutter.dev/docs/development/accessibility-and-localization/internationalization#an-alternative-class-for-the-apps-localized-resources

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _debugLabelString = "";
  String? _emailAddress;
  String? _smsNumber;
  String? _externalUserId;
  String? _language;
  bool _enableConsentButton = false;
  bool _requireConsent = true;

  Future<void> initOneSignal() async {
    /*
    OneSignal.Debug.setLogLevel(
      kDebugMode ? OSLogLevel.verbose : OSLogLevel.none,
    );
    */
     OneSignal.Debug.setLogLevel(
      OSLogLevel.verbose,
    );

    OneSignal.initialize("eeab82ff-8f16-445d-b907-75188cf4f56d");

    final id = OneSignal.User.pushSubscription.id;

    if (id != null) {
      /*
      SharedPreferences.getInstance().then((value) {
        value.setString(Preferences.oneSignalUserId, id);
      });
      */
    }

    await OneSignal.Notifications.requestPermission(true);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(_requireConsent);

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    OneSignal.initialize("eeab82ff-8f16-445d-b907-75188cf4f56d");
    OneSignal.Notifications.requestPermission(true);

    // AndroidOnly stat only
    // OneSignal.Notifications.removeNotification(1);
    // OneSignal.Notifications.removeGroupedNotifications("group5");

    // OneSignal.Notifications.clearAll();

    OneSignal.User.pushSubscription.addObserver((state) {
      print('OneSignal add user data');

      print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      print(OneSignal.User.pushSubscription.token);
      print('state current jsonRepresentation');

      print(state.current.jsonRepresentation());
    });

    OneSignal.User.addObserver((state) {
      var userState = state.jsonRepresentation();
      print('OneSignal user changed: $userState');
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });

    OneSignal.Notifications.addClickListener((event) {
      print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      this.setState(() {
        _debugLabelString =
            "Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print(
          'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();

      this.setState(() {
        _debugLabelString =
            "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.InAppMessages.addClickListener((event) {
      this.setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
    });

    this.setState(() {
      _enableConsentButton = _requireConsent;
    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    // oneSignalInAppMessagingTriggerExamples();

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    //oneSignalOutcomeExamples();

    OneSignal.InAppMessages.paused(false);
  }

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.InAppMessages.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, String> triggers = new Map<String, String>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.InAppMessages.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.InAppMessages.removeTrigger("trigger_2");

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.InAppMessages.removeTriggers(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.InAppMessages.paused(false);
    var arePaused = await OneSignal.InAppMessages.arePaused();
    print('Notifications paused $arePaused');
  }

  void _handleLogout() {
    OneSignal.logout();
    OneSignal.User.removeAlias("fb_id");
  }

  void _handleGetOnesignalId() async {
    var onesignalId = await OneSignal.User.getOnesignalId();
    print('OneSignal ID: $onesignalId');
  }

  late FirebaseAuth _auth = FirebaseAuth.instance;

  late bool _isLogged = false;
  late bool isAndroid = false;
  late User? _user;
  void _checkCurrentUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {
        _isLogged = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //  _checkCurrentUser();
    /*
    Timer.periodic(Duration(seconds: 60), (timer) {
      footballDataApi.apiDataToDataBase();
    });
    */
    //initOneSignal();

    //initPlatformState();
    //_handleGetOnesignalId();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'konami',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      //  initialRoute:  'chargement',
      initialRoute: 'intro',
      routes: {
        '/': (context) => MyHomePage(
            title:
                "konami"), //kIsWeb?AdminHomePage(): MyHomePage(title: "konami"),
        //'verify': (context) =>  MyHomePage(title: "konami"),
        'phone': (context) => MyPhone(), //kIsWeb?AdminHomePage(): MyPhone(),
        // 'verify': (context) => VerificationOtp(verificationId: verificationId, phoneNumber: phoneNumber),
        'homeAdm': (context) => AdminHomePage(),
        //'register': (context) => RegistrationPage(),
        'chargement': (context) => SplahsChargement(),
        'contact': (context) => ContactPage(),
        'infos': (context) => AppInfos(),
        'profil': (context) => Profil(),
        'intro': (context) => IntroPage(),
      },
    );
  }
}
