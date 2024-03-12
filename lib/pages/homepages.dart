import 'dart:async';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/admin/add_team.dart';
import 'package:provider/provider.dart';

import '../models/soccers_models.dart';
import '../providers/providers.dart';
import '../services/soccer_services.dart';
import 'categories/victoire.dart';
import 'homeWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.teal,
      Colors.green,
      Colors.greenAccent,
    ],
  );
  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);
  late Timer _timer;
  late FootballDataApi footballDataApi = FootballDataApi();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Initialisation du timer qui exécute la fonction toutes les 10 secondes
    /*
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      serviceProvider.creatAllMatchByApi();
    });

     */
    //
    this.footballDataApi.apiDataToDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ServiceProvider>(
        builder: (context, sp, _) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  /*
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
              ),

               */
                  // gradient: gradient,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                               onTap: () {
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => AddEquipe(),));
                               },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                color: Colors.green,
                                elevation: 2,
                                child: Container(
                                  width: 150,
                                  child: const Padding(
                                    padding: EdgeInsets.all(1.0),
                                    child: Center(
                                      child: Text(
                                        "Konami",
                                        style: TextStyle(
                                          fontSize: 32.0, // taille de police de 32
                                          color: Colors.white, // couleur blanche
                                          fontWeight:
                                              FontWeight.bold, // texte en gras
                                          fontStyle:
                                              FontStyle.italic, // texte en italique
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.sports_soccer,
                              size: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        CarouselSlider(
                          items: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2,
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.4,
                                width: MediaQuery.of(context).size.width / 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/competition1.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2,
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.4,
                                width: MediaQuery.of(context).size.width / 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/competition2.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2,
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.4,
                                width: MediaQuery.of(context).size.width / 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/competition3.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/competition4.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/competition5.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/competition6.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/competition7.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.25,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                        ),


                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Center(
                          child: HorizontalDropdownList(
                            cardItems: [
                              Card(
                                color: Colors.white70,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VictoirePage()),
                                    );
                                    // action à effectuer lors du clic sur le bouton
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.sports_soccer,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 10.0),
                                        Text('FootBall'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: Colors.white70,
                                child: InkWell(
                                  onTap: () {
                                    // action à effectuer lors du clic sur le bouton
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Icon(Ionicons.basketball_sharp,
                                            color: Colors.green),
                                        SizedBox(width: 10.0),
                                        Text('BasketBall'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Historique'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.006,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60.0,
                right: 0,
                child: Center(
                  child: Row(
                    children: [
                      Center(
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.green,
                                size: 25,
                              ))),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(150),
                        ),
                        elevation: 10,
                        shadowColor: Colors.black,
                        color: Colors.black54,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 20,
                                  color: Colors.yellow,
                                ),
                                Center(
                                  child: Text(
                                    ' ${serviceProvider.loginUser.montant} XOF',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.remove_circle_outlined,
                                color: Colors.red,
                                size: 25,
                              ))),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
