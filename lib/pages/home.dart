import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/pariencours.dart';
import 'package:konami_bet/pages/profil/profile.dart';
import 'package:provider/provider.dart';
import '../providers/equipe_provider.dart';
import '../providers/providers.dart';
import 'account.dart';
import 'package:badges/badges.dart' as badges;
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
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  String formatDateMatch = "dd MMM yyyy";


  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);
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

      body: WillPopScope(
          onWillPop: () async {
            // Affichez une boîte de dialogue de confirmation
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Voulez-vous vraiment quitter ?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);

                    },
                    child: Text('Non'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, true);

                    },
                    child: Text('Oui'),
                  ),
                ],
              ),
            );
          },

          child: _pages[_selectedIndex]),
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
        items:  <BottomNavigationBarItem>[


          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon:StreamBuilder<int>(
                stream: equipeProvider.getUserAllListPariCount(serviceProvider.loginUser.id_db!),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    int count =snapshot.data;

                    return   badges.Badge(
                      showBadge:count>0? true:false,

                      badgeContent: Text(count>9?"+9":'${count}',style: TextStyle(color: Colors.white),),
                      child: Icon(Icons.hourglass_empty_rounded),
                    );
                  } else if (snapshot.hasError) {
                    return badges.Badge(
                      showBadge: false,
                      badgeContent: Text('',style: TextStyle(color: Colors.white),),
                      child: Icon(Icons.hourglass_empty_rounded),
                    );
                  } else {
                    return badges.Badge(
                      showBadge: false,

                      badgeContent: Text('',style: TextStyle(color: Colors.white),),
                      child: Icon(Icons.hourglass_empty_rounded),
                    );
                  }
                }) ,
            label: 'Encours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),

          BottomNavigationBarItem(
            icon:StreamBuilder<int>(
                stream: equipeProvider.getListMatchCount(serviceProvider.loginUser.id_db!),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    int count =snapshot.data;

                    return   badges.Badge(
                      showBadge:count>0? true:false,

                      badgeContent: Text(count>9?"+9":'${count}',style: TextStyle(color: Colors.white),),
                      child: Icon(MaterialCommunityIcons.soccer_field),
                    );
                  } else if (snapshot.hasError) {
                    return badges.Badge(
                      showBadge: false,
                      badgeContent: Text('',style: TextStyle(color: Colors.white),),
                      child: Icon(MaterialCommunityIcons.soccer_field),
                    );
                  } else {
                    return badges.Badge(
                      showBadge: false,

                      badgeContent: Text('',style: TextStyle(color: Colors.white),),
                      child: Icon(MaterialCommunityIcons.soccer_field),
                    );
                  }
                }) ,
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