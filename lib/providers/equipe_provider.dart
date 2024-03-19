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
  List<Pari> listPari = [];
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

  Stream<List<Pari>> getListPari() async* {
    var pariStream = FirebaseFirestore.instance.collection('PariEnCours')
       // .where("entreprise_id",isEqualTo:'${entrepriseId}')
      //  .where("status",isNotEqualTo:'${PariStatus.PARIER.name}')
       // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')
        .orderBy('createdAt', descending: true)

        .snapshots();
    List<Pari> paries = [];
    listPari =[];
    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      paries = [];

      for (var post in snapshot.docs) {
        //  print("post : ${jsonDecode(post.toString())}");
        Pari p=Pari.fromJson(post.data());
        p.teams=[];
        CollectionReference equipeCollect = await FirebaseFirestore.instance.collection('Equipes');

        CollectionReference friendCollect = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser = await friendCollect.where("id_db",isEqualTo:'${p.user_id}').get();
        // Afficher la liste


        List<Utilisateur> userList = querySnapshotUser.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();

        p.user=userList.first;
        for(String eqid in p.teams_id!){
          QuerySnapshot querySnapshotPari = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
          // Afficher la liste


          List<Equipe> teamList = querySnapshotPari.docs.map((doc) =>
              Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
          p.teams!.add(teamList.first);

        }
        paries.add(p);
        listPari=paries;


      }
      yield listPari;
    }
  }
  Future<bool> updatePari(Pari pari,BuildContext context) async {
    try{



      await FirebaseFirestore.instance
          .collection('PariEnCours')
          .doc(pari.id)
          .update(pari.toJson());

      return true;
    }catch(e){
      print("erreur update post : ${e}");
      return false;
    }
  }
  Future<Pari> getOnlyPari(String id) async {
    //await getAppData();
    late List<Pari> list= [];

    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('PariEnCours');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.where("id",isEqualTo: id!).get()
        .then((value){

      print(value);
      return value;
    }).catchError((onError){

    });

    // Get data from docs and convert map to List
    list = querySnapshot.docs.map((doc) =>
        Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();



    return list.first;

  }
}

