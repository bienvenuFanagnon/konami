import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/pariencours.dart';
import 'package:konami_bet/pages/profil/profile.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import 'account.dart';
import 'matche_non_jouer.dart';
import 'history.dart';
import 'homepages.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;
  late ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context,listen: false);

  final List<Widget> _pages = [


    MyHistoListMatch(),
    PariEnCours(),
    HomePage(),

    MyListMatch(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white ,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black26,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[


          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty_rounded),
            label: 'Encours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),

          BottomNavigationBarItem(
            icon: Icon(MaterialCommunityIcons.soccer_field),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Compte',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         // await FootballDataApi.fetchSoccerList();
          setState(() {
            _selectedIndex=2;
          });
          serviceProvider.creatAllMatchByApi();

        },
        backgroundColor: Colors.white,
        child: Icon(Icons.sports_soccer_rounded,size: 40,color: Colors.green,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


    );
  }
}