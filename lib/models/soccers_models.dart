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
class AppData {
  late String id;
  late String emailConatct;
  late bool app_is_valide=true;
// "en attente", "validé", "rejeté"
// "depot" ou "retrait"
  late double soldeTotal;
  late double adminSolde;
late int nombre_parrainage=20;


  AppData();

  // Add a factory constructor that creates a new instance from a JSON map
  factory AppData.fromJson(Map<String, dynamic> json) => _$AppDataFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$AppDataToJson(this);
}

@JsonSerializable()
class Information {
  String? id;
  String? media_url;
  String? type;
  String? titre;
  String? status;
  String? description;

  int? createdAt;
  int? updatedAt;


  Information();

  // Add a factory constructor that creates a new instance from a JSON map
  factory Information.fromJson(Map<String, dynamic> json) => _$InformationFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$InformationToJson(this);
}

@JsonSerializable()
class Utilisateur {

  late String? id_db="";
  late String? pseudo="";
  late String? nom="";
  late String? photo="";
  late String? carte_identite="";
  late String? numero_carte_identite="";
  late String? code_parrain="";
  late String? code_user_parrainage="";
  late String? prenom="";
  late String? codePinSecurity="";
  late bool? haveCodeSecurity=false;
  late bool? is_valide=false;
  late bool? retrait_is_valide=true;
  late bool? is_blocked=false;
  late bool? is_partenaire=false;
  late String? phoneNumber="";
  late String? demande_partenaire="";
  late int? nombre_retrait=0;
  late int? nombre_depot=0;
  late int? nombre_parrainage=0;
  late int? nombre_pari_parrainage=0;
  late String? pays="";
  late String? region="";
  late String? ville="";
  late String? role="";
  late double montant=0;
  late double montant_compte_parrain=0;


  Utilisateur({
    this.id_db = "",
    this.pseudo = "",
    this.nom = "",
    this.photo = "",
    this.carte_identite = "",
    this.demande_partenaire = "",
    this.numero_carte_identite = "",
    this.code_parrain = "",
    this.code_user_parrainage = "",
    this.prenom = "",
    this.codePinSecurity = "",
    this.haveCodeSecurity = false,
    this.is_valide = false,
    this.is_blocked = false,
    this.is_partenaire = false,
    this.retrait_is_valide = true,
    this.phoneNumber = "",
    this.nombre_retrait = 0,
    this.nombre_depot = 0,
    this.nombre_parrainage = 0,
    this.nombre_pari_parrainage = 0,
    this.pays = "",
    this.region = "",
    this.ville = "",
    this.role = "",
    this.montant = 0,
    this.montant_compte_parrain = 0,
  });

  // Add a factory constructor that creates a new instance from a JSON map
  factory Utilisateur.fromJson(Map<String, dynamic> json) => _$UtilisateurFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$UtilisateurToJson(this);
}

@JsonSerializable()
class TransactionData {
  late String id;
  late String user_id;
  late String type;
  late String type_compte;
  late String depotType; // "en attente", "validé", "rejeté"
// "depot" ou "retrait"
  late double montant;
  late int? createdAt;
  late int? updatedAt;
  late String status; // "en attente", "validé", "rejeté"



  TransactionData();

  // Add a factory constructor that creates a new instance from a JSON map
  factory TransactionData.fromJson(Map<String, dynamic> json) => _$TransactionDataFromJson(json);

  // Add a method that converts this instance to a JSON map
  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}

@JsonSerializable()
class Pari {
    late String? id="";
    late String? user_id="";
    late String? resultStatus="";

    late String? status="";
    late int? createdAt;
   late int? updatedAt;
   late int? score=0;
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
  late String? pari_a_id="";
  late String? pari_b_id="";
  late String? user_a_id="";
  late String? user_b_id="";
  @JsonKey(includeFromJson: false, includeToJson: false)
  late Pari? pari_a;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late Pari? pari_b;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late Utilisateur? user_a;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late Utilisateur? user_b;
  late int? createdAt;
  late int? updatedAt;
  late double? montant=0;
  late List<String>? pari_id=[];



  MatchPari();

  factory MatchPari.fromJson(Map<String, dynamic> json) => _$MatchPariFromJson(json);

  Map<String, dynamic> toJson() => _$MatchPariToJson(this);
}
@JsonSerializable()
class Pseudo {
  late String? id="";
  late String? nom="";


  Pseudo();

  factory Pseudo.fromJson(Map<String, dynamic> json) => _$PseudoFromJson(json);

  Map<String, dynamic> toJson() => _$PseudoToJson(this);
}

enum MatchStatus{
IN_PLAY,FINISHED,CANCELLED,ENCOURS,ATTENTE
}
enum TypePari{
  VICTOIRE,TOTAL_TEAM,TEAM_A,TEAM_B
}
enum PariStatus{
  DISPONIBLE,ENCOURS,ATTENTE,PARIER
}
enum TransactionStatus{
  ENCOURS,VALIDER,ANNULER
}
enum TypeTransaction{
  DEPOT,RETRAIT
}
enum TypeTranDepot{
  INTERNE,EXTERNE
}
enum PariResultStatus{
  GAGNER,PERDU,NAN
}
enum TypeCompte{
  PARTICULIER,PARTENAIRE
}

enum RoleUser{
  ADMIN,USER,SUPERADMIN
}
enum StatusDemandePartenaire{
  ACCEPTER,ENCOURS,REFUSER,NAN
}
