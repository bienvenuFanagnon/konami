
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:konami_bet/providers/providers.dart';
import 'package:konami_bet/services/database.dart';
import 'package:konami_bet/services/soccer_services.dart';


class FootballDataApi {
  late String _apiKey = '6ae93266edb044b1aea56c67e80438cb';
  late String _baseUrl = 'http://api.football-data.org/v4/matches';
  late FootballDataApi footballDataApi = FootballDataApi();
  late  ServiceProvider serviceProvider=ServiceProvider();
  late VerificationDuLancementService verificationDuLancementService = VerificationDuLancementService();
  late MiseAJourMatchesService miseAJourMatchesService = MiseAJourMatchesService();
  late MatchService matchService = MatchService();
  late PariService pariService = PariService();

  late List<Matches> listMatchApi=[];
  late Utilisateur userVerify =Utilisateur();
  late UtilisateurService utilisateurService = UtilisateurService();

   Future<List<Matches>> fetchSoccerList() async {
   //  matchService.deleteAllData();
     late List<Matches> listMatch=[];
     // Désactiver la vérification SSL
    try{
      final response = await http.get(Uri.parse('$_baseUrl'),
        headers:{
          'Access-Control-Allow-Origin': '*',
          'X-Auth-Token': _apiKey,},

      );

      if (response.statusCode == 200) {

        // JSON data string
        Map<String, dynamic> jsonMap = jsonDecode(response.body); // Convert to a Map
        // Create a new Match instance
        print("++++ fetch soccer ++");
        print(jsonMap['matches'].toString());
        //SoccerGoal soccerGoal=SoccerGoal.fromJson(jsonMap);
       
        for (final item in jsonMap['matches']) {
          Matches match = Matches();
          match.id=item['id'];
          match.status=item['status'];
          match.minute=item['minute'];
          match.competition=item['competition']['name'];
          match.homeTeamName=item['homeTeam']['shortName'];
          match.homeTeamLogo=item['homeTeam']['crest'];
          match.homeTeamId=item['homeTeam']['id'];
          match.homeTeamScore=item['score']['fullTime']['home'];
          match.dateDuMatch=item['utcDate'];
          match.awayTeamName=item['awayTeam']['shortName'];
          match.awayTeamLogo=item['awayTeam']['crest'];
          match.awayTeamId=item['awayTeam']['id'];
          match.awayTeamScore=item['score']['fullTime']['away'];
          listMatch.add(match);


          // print(match.toString());
        }



      }
      else {
        throw Exception('Failed to load soccer list');
      }
    }catch(e){
      print("erreur//////////////////////////");
      print(e.toString());

    }
    return listMatch;
  }

  apiDataToDataBase() async {
     print("api data to database ");
    List<Matches> listMatchDb = [];
    listMatchDb = await matchService.getAllMatches();
    bool isUpdate=false;
     //matchService.deleteAllData();

    if(listMatchDb.isNotEmpty){
      //mise a jours
      if(listMatchDb[0].id_db!.length!>5){
        listMatchApi = await  fetchSoccerList();

        if (listMatchApi.isNotEmpty) {
           print("api data is already ");



          for (final item2 in  listMatchDb  ) {

        int trouver= isIdMatched( listMatchApi,item2);


              if (trouver!=-1) {
                print("match  existe dans api");
                Matches match =listMatchApi.elementAt(trouver);
                match.id_db = item2.id_db;
                 matchService.update(match.id_db!, match.toJson());
                isUpdate=true;
                if (match.status == MatchStatus.FINISHED!.name!) {
                  //les matches fini
                //  serviceProvider.deleteMatchFinished(match.id_db!);
                  print("match  fini dans api");
                }
                if (match.status == MatchStatus.CANCELLED!.name! ||
                    match.status == MatchStatus.SUSPENDED!.name!) {
                  //matche annuler
                 // serviceProvider.deleteMatchFinished(match.id_db!);
                   print("match  annuler dans api");
                }

              }
              else{
                print("match n existe pas dans api");
                Matches histoMatch =await getMatchById(item2.id!);
                 serviceProvider.deleteMatchFinished(item2.id_db!);
                 
          for (final item in listMatchApi) {

        int trouver= isIdMatched( listMatchDb,item2);
         if (trouver==-1) {
          await matchService.create(item);

         }

          }
                if(histoMatch!=null){
                  //mise a jour de pari sil existe
                  print("save match in historique doc");

                }else{
                  //serviceProvider.deleteMatchFinished(item2.id_db!);
               // await matchService.create(listMatchApi.elementAt(trouver));
                }

               
                



              }

          }
       
        }else{
          print("pas de donnee de l api");
        }

      }else{
         print("supprimer tous les matchs");
        //supprimer tout les matches
        matchService.deleteAllData();
        //creer des match
        listMatchApi = await  fetchSoccerList();
        if(listMatchApi.isNotEmpty){
          for(final item in listMatchApi){
            await matchService.create(item);
          }
        }


      }


    }
    else{
      //creer des match
      listMatchApi = await  fetchSoccerList();
      if(listMatchApi.isNotEmpty){
        for(final item in listMatchApi){
          await matchService.create(item);
        }
      }
    }


  }

  int isIdMatched(List<Matches> list1, Matches match) {
    int trouver =-1;
    for (final item1 in list1) {

        if (item1.id == match.id) {
          list1.indexOf(item1);
         trouver= list1.indexOf(item1);
          return trouver;
        }

    }
    return trouver;
  }



  Future<Matches> getMatchById(int matchId) async {
    print("matches id : $matchId");

    final String apiKey = '6ae93266edb044b1aea56c67e80438cb'; // Remplacez YOUR_API_KEY par votre clé d'API Football Data
    final String apiUrl = 'https://api.football-data.org/v4/matches/$matchId';
    late List<Matches> listMatch=[];
     Matches match = Matches();

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Access-Control-Allow-Origin': '*',
        
        'X-Auth-Token': apiKey},
    );

    if (response.statusCode == 200) {
      // JSON data string
      print("get matches api by id");
     
     
      Map<String, dynamic> jsonMap = jsonDecode(response.body); // Convert to a Map
      // Create a new Match instance
       print("Matches: ");
      print(jsonMap.toString());
      //SoccerGoal soccerGoal=SoccerGoal.fromJson(jsonMap);
    
     if (jsonMap!=null) {
      match = Matches();
       final item = jsonMap;
       
        match.id=item['id'];
        match.status=item['status'];
        match.minute=item['minute'];
        match.competition=item['competition']['name'];
        match.homeTeamName=item['homeTeam']['shortName'];
        match.homeTeamLogo=item['homeTeam']['crest'];
        match.homeTeamId=item['homeTeam']['id'];
        match.homeTeamScore=item['score']['fullTime']['home'];
        match.dateDuMatch=item['utcDate'];
        match.awayTeamName=item['awayTeam']['shortName'];
        match.awayTeamLogo=item['awayTeam']['crest'];
        match.awayTeamId=item['awayTeam']['id'];
        match.awayTeamScore=item['score']['fullTime']['away'];
        


        // print(match.toString());
      }
       
     
      return match;
    } else {
      throw Exception('Failed to load match');
    }
  }


}