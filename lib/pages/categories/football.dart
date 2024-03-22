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

import '../store/teamsSelected.dart';

class FootballPage extends StatefulWidget {
  @override
  _VictoirePageState createState() => _VictoirePageState();
}

class _VictoirePageState extends State<FootballPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);
  late String pari = "";
  late int size = 0;
  List<Equipe> teams = [];
  TextEditingController montantController = TextEditingController();

  String formatDateMatch = "dd MMM yyyy";
  String formaterDateMatch(DateTime date) {
    return DateFormat(formatDateMatch).format(date);
  }

  late EquipeProvider equipeProvider =
      Provider.of<EquipeProvider>(context, listen: false);

  void saveTeams(List<Equipe> teams) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> teamList =
        teams.map((team) => json.encode(team.toJson())).toList();
    size = teamList.length;
    prefs.setStringList('teams', teamList);
  }

  Future<List<Equipe>> getTeams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> teamList = prefs.getStringList('teams') ?? [];
    return teamList
        .map((teamJson) => Equipe.fromJson(json.decode(teamJson)))
        .toList();
  }

  Future<int> getTeamsSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> teamList = prefs.getStringList('teams') ?? [];
    size = teamList
        .map((teamJson) => Equipe.fromJson(json.decode(teamJson)))
        .toList()
        .length;
    return size;
  }

  deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('teams');
  }

  bool isIn(List<Equipe> team_id, String current_team_id) {
    return team_id.any((item) => item.id == current_team_id);
  }

  late Pari x_pari = Pari();
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
    getTeamsSize().then((value) => value);
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams Football'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Ajouter des équipes au pari'),
                  GestureDetector(
                    onTap: () {

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamSelectedPage(),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: badges.Badge(
                        badgeContent: Text(
                          '${equipeProvider.teams_selected.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Icon(MaterialCommunityIcons.soccer_field),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              equipeProvider.teams.length < 1
                  ? Center(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()))
                  : SingleChildScrollView(
                      child: SizedBox(
                        height: height * 0.8,
                        //  width: 200,
                        child: ListView.builder(
                          itemCount: equipeProvider.teams.length,
                          itemBuilder: (BuildContext context, int index) {
                            Equipe team = equipeProvider.teams[index];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
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
                                        trailing:isIn( equipeProvider.teams_selected, team.id!)? TextButton(
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
                                            )):TextButton(
                                            onPressed: ()  {
                                           //   await deleteToken();
                                              setState(() {
                                               // teams.add(team);
                                                if (equipeProvider.teams_selected.length>2) {
                                                  SnackBar snackBar = SnackBar(
                                                    content: Text(
                                                      'le nombre maximal est atteint 3',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(color: Colors.red),
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }else{
                                                  equipeProvider.teams_selected.add(team);
                                                }

                                                //saveTeams(teams);
                                              });
                                              print(
                                                  "team size : ${teams.length}");
                                            },
                                            child: Text(
                                              "Ajouter",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ))
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),

    );
  }
}
