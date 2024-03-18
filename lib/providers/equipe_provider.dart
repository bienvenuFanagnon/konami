import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:konami_bet/services/database.dart';
import 'package:konami_bet/services/soccer_services.dart';

class EquipeProvider extends ChangeNotifier {
  List<Equipe> teams =[];
  List<Equipe> teams_selected =[];

  int genererScoreAleatoire() {
    Random random = Random();
    return random.nextInt(10);
  }

  DateTime genererDateHistoriqueAleatoire() {
    Random random = Random();
    final year = random.nextInt(3) + 2022;
    final month = random.nextInt(12) + 1;
    final day = random.nextInt(31) + 1;
    return DateTime(year, month, day);
  }
  DateTime genererDateHistoriqueAleatoire2() {
    Random random = Random();
    // Définir la date de fin (aujourd'hui)
    DateTime dateFin = DateTime.now();

    // Définir une date de début (plusieurs années auparavant)
    DateTime dateDebut = DateTime.now().subtract(const Duration(days: 365 * 10));

    // Générer un nombre aléatoire entre la date de début et la date de fin
    int nbJoursAleatoire = random.nextInt(dateFin.difference(dateDebut).inDays);

    return dateDebut.add(Duration(days: nbJoursAleatoire));
  }
  List<Match> genererMatchsAleatoires(List<Equipe> equipes) {
    // Créer une liste pour stocker les matchs
    List<Match> matchs = [];

    // Parcourir la liste des équipes deux par deux
    for (var i = 0; i < equipes.length; i += 2) {
      // Si l'index est pair, créer un nouveau match
      if (i % 2 == 0) {
        matchs.add(Match(
          equipes[i],
          equipes[i + 1],
          genererScoreAleatoire(),
          genererScoreAleatoire(),
          genererDateHistoriqueAleatoire(),

        ));
      }
    }

    return matchs;
  }

  Future<List<Match>> getMaths() async {

    teams = [];
    bool hasData=false;
    try{
      CollectionReference userCollect =
      FirebaseFirestore.instance.collection('Equipes');
      // Get docs from collection reference
      QuerySnapshot querySnapshotUser = await userCollect
      // .where("id",isNotEqualTo: currentUserId)
         // .orderBy('point_contribution', descending: true)
       //   .limit(10)
          .get();

      // Afficher la liste
      teams = querySnapshotUser.docs.map((doc) =>
          Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();





      print('list teams ${teams.length}');
      hasData=true;
      teams.shuffle();

      List<List<Equipe>> matchs = [];



      return genererMatchsAleatoires(teams);
     // return teams;
    }catch(e){
      print("erreur ${e}");
      hasData=false;
      return [];
    }

  }

  Future<List<Equipe>> getAllTeams() async {

    teams = [];
    bool hasData=false;
    try{
      CollectionReference userCollect =
      FirebaseFirestore.instance.collection('Equipes');
      // Get docs from collection reference
      QuerySnapshot querySnapshotUser = await userCollect
      // .where("id",isNotEqualTo: currentUserId)
      // .orderBy('point_contribution', descending: true)
      //   .limit(10)
          .get();

      // Afficher la liste
      teams = querySnapshotUser.docs.map((doc) =>
          Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();





      print('list teams ${teams.length}');
      hasData=true;
     // teams.shuffle();

      List<List<Equipe>> matchs = [];



      return teams;
      // return teams;
    }catch(e){
      print("erreur ${e}");
      hasData=false;
      return [];
    }

  }
}