import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:konami_bet/pages/admin/home.dart';
import 'package:konami_bet/pages/auth/phone.dart';
import 'package:konami_bet/pages/auth/registration.dart';
import 'package:konami_bet/pages/auth/verify.dart';
import 'package:konami_bet/pages/home.dart';
import 'package:konami_bet/services/soccer_services.dart';
import 'firebase_options.dart';
import 'providers/providers.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Planifier une tâche récurrente toutes les 10 secondes
  //final scheduler = IntervalScheduler(delay: Duration(seconds: 5));

  runApp(

      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ServiceProvider()),
          // ChangeNotifierProvider(create: (_) => MyProvider2()),
        ],
        child: MyApp(),
      )
  );

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
  late   FirebaseAuth _auth = FirebaseAuth.instance;
  late   FootballDataApi footballDataApi =FootballDataApi();

  late bool _isLogged = false;
  late bool isAndroid=false;
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
    _checkCurrentUser();
    /*
    Timer.periodic(Duration(seconds: 60), (timer) {
      footballDataApi.apiDataToDataBase();
    });
    */
  }




  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'konami',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      initialRoute: _isLogged?'/' : 'phone',
      routes: {
        '/': (context) =>MyHomePage(title: "konami"), //kIsWeb?AdminHomePage(): MyHomePage(title: "konami"),
        //'verify': (context) =>  MyHomePage(title: "konami"),
        'phone': (context) =>MyPhone(),//kIsWeb?AdminHomePage(): MyPhone(),
        'verify': (context) => MyVerify(),
        'homeAdm': (context) => AdminHomePage(),
        'login': (context) => RegistrationPage(),
      },

    );
  }
}
