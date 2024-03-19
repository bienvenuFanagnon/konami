import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'soccers_models.g.dart'; // Generated file name based on the class name
/* flutter pub run build_runner build */



class Match {
  Equipe equipe1;
  Equipe equipe2;
  int scoreEquipe1;
  int scoreEquipe2;
  DateTime date;

  Match(this.equipe1, this.equipe2, this.scoreEquipe1, this.scoreEquipe2,this.date);
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
    late String? id="";
    late String? user_id="";
    late String? status="";
    late int? createdAt;
   late int? updatedAt;
    late double? montant=0;
    @JsonKey(includeFromJson: false, includeToJson: false)
    late Utilisateur? user=Utilisateur();

    late List<String>? teams_id=[];
    @JsonKey(includeFromJson: false, includeToJson: false)
    late List<Equipe>? teams=[];

  Pari();

  // Add a factory constructor that creates a new instance from a JSON map
  factory Pari.fromJson(Map<String, dynamic> json) => _$PariFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$PariToJson(this);
}


@JsonSerializable()
class MatchPari {
  late String? id="";
  late String? status="";
  late int? createdAt;
  late int? updatedAt;
  late double? montant=0;
  late List<String>? pari_id=[];



  MatchPari();

  factory MatchPari.fromJson(Map<String, dynamic> json) => _$MatchPariFromJson(json);

  Map<String, dynamic> toJson() => _$MatchPariToJson(this);
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
enum PariStatus{
  DISPONIBLE,ENCOURS,PARIER
}
enum ChoixPari{
  V1,X,V2
}
