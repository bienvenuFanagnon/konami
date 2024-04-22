import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/equipe_provider.dart';
import '../../providers/providers.dart';
import 'package:badges/badges.dart' as badges;

import '../categories/football.dart';
import '../profil/wallet/homeWallet.dart';

class TeamSelectedPage extends StatefulWidget {
  @override
  _TeamSelectedPageState createState() => _TeamSelectedPageState();
}

class _TeamSelectedPageState extends State<TeamSelectedPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  late String pari = "";
  late int size =0;
  bool onTap=false;
  List<Equipe> teams=[];
  TextEditingController montantController = TextEditingController();

  String formatDateMatch = "dd MMM yyyy";
  String formaterDateMatch(DateTime date) {
    return DateFormat(formatDateMatch).format(date);
  }

  deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('teams');
  }

  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);

  void saveTeams(List<Equipe> teams) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> teamList = teams.map((team) => json.encode(team.toJson())).toList();
    size=teamList.length;
    prefs.setStringList('teams', teamList);
  }
  Future<List<Equipe>> getTeams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> teamList = prefs.getStringList('teams') ?? [];
    return teamList.map((teamJson) => Equipe.fromJson(json.decode(teamJson))).toList();
  }

  Future<int> getTeamsSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> teamList = prefs.getStringList('teams') ?? [];
    size =teamList.map((teamJson) => Equipe.fromJson(json.decode(teamJson))).toList().length;
    return size;
  }

  void _showBottomSheet(double width) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: width,
          //height: 200,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Votre solde est insuffisant.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWallet(),));

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_wallet,color: Colors.black,),
                      SizedBox(width: 5,),
                      const Text('Recharger',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  final _formKey = GlobalKey<FormState>();

  late Pari x_pari=Pari();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTeamsSize();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  //  getTeamsSize().then((value) => value);
    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FootballPage(),
              ));
          
        }, icon: Icon(Icons.arrow_back_outlined)),
        automaticallyImplyLeading: false,
        title: Text('Créer un nouveau pari'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height*0.05  ,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Vos équipes'),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: badges.Badge(
                      badgeContent: Text('${equipeProvider.teams_selected.length}',style: TextStyle(color: Colors.white),),
                      child: Icon(MaterialCommunityIcons.soccer_field),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              SingleChildScrollView(
                child: SizedBox(
                  height: height*0.5,
                  width: width,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,

                    itemCount: equipeProvider.teams_selected.length,
                    itemBuilder: (BuildContext context,
                        int index) {
                      Equipe team = equipeProvider.teams_selected[index];
                      return Container(
                        //width: 100,
                        //   height: 100,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              //width: 200,
                              child: ListTile(
                                  title: Padding(
                                    padding:
                                    const EdgeInsets.only(left: 5.0),
                                    child: Icon(
                                      Icons.sports_soccer,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ),
                                  subtitle: Text("${team.nom!}"),
                                  leading: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        child: Image.network(
                                          "${team.logo!}",
                                          fit: BoxFit.cover,
                                        ),
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                  trailing:TextButton(
                                      onPressed: ()  {

                                        setState(() {
                                          // teams.add(team);
                                          equipeProvider.teams_selected.remove(team);

                                          //saveTeams(teams);
                                        });
                                        print(
                                            "team size : ${teams.length}");
                                      },
                                      child: Text(
                                        "Retirer",
                                        style: TextStyle(
                                            color: Colors.red),
                                      ))
                              ),
                            ),
                          ),
                        ),
                      );
                    },),
                ),
              ),

            ],
          ),
        ),
      ),
      bottomSheet:         Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            Container(
              width: width*0.8,
              child: TextFormField(
                controller: montantController,
                keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              labelText: 'Montant',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Le montant est obligatoire';
                }
                if (double.tryParse(value) == null) {
                  return 'Le montant doit être un nombre';
                }
                if (int.parse(value)<1000) {
                  return 'Le montant doit être > 1000 fcfa ';
                }
                return null;
              },
                        ),
            ),
                SizedBox(height: 20,),
                TextButton(onPressed:onTap?() {

                } :() async {
                  if (_formKey.currentState!.validate()) {
                    if (equipeProvider.teams_selected.length==3) {
                      setState(() {
                        onTap=true;
                      });

                      try{
                        await serviceProvider.getUserByIdContente(serviceProvider.loginUser.id_db!, context).then((value) async {
                          if (value) {
                            if (serviceProvider.loginUser.montant>0&&serviceProvider.loginUser.montant>=double.parse(montantController.text)) {
                              String id = FirebaseFirestore.instance
                                  .collection('PariEnCours')
                                  .doc()
                                  .id;
                              Pari pari=Pari();
                              pari.id=id;
                              pari.score=0;
                              pari.resultStatus=PariResultStatus.NAN.name;
                              pari.teams=[];
                              pari.teams_id=[];
                              pari.montant=double.parse(montantController.text);
                              pari.user_id=serviceProvider.loginUser.id_db!;
                              pari.status=PariStatus.DISPONIBLE.name;
                              for(Equipe eq in equipeProvider.teams_selected){
                                pari.teams_id!.add(eq.id!);
                              }
                              equipeProvider.teams_selected=[];

                              pari.createdAt= DateTime.now().millisecondsSinceEpoch;// Get current time in milliseconds
                              pari.updatedAt= DateTime.now().millisecondsSinceEpoch;
                              await FirebaseFirestore.instance.collection('PariEnCours').doc(id).set(pari.toJson());
                              serviceProvider.loginUser.montant=serviceProvider.loginUser.montant-double.parse(montantController.text);
                              await  serviceProvider.updateUser(serviceProvider.loginUser, context);

                              montantController.text="";
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  "Le pari a été créé avec succès, veuillez le voir votre liste des paris en cours.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            else{
                              _showBottomSheet(width);

                            }//sold in

                          }  else{

                          }
                        },);



                      }catch(e){
                        print("erreur update post : ${e}");
                        setState(() {
                          onTap=false;
                        });
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            "erreur",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                      }

                      setState(() {
                        onTap=false;
                      });
                    }  else{
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          "Le nombre d'équipes requis 3",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                    }



                    // Traiter le montant saisi
                  }

                }, child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: width*0.6,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),

                    child:onTap? Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ): Text('Créer un nouveau pari',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),)),),
              ],
            ),
          ),
        ),
      )
      ,

    );
  }
}
