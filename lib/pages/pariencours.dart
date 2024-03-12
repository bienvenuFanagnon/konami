import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';

class PariEnCours extends StatefulWidget {
  const PariEnCours({Key? key}) : super(key: key);

  @override
  State<PariEnCours> createState() => _PariEnCoursState();
}

class _PariEnCoursState extends State<PariEnCours> {
  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pari En Cours'),
        ),
        body: Consumer<ServiceProvider>(builder: (context, sp, _) {
          return Container(
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('PariEnCours')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print("erreuruurururuurur");
                        return  Center(
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.red,
                            )),
                          );
                        }

                        if (!snapshot.hasData) {
                          return Center(
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.green,
                            )),
                          );
                        }

                        QuerySnapshot data =
                            snapshot.requireData as QuerySnapshot;
                        // Get data from docs and convert map to List
                        List<Pari> list = data!.docs!
                            .map((doc) => Pari.fromJson(
                                doc.data() as Map<String, dynamic>))
                            .toList();

                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            Pari pari = list[index];
                            String choixpari =""; 
                            if(pari.user_home_pari!=null){
                              choixpari= pari.user_home_pari!;

                            }else if(pari.user_away_pari!=null){
                               choixpari= pari.user_away_pari!;

                            }
                            

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2,
                              color: Colors.white54,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.003,
                                        ),
                                        Text(
                                          "${pari.competition!}",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: SizedBox(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200),
                                                  ),
                                                  elevation: 4,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              200),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/teama.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Center(
                                                    child: Text(
                                                  "${pari.homeTeamName!}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Center(
                                                    child: Text(
                                                  "${pari.home_score != null ? pari.home_score : 0} -"
                                                  " ${pari.away_score != null ? pari.away_score : 0} ",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 20),
                                                ))),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Center(
                                                    child: Text(
                                                  "${pari.awayTeamName}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: SizedBox(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200),
                                                  ),
                                                  elevation: 4,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              200),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/teamb.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            child: Center(
                                                child: Text(
                                          ' ${DateTime.parse(pari.dateDuMatch!).day}-${DateTime.parse(pari.dateDuMatch!).month}-${DateTime.parse(pari.dateDuMatch!).year} ${DateTime.parse(pari.dateDuMatch!).hour}:${DateTime.parse(pari.dateDuMatch!).minute}',
                                          style: TextStyle(color: Colors.black),
                                        ))),
                                        SizedBox(
                                            child: Center(
                                                child: Text(
                                          'Prix ${pari.prix} XOF',
                                          style: TextStyle(color: Colors.green),
                                        ))),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: choixpari ==ChoixPari.V1.name?
                                                 Card(
                                                   color: Colors.red,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Deja",
                                                        style: TextStyle(
                                                             color: Colors.black,
                                                                ),
                                                      ),
                                                      // Other widgets for card 1
                                                    ],
                                                  ),
                                                ): GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    print(
                                                        "id user : ${serviceProvider.loginUser.id_db.toString()}");
                                                    pari.id_home_user =
                                                        serviceProvider
                                                            .loginUser.id_db;
                                                  });

                                                  // Action to perform when the card is tapped
                                                },
                                                child: Card(
                                                   color: Colors.black26,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "V1",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      // Other widgets for card 1
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: choixpari ==ChoixPari.X.name?
                                                 Card(
                                                  color: Colors.red,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Deja",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      // Other widgets for card 1
                                                    ],
                                                  ),
                                                ): GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    pari.id_home_user =
                                                        sp.loginUser.id_db;
                                                    pari.id_user =
                                                        sp.loginUser.id_db;
                                                  });

                                                  // Action to perform when the card is tapped
                                                },
                                                child: Card(
                                                  color: Colors.black26,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "X",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      // Other widgets for card 2
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child:choixpari ==ChoixPari.V2.name?
                                                 Card(
                                                   color: Colors.red,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Deja",
                                                        style: TextStyle(
                                                             color: Colors.black,
                                                                ),
                                                      ),
                                                      // Other widgets for card 1
                                                    ],
                                                  ),
                                                ): GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    pari.id_away_user =
                                                        sp.loginUser.id_db;
                                                    pari.id_user =
                                                        sp.loginUser.id_db;
                                                  });

                                                  // Action to perform when the card is tapped
                                                },
                                                child: Container(
                                                  child: Card(
                                                     color: Colors.black26,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "V2",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        // Other widgets for card 3
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
