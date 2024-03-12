import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'soccers_models.g.dart'; // Generated file name based on the class name
/* flutter pub run build_runner build */

@JsonSerializable()
class Matches {

  late int? id;
  late String? id_db="";
  late String? homeTeamName="";
  late String? awayTeamName="";
  late int? homeTeamId=0;
  late int? awayTeamId=0;
  late String? homeTeamLogo="";
  late String? awayTeamLogo="";
  late int? awayTeamScore;
  late int? homeTeamScore;
  late String? dateDuMatch="";
  late String? heureDuMatch="";
  late String? status="";
  late String? minute="";
  late String? competition="";




  Matches();

  // Add a factory constructor that creates a new instance from a JSON map
  factory Matches.fromJson(Map<String, dynamic> json) => _$MatchesFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$MatchesToJson(this);
}
@JsonSerializable()
class Equipe {

  late String? id="";
  late String? nom="";
  late String? logo="";





  Equipe();

  // Add a factory constructor that creates a new instance from a JSON map
  factory Equipe.fromJson(Map<String, dynamic> json) => _$EquipeFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$EquipeToJson(this);
}

@JsonSerializable()
class Utilisateur {

  late String? id_db="";
  late String? nom="";
  late String? codeSecurity="";
  late String? phoneNumber="";
  late String? pays="";
  late double montant=0;


  Utilisateur();

  // Add a factory constructor that creates a new instance from a JSON map
  factory Utilisateur.fromJson(Map<String, dynamic> json) => _$UtilisateurFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$UtilisateurToJson(this);
}

@JsonSerializable()
class Pari {
    late String? id_db="";
  late String? homeTeamLogo="";
  late String? awayTeamLogo="";
   late String? homeTeamName="";
  late String? awayTeamName="";
    late String? dateDuMatch="";
  late String? heureDuMatch="";
    late String? competition="";

  late String? id_home_user="";
  late String? id_user="";
  late String? id_away_user="";
  late int? home_score=0;
  late int? away_score=0;
  late String? typePari="";
  late String? id_match="";
  late String? user_home_pari=null;
  late String? user_away_pari=null;
  late double? prix=0;
  late String? winner =null;
  late String? status ="";





  Pari();

  // Add a factory constructor that creates a new instance from a JSON map
  factory Pari.fromJson(Map<String, dynamic> json) => _$PariFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$PariToJson(this);
}


@JsonSerializable()
class VerificationDuLancement {
  late String? id_db="";
  late String? date="${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  late bool? lancer=false;


  VerificationDuLancement();

  factory VerificationDuLancement.fromJson(Map<String, dynamic> json) => _$VerificationDuLancementFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationDuLancementToJson(this);
}
@JsonSerializable()
class MiseAJourMatches {
  late String? id_db="";
late int? nombre=0;


  MiseAJourMatches();

  factory MiseAJourMatches.fromJson(Map<String, dynamic> json) => _$MiseAJourMatchesFromJson(json);

  Map<String, dynamic> toJson() => _$MiseAJourMatchesToJson(this);
}

enum MatchStatus{
IN_PLAY,PAUSED,FINISHED,SUSPENDED,CANCELLED,TIMED
}
enum TypePari{
  VICTOIRE,TOTAL_TEAM,TEAM_A,TEAM_B
}
enum ChoixPari{
  V1,X,V2
}
