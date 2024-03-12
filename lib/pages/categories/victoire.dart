import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';

class VictoirePage extends StatefulWidget {
  @override
  _VictoirePageState createState() => _VictoirePageState();
}

class _VictoirePageState extends State<VictoirePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);
  late String pari = "";
  TextEditingController montantController = TextEditingController();
late Pari x_pari=Pari();
  void createNumberInputDialog(BuildContext context) {
    int? inputValue;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Placer un pari',style: TextStyle(color: Colors.green),),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Victoire  ",
                  style: TextStyle(color: Colors.black87),
                ),
                Text("${this.pari}", style: TextStyle(color: Colors.green)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Montant >= 900 XOF  ",
                  style: TextStyle(color: Colors.black26),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: montantController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Montant",
                    labelStyle: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                pari="";
                montantController.text="";
                Navigator.of(context).pop();
              },
              child: Text('Annuler',style: TextStyle(color: Colors.red),),
            ),
            TextButton(
              onPressed: () {
                // Vous pouvez faire quelque chose avec la valeur saisie ici
                
                
                this.x_pari.prix=double.parse(montantController.text);
                
                print('La valeur saisie est ${x_pari.prix}');
                if( this.x_pari.prix!>=900){
                     print('pari accepter');
                          pari="";
                montantController.text="";
                serviceProvider.creerPari(this.x_pari);
                Navigator.of(context).pop();

                }else{
                    print('pari non accepter');

                }
           
              },
              child: Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Victoire'),
        ),
        body: Consumer<ServiceProvider>(builder: (context, sp, _) {
          return Container(
            child:  ListView(
                children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Matches')
                            .where('status',isEqualTo: '${MatchStatus.TIMED.name}')
                            .snapshots(),
                        builder: (context, snapshot) {
    if (snapshot.hasError) {
      print("erreuruurururuurur");
      print(snapshot.error.toString());
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
                          List<Matches> list = data!.docs!
                              .map((doc) => Matches.fromJson(
                                  doc.data() as Map<String, dynamic>))
                              .toList();
                          List<Matches> listMatche =[];
                          /*
                         for(final item in list){
                           Matches match = item;
                           if (match.status == MatchStatus.FINISHED!.name! || match.status == MatchStatus.CANCELLED!.name! ||
                           match.status == MatchStatus.SUSPENDED!.name!) {
                             //les matches fini
                             //sp.deleteMatchFinished(match.id_db!);
                           }else{
                             listMatche.add(item);

                           }


                         }
                         
                           */
                          return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              Matches match = list[index];
                              Pari pari= Pari();
                              pari.status=match.status;
                              pari.away_score=match.awayTeamScore;
                              pari.home_score=match.homeTeamScore;
                              pari.awayTeamLogo=match.awayTeamLogo;
                              pari.homeTeamLogo=match.homeTeamLogo;
                              pari.awayTeamName=match.awayTeamName;
                              pari.homeTeamName=match.homeTeamName;
                              pari.heureDuMatch=match.heureDuMatch;
                              pari.dateDuMatch=match.dateDuMatch;
                               pari.competition=match.competition;

                              pari.id_match=match.id_db;
                              pari.typePari=TypePari.VICTOIRE.name;
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
                                            "${match.competition!}",
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
                                                    "${match.homeTeamName!}",
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
                                                    "${match.homeTeamScore != null ? match.homeTeamScore : 0} -"
                                                    " ${match.awayTeamScore != null ? match.awayTeamScore : 0} ",
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
                                                    "${match.awayTeamName}",
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
                                            ' ${DateTime.parse(match.dateDuMatch!).day}-${DateTime.parse(match.dateDuMatch!).month}-${DateTime.parse(match.dateDuMatch!).year} ${DateTime.parse(match.dateDuMatch!).hour}:${DateTime.parse(match.dateDuMatch!).minute}',
                                            style: TextStyle(color: Colors.black),
                                          ))),
                                          SizedBox(
                                              child: Center(
                                                  child: Text(
                                            ' ${match.status}',
                                            style: TextStyle(color: Colors.black),
                                          ))),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                     
                                                      pari.id_home_user=serviceProvider.loginUser.id_db;
                                                      this.x_pari=Pari();
                                                      pari.id_user=serviceProvider.loginUser.id_db;

                                                      this.pari = ChoixPari.V1.name;
                                                      pari.user_home_pari=this.pari;
                                                      this.x_pari=pari;


                                                    });
                                                    createNumberInputDialog(
                                                        context);

                                                    // Action to perform when the card is tapped
                                                  },
                                                  child: Card(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "V1",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        // Other widgets for card 1
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      pari.id_home_user=sp.loginUser.id_db;
                                                      pari.id_user=sp.loginUser.id_db;

                                                     this.x_pari=Pari();
                                                      this.pari = ChoixPari.X.name;
                                                      pari.user_home_pari=this.pari;
                                                      this.x_pari=pari;
                                                    });
                                                    createNumberInputDialog(
                                                        context);

                                                    // Action to perform when the card is tapped
                                                  },
                                                  child: Card(
                                                    color: Colors.green,
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
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      pari.id_away_user=sp.loginUser.id_db;
                                                      pari.id_user=sp.loginUser.id_db;
                                                      this.x_pari=Pari();
                                                      this.pari = ChoixPari.V2.name;
                                                      pari.user_away_pari=this.pari;
                                                      this.x_pari=pari;
                                                    });
                                                    createNumberInputDialog(
                                                        context);
                                                    // Action to perform when the card is tapped
                                                  },
                                                  child: Container(
                                                    child: Card(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "V2",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.green),
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
        }
        )
    );
  }
}
