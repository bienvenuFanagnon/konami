import 'dart:async';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/admin/add_team.dart';
import 'package:konami_bet/pages/profil/wallet/homeWallet.dart';
import 'package:konami_bet/providers/equipe_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/soccers_models.dart';
import '../providers/equipe_provider.dart';
import '../providers/providers.dart';
import '../services/soccer_services.dart';
import 'categories/football.dart';
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
   String formatDateMatch = "dd MMM yyyy";
  String formaterDateMatch(DateTime date) {
    return DateFormat(formatDateMatch).format(date);
  }

  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceProvider.getAppData();
    // Initialisation du timer qui exécute la fonction toutes les 10 secondes
    /*
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      serviceProvider.creatAllMatchByApi();
    });

     */
    //
  //  this.footballDataApi.apiDataToDataBase();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
backgroundColor: Colors.green.withOpacity(0.5),
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
        child: RefreshIndicator(
          onRefresh: ()async {
            setState(() {

            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,

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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (serviceProvider.loginUser.role==RoleUser.ADMIN.name||serviceProvider.loginUser.role==RoleUser.SUPERADMIN.name) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddEquipe(),));

                          }
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
                                    fontSize: 25.0, // taille de police de 32
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
                        size: 20,
                        color: Colors.black,
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWallet(),));

                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ))),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(150),
                            ),
                            elevation: 2,
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
                                    StreamBuilder<Utilisateur>(
                                        stream: serviceProvider.getOnLyStreamUser(serviceProvider.loginUser.id_db!),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            Utilisateur user=snapshot.data;
                                            return Center(
                                              child: Text(
                                                ' ${user.montant} XOF',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Icon(Icons.error_outline);
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        })

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
                                    size: 20,
                                  ))),
                        ],
                      ),
                    ),
                  ),


               SizedBox(height: 10,),
                  CarouselSlider(
                    items: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 2,
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          width: MediaQuery.of(context).size.width / 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/img2.jpg'),
                              fit: BoxFit.cover,
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
                          height: MediaQuery.of(context).size.height*0.3,
                          width: MediaQuery.of(context).size.width / 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/img3.jpeg'),
                              fit: BoxFit.cover,
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
                          height: MediaQuery.of(context).size.height*0.3,
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
                          height: MediaQuery.of(context).size.height*0.3,
                          width: MediaQuery.of(context).size.width / 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/img4.jpg'),
                              fit: BoxFit.cover,
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
                          height: MediaQuery.of(context).size.height*0.3,
                          width: MediaQuery.of(context).size.width / 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/img5.jpg'),
                              fit: BoxFit.cover,
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
                          height: MediaQuery.of(context).size.height*0.3,
                          width: MediaQuery.of(context).size.width / 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/img6.jpg'),
                              fit: BoxFit.cover,
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
                          height: MediaQuery.of(context).size.height*0.3,
                          width: MediaQuery.of(context).size.width / 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/img7.jpg'),
                              fit: BoxFit.cover,
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
                          height: MediaQuery.of(context).size.height* 0.3,
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

                    ],
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.2,
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
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      children: [
                        Card(
                          color: Colors.white70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            height: 50,
                            child: InkWell(
                              onTap: () async {
                             await   equipeProvider.getAllTeams().then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FootballPage()),
                                  );
                                },);

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
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Colors.white70,
                          child: Container(
                            height: 50,
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
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),


                  SizedBox(
                  //  height: height*0.5,
                    child: FutureBuilder<List<Match>>(


                        future: equipeProvider.getMaths(),

                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<Match> matchs = snapshot.data!;
                            return SingleChildScrollView(
                              child: SizedBox(
                                height: height*0.5,
                                width: width,                                    //    height: height*0.5,
                                                                       //   width: width,
                                child: ListView.builder(

                                  itemCount: matchs.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    Match match = snapshot.data[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(

                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: Icon(
                                                      Icons.sports_soccer,
                                                      color: Colors.green,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: width*0.3,),
                                                  Text("${formaterDateMatch(match.date)}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Card(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Container(

                                                                  child: Image.network("${match.equipe1.logo!}",fit: BoxFit.cover,),
                                                              width: 30,
                                                                height: 30,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 20,),
                                                          Text("${match.scoreEquipe1.toString()!}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 20),),

                                                        ],
                                                      ),


                                                      Text("${match.equipe1.nom!}"),

                                                    ],
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,                                                            children: [
                                                      Row(
                                                        children: [
                                                          Text("${match.scoreEquipe2.toString()!}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 20),),
                                                          SizedBox(width: 20,),
                                                          Card(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Container(

                                                                child: Image.network("${match.equipe2.logo!}",fit: BoxFit.cover,),
                                                                width: 30,
                                                                height: 30,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text("${match.equipe2.nom!}"),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Icon(Icons.error_outline);
                          } else {
                            return Center(
                              child: Container(
                                width: 50,
                                  height: 50,

                                  child: CircularProgressIndicator()),
                            );
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      )

    );
  }
}

