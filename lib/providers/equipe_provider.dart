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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Stream<List<Pari>> getListPari(String user_id) async* {
    var pariStream = FirebaseFirestore.instance.collection('PariEnCours')
       // .where("entreprise_id",isEqualTo:'${entrepriseId}')


        .where( Filter.or(
      Filter('status', isEqualTo:  '${PariStatus.ATTENTE.name}'),
      Filter('status', isEqualTo:  '${PariStatus.DISPONIBLE.name}'),
      Filter('status', isEqualTo:  '${PariStatus.ENCOURS.name}'),

    ))
        .where("user_id",isNotEqualTo:'${user_id}')
        .orderBy('user_id', descending: true) // Ordering by 'user_id' (matches filter)

    //  .where("status",isNotEqualTo:'${PariStatus.PARIER.name}')
        .orderBy("status")  // Order by status first
        .orderBy("createdAt", descending: true)
       // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')


        .snapshots();
    List<Pari> paries = [];
    listPari =[];
    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      paries = [];
      listPari =[];

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
        print("pari lgt : ${listPari.length}");
        listPari=paries;


      }
      yield listPari;
    }
  }

  Stream<List<Pari>> getUserAllListPari(String user_id) async* {
    var pariStream = FirebaseFirestore.instance.collection('PariEnCours')
    // .where("entreprise_id",isEqualTo:'${entrepriseId}')
        .where( 'user_id', isEqualTo:  user_id!

    )
       // .where("status",isNotEqualTo:'${PariStatus.PARIER.name}')
      //  .orderBy("status")  // Order by status first
        .orderBy("createdAt", descending: true)
    // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')


        .snapshots();
    List<Pari> paries = [];
    listPari =[];
    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      paries = [];
      listPari =[];

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
  Stream<List<Pari>> getUserHistoListPari(String user_id) async* {
    var pariStream = FirebaseFirestore.instance.collection('PariEnCours')
    // .where("entreprise_id",isEqualTo:'${entrepriseId}')

       // .where("status",isEqualTo:'${PariStatus.PARIER.name}')
       // .orderBy("status")
        .where( 'user_id', isEqualTo:  user_id! )// Order by status first
        .orderBy("createdAt", descending: true)
    // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')


        .snapshots();
    List<Pari> paries = [];
    listPari =[];
    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      paries = [];
      listPari =[];

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

  Stream<List<Pari>> getUserPariResultStatus(String user_id,String status) async* {
    var pariStream = FirebaseFirestore.instance.collection('PariEnCours')
    // .where("entreprise_id",isEqualTo:'${entrepriseId}')

        .where("resultStatus",isEqualTo:'${status}')
    // .orderBy("status")
        .where( 'user_id', isEqualTo:  user_id! )// Order by status first
        .orderBy("createdAt", descending: true)
    // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')


        .snapshots();
    List<Pari> paries = [];
    listPari =[];
    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      paries = [];
      listPari =[];

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

  Stream<List<MatchPari>> getHistoListMatch(String user_id) async* {
    var pariStream = FirebaseFirestore.instance.collection('Matches')
    // .where("entreprise_id",isEqualTo:'${entrepriseId}')
    //  .where("status",isNotEqualTo:'${PariStatus.PARIER.name}')
    // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')
        .where( Filter.or(
      Filter('user_a_id', isEqualTo:  user_id!),
      Filter('user_b_id', isEqualTo:  user_id!),

    ))
        .where("status",isEqualTo:'${MatchStatus.FINISHED.name}')
        //.orderBy("status")
        .orderBy('createdAt', descending: true)

        .snapshots();
    List<MatchPari> matches = [];

    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      matches = [];
      listPari =[];

      for (var post in snapshot.docs) {
        //  print("post : ${jsonDecode(post.toString())}");
        MatchPari match=MatchPari.fromJson(post.data());
        match.pari_a=Pari();
        match.pari_b=Pari();
        match.user_a=Utilisateur();
        match.user_b=Utilisateur();
        CollectionReference equipeCollect = await FirebaseFirestore.instance.collection('Equipes');


        CollectionReference pariCollect1 = await FirebaseFirestore.instance.collection('PariEnCours');
        QuerySnapshot querySnapshotPari1 = await pariCollect1.where("id",isEqualTo:'${match.pari_a_id}').get();

        CollectionReference pariCollect2 = await FirebaseFirestore.instance.collection('PariEnCours');
        QuerySnapshot querySnapshotPari2 = await pariCollect2.where("id",isEqualTo:'${match.pari_b_id}').get();


        CollectionReference friendCollect1 = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser1 = await friendCollect1.where("id_db",isEqualTo:'${match.user_a_id}').get();
        CollectionReference friendCollect2 = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser2 = await friendCollect2.where("id_db",isEqualTo:'${match.user_b_id}').get();

        //Paries

        List<Pari> pariList1 = querySnapshotPari1.docs.map((doc) =>
            Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();
        List<Pari> pariList2= querySnapshotPari2.docs.map((doc) =>
            Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();



        //Users
        List<Utilisateur> userList1 = querySnapshotUser1.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();
        List<Utilisateur> userList2= querySnapshotUser2.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();

        match.user_a=userList1.first;
        match.user_b=userList2.first;
        match.pari_a=pariList1.first;
        match.pari_b=pariList2.first;
        for(String eqid in  match.pari_a!.teams_id!){
          QuerySnapshot querySnapshotEquipe = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
          // Afficher la liste


          List<Equipe> teamList = querySnapshotEquipe.docs.map((doc) =>
              Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
          match.pari_a!.teams!.add(teamList.first);

        }
        for(String eqid in  match.pari_b!.teams_id!){
          QuerySnapshot querySnapshotEquipe = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
          // Afficher la liste


          List<Equipe> teamList = querySnapshotEquipe.docs.map((doc) =>
              Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
          match.pari_b!.teams!.add(teamList.first);

        }


        print("pari1 lght : ${pariList1.first.toJson()}");
        print("pari2 lght : ${pariList2.first.toJson()}");
        print("pari1 lght : ${pariList1.first.teams!.length}");
        print("pari2 lght : ${pariList2.first.teams!.length}");
        matches.add(match);
        //  listPari=paries;


      }
      yield matches;
    }
  }
  Stream<List<MatchPari>> getListMatch(String user_id) async* {
    var pariStream = FirebaseFirestore.instance.collection('Matches')
       // .where("entreprise_id",isEqualTo:'${entrepriseId}')
      //  .where("status",isNotEqualTo:'${PariStatus.PARIER.name}')
       // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')
        .where( Filter.or(
      Filter('user_a_id', isEqualTo:  user_id!),
      Filter('user_b_id', isEqualTo:  user_id!),

    ))
        .where("status",isNotEqualTo:'${MatchStatus.FINISHED.name}')
        .orderBy("status")
        .orderBy('createdAt', descending: true)

        .snapshots();
    List<MatchPari> matches = [];

    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      matches = [];
      listPari =[];

      for (var post in snapshot.docs) {
        //  print("post : ${jsonDecode(post.toString())}");
        MatchPari match=MatchPari.fromJson(post.data());
        match.pari_a=Pari();
        match.pari_b=Pari();
        match.user_a=Utilisateur();
        match.user_b=Utilisateur();
        CollectionReference equipeCollect = await FirebaseFirestore.instance.collection('Equipes');


        CollectionReference pariCollect1 = await FirebaseFirestore.instance.collection('PariEnCours');
        QuerySnapshot querySnapshotPari1 = await pariCollect1.where("id",isEqualTo:'${match.pari_a_id}').get();

        CollectionReference pariCollect2 = await FirebaseFirestore.instance.collection('PariEnCours');
        QuerySnapshot querySnapshotPari2 = await pariCollect2.where("id",isEqualTo:'${match.pari_b_id}').get();


        CollectionReference friendCollect1 = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser1 = await friendCollect1.where("id_db",isEqualTo:'${match.user_a_id}').get();
        CollectionReference friendCollect2 = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser2 = await friendCollect2.where("id_db",isEqualTo:'${match.user_b_id}').get();

        //Paries

        List<Pari> pariList1 = querySnapshotPari1.docs.map((doc) =>
            Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();
        List<Pari> pariList2= querySnapshotPari2.docs.map((doc) =>
            Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();



        //Users
        List<Utilisateur> userList1 = querySnapshotUser1.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();
        List<Utilisateur> userList2= querySnapshotUser2.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();

        match.user_a=userList1.first;
        match.user_b=userList2.first;
        match.pari_a=pariList1.first;
        match.pari_b=pariList2.first;
        for(String eqid in  match.pari_a!.teams_id!){
          QuerySnapshot querySnapshotEquipe = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
          // Afficher la liste


          List<Equipe> teamList = querySnapshotEquipe.docs.map((doc) =>
              Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
          match.pari_a!.teams!.add(teamList.first);

        }
        for(String eqid in  match.pari_b!.teams_id!){
          QuerySnapshot querySnapshotEquipe = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
          // Afficher la liste


          List<Equipe> teamList = querySnapshotEquipe.docs.map((doc) =>
              Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
          match.pari_b!.teams!.add(teamList.first);

        }


        print("pari1 lght : ${pariList1.first.toJson()}");
        print("pari2 lght : ${pariList2.first.toJson()}");
        print("pari1 lght : ${pariList1.first.teams!.length}");
        print("pari2 lght : ${pariList2.first.teams!.length}");
        matches.add(match);
      //  listPari=paries;


      }
      yield matches;
    }
  }

  Stream<MatchPari> getOnLyStreamMatch(String id) async* {
    var pariStream = FirebaseFirestore.instance.collection('Matches')
    .where("id",isEqualTo:'${id}')
    //  .where("status",isNotEqualTo:'${PariStatus.PARIER.name}')
    // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')
        //.orderBy('createdAt', descending: true)

        .snapshots();
    List<MatchPari> matches = [];

    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      matches = [];
      listPari =[];

      for (var post in snapshot.docs) {
        //  print("post : ${jsonDecode(post.toString())}");
        MatchPari match=MatchPari.fromJson(post.data());
        match.pari_a=Pari();
        match.pari_b=Pari();
        match.user_a=Utilisateur();
        match.user_b=Utilisateur();
        CollectionReference equipeCollect = await FirebaseFirestore.instance.collection('Equipes');


        CollectionReference pariCollect1 = await FirebaseFirestore.instance.collection('PariEnCours');
        QuerySnapshot querySnapshotPari1 = await pariCollect1.where("id",isEqualTo:'${match.pari_a_id}').get();

        CollectionReference pariCollect2 = await FirebaseFirestore.instance.collection('PariEnCours');
        QuerySnapshot querySnapshotPari2 = await pariCollect2.where("id",isEqualTo:'${match.pari_b_id}').get();


        CollectionReference friendCollect1 = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser1 = await friendCollect1.where("id_db",isEqualTo:'${match.user_a_id}').get();
        CollectionReference friendCollect2 = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser2 = await friendCollect2.where("id_db",isEqualTo:'${match.user_b_id}').get();

        //Paries

        List<Pari> pariList1 = querySnapshotPari1.docs.map((doc) =>
            Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();
        List<Pari> pariList2= querySnapshotPari2.docs.map((doc) =>
            Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();



        //Users
        List<Utilisateur> userList1 = querySnapshotUser1.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();
        List<Utilisateur> userList2= querySnapshotUser2.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();

        match.user_a=userList1.first;
        match.user_b=userList2.first;
        match.pari_a=pariList1.first;
        match.pari_b=pariList2.first;
        for(String eqid in  match.pari_a!.teams_id!){
          QuerySnapshot querySnapshotEquipe = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
          // Afficher la liste


          List<Equipe> teamList = querySnapshotEquipe.docs.map((doc) =>
              Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
          match.pari_a!.teams!.add(teamList.first);

        }
        for(String eqid in  match.pari_b!.teams_id!){
          QuerySnapshot querySnapshotEquipe = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
          // Afficher la liste


          List<Equipe> teamList = querySnapshotEquipe.docs.map((doc) =>
              Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
          match.pari_b!.teams!.add(teamList.first);

        }


        print("pari1 lght : ${pariList1.first.toJson()}");
        print("pari2 lght : ${pariList2.first.toJson()}");
        print("pari1 lght : ${pariList1.first.teams!.length}");
        print("pari2 lght : ${pariList2.first.teams!.length}");
        matches.add(match);
        //  listPari=paries;


      }
      yield matches.first;
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
  Future<bool> updateMatch(MatchPari matchpari,BuildContext context) async {
    try{



      await FirebaseFirestore.instance
          .collection('Matches')
          .doc(matchpari.id)
          .update(matchpari.toJson());

      return true;
    }catch(e){
      print("erreur update post : ${e}");
      return false;
    }
  }
  Future<MatchPari> getOnlyMatch(String id) async {
    //await getAppData();
    late List<MatchPari> list= [];

    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('Matches');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.where("id",isEqualTo: id!).get()
        .then((value){

      print(value);
      return value;
    }).catchError((onError){

    });

    // Get data from docs and convert map to List
    list = querySnapshot.docs.map((doc) =>
        MatchPari.fromJson(doc.data() as Map<String, dynamic>)).toList();

    MatchPari match=list.first;
    match.pari_a=Pari();
    match.pari_b=Pari();
    match.user_a=Utilisateur();
    match.user_b=Utilisateur();
    CollectionReference equipeCollect = await FirebaseFirestore.instance.collection('Equipes');


    CollectionReference pariCollect1 = await FirebaseFirestore.instance.collection('PariEnCours');
    QuerySnapshot querySnapshotPari1 = await pariCollect1.where("id",isEqualTo:'${match.pari_a_id}').get();

    CollectionReference pariCollect2 = await FirebaseFirestore.instance.collection('PariEnCours');
    QuerySnapshot querySnapshotPari2 = await pariCollect2.where("id",isEqualTo:'${match.pari_b_id}').get();


    CollectionReference friendCollect1 = await FirebaseFirestore.instance.collection('Utilisateur');
    QuerySnapshot querySnapshotUser1 = await friendCollect1.where("id_db",isEqualTo:'${match.user_a_id}').get();
    CollectionReference friendCollect2 = await FirebaseFirestore.instance.collection('Utilisateur');
    QuerySnapshot querySnapshotUser2 = await friendCollect2.where("id_db",isEqualTo:'${match.user_b_id}').get();

    //Paries

    List<Pari> pariList1 = querySnapshotPari1.docs.map((doc) =>
        Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();
    List<Pari> pariList2= querySnapshotPari2.docs.map((doc) =>
        Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();



    //Users
    List<Utilisateur> userList1 = querySnapshotUser1.docs.map((doc) =>
        Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();
    List<Utilisateur> userList2= querySnapshotUser2.docs.map((doc) =>
        Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();

    match.user_a=userList1.first;
    match.user_b=userList2.first;
    match.pari_a=pariList1.first;
    match.pari_b=pariList2.first;
    for(String eqid in  match.pari_a!.teams_id!){
      QuerySnapshot querySnapshotEquipe = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
      // Afficher la liste


      List<Equipe> teamList = querySnapshotEquipe.docs.map((doc) =>
          Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
      match.pari_a!.teams!.add(teamList.first);

    }
    for(String eqid in  match.pari_b!.teams_id!){
      QuerySnapshot querySnapshotEquipe = await equipeCollect.where("id",isEqualTo:'${eqid}').get();
      // Afficher la liste


      List<Equipe> teamList = querySnapshotEquipe.docs.map((doc) =>
          Equipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
      match.pari_b!.teams!.add(teamList.first);

    }


    print("pari1 lght : ${pariList1.first.toJson()}");
    print("pari2 lght : ${pariList2.first.toJson()}");
    print("pari1 lght : ${pariList1.first.teams!.length}");
    print("pari2 lght : ${pariList2.first.teams!.length}");
   // matches.add(match);
    //  listPari=paries;




    return match;

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

  Future<String> createTransaction(TransactionData data) async {
    String id = firestore
        .collection('Transactions')
        .doc()
        .id;
    data.id=id;

    try{
      final DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('Transactions').doc(id);
      docRef.set(data.toJson());


      //  await firestore.collection('Matches').doc(id).set(data.toJson());
      print("///////////-- SAVE transaction --///////////////");
    } on FirebaseException catch(error){

    }
    return id;
  }
  Stream<List<TransactionData>> getUserTransactionDepot(String user_id) async* {
    print("Transactions");
    var pariStream = FirebaseFirestore.instance.collection('Transactions')
    // .where("entreprise_id",isEqualTo:'${entrepriseId}')

        .where("type",isEqualTo:'${TypeTransaction.DEPOT.name}')
    // .orderBy("status")
        .where( 'user_id', isEqualTo:  user_id! )// Order by status first
        .orderBy("createdAt", descending: true)
    // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')


        .snapshots();
    List<TransactionData> transactions = [];
    listPari =[];
    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
    //  transactions = [];
      listPari =[];

      for (var trans in snapshot.docs) {
        //  print("post : ${jsonDecode(post.toString())}");
        TransactionData transactionData=TransactionData.fromJson(trans.data());

        print("trans: ${transactionData.toJson()}");

/*
        CollectionReference friendCollect = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser = await friendCollect.where("id_db",isEqualTo:'${transactionData.user_id}').get();
        // Afficher la liste




        List<Utilisateur> userList = querySnapshotUser.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();

 */

       // transactionData.user=userList.first;

        transactions.add(transactionData);
      //  listPari=paries;
        print("tl: ${transactions.length}");


      }
      yield transactions;
    }
  }

  Stream<List<TransactionData>> getUserTransactionRetrait(String user_id) async* {
    var pariStream = FirebaseFirestore.instance.collection('Transactions')
    // .where("entreprise_id",isEqualTo:'${entrepriseId}')

        .where("type",isEqualTo:'${TypeTransaction.RETRAIT.name}')
    // .orderBy("status")
        .where( 'user_id', isEqualTo:  user_id! )// Order by status first
        .orderBy("createdAt", descending: true)
    // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')


        .snapshots();
    List<TransactionData> transactions = [];
    listPari =[];
    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      transactions = [];
      listPari =[];

      for (var trans in snapshot.docs) {
        //  print("post : ${jsonDecode(post.toString())}");
        TransactionData transactionData=TransactionData.fromJson(trans.data());


        CollectionReference friendCollect = await FirebaseFirestore.instance.collection('Utilisateur');
        QuerySnapshot querySnapshotUser = await friendCollect.where("id_db",isEqualTo:'${transactionData.user_id}').get();
        // Afficher la liste


        List<Utilisateur> userList = querySnapshotUser.docs.map((doc) =>
            Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();

        // transactionData.user=userList.first;

        transactions.add(transactionData);
        //  listPari=paries;


      }
      yield transactions;
    }
  }

}

