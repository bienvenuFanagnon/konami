// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soccers_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equipe _$EquipeFromJson(Map<String, dynamic> json) => Equipe()
  ..id = json['id'] as String?
  ..nom = json['nom'] as String?
  ..logo = json['logo'] as String?;

Map<String, dynamic> _$EquipeToJson(Equipe instance) => <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'logo': instance.logo,
    };

AppData _$AppDataFromJson(Map<String, dynamic> json) => AppData()
  ..id = json['id'] as String
  ..emailConatct = json['emailConatct'] as String
  ..phoneConatct = json['phoneConatct'] as String
  ..app_link = json['app_link'] as String
  ..app_version_code = json['app_version_code'] as int
  ..app_is_valide = json['app_is_valide'] as bool
  ..videos =
      (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..soldeTotal = (json['soldeTotal'] as num).toDouble()
  ..adminSolde = (json['adminSolde'] as num).toDouble()
  ..nombre_parrainage = json['nombre_parrainage'] as int;

Map<String, dynamic> _$AppDataToJson(AppData instance) => <String, dynamic>{
      'id': instance.id,
      'emailConatct': instance.emailConatct,
      'phoneConatct': instance.phoneConatct,
      'app_link': instance.app_link,
      'app_version_code': instance.app_version_code,
      'app_is_valide': instance.app_is_valide,
      'videos': instance.videos,
      'soldeTotal': instance.soldeTotal,
      'adminSolde': instance.adminSolde,
      'nombre_parrainage': instance.nombre_parrainage,
    };

Information _$InformationFromJson(Map<String, dynamic> json) => Information()
  ..id = json['id'] as String?
  ..media_url = json['media_url'] as String?
  ..type = json['type'] as String?
  ..titre = json['titre'] as String?
  ..status = json['status'] as String?
  ..description = json['description'] as String?
  ..createdAt = json['createdAt'] as int?
  ..updatedAt = json['updatedAt'] as int?;

Map<String, dynamic> _$InformationToJson(Information instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_url': instance.media_url,
      'type': instance.type,
      'titre': instance.titre,
      'status': instance.status,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Utilisateur _$UtilisateurFromJson(Map<String, dynamic> json) => Utilisateur(
      id_db: json['id_db'] as String? ?? "",
      pseudo: json['pseudo'] as String? ?? "",
      oneIgnalUserid: json['oneIgnalUserid'] as String? ?? "",
      nom: json['nom'] as String? ?? "",
      photo: json['photo'] as String? ?? "",
      pay_phone: json['pay_phone'] as String? ?? "",
      pay_prefix_phone: json['pay_prefix_phone'] as String? ?? "",
      carte_identite: json['carte_identite'] as String? ?? "",
      demande_partenaire: json['demande_partenaire'] as String? ?? "",
      numero_carte_identite: json['numero_carte_identite'] as String? ?? "",
      code_parrain: json['code_parrain'] as String? ?? "",
      code_user_parrainage: json['code_user_parrainage'] as String? ?? "",
      prenom: json['prenom'] as String? ?? "",
      codePinSecurity: json['codePinSecurity'] as String? ?? "",
      haveCodeSecurity: json['haveCodeSecurity'] as bool? ?? false,
      is_valide: json['is_valide'] as bool? ?? false,
      is_blocked: json['is_blocked'] as bool? ?? false,
      is_partenaire: json['is_partenaire'] as bool? ?? false,
      retrait_is_valide: json['retrait_is_valide'] as bool? ?? true,
      phoneNumber: json['phoneNumber'] as String? ?? "",
      nombre_retrait: json['nombre_retrait'] as int? ?? 0,
      nombre_depot: json['nombre_depot'] as int? ?? 0,
      nombre_parrainage: json['nombre_parrainage'] as int? ?? 0,
      nombre_pari_parrainage: json['nombre_pari_parrainage'] as int? ?? 0,
      pays: json['pays'] as String? ?? "",
      region: json['region'] as String? ?? "",
      ville: json['ville'] as String? ?? "",
      role: json['role'] as String? ?? "",
      montant: (json['montant'] as num?)?.toDouble() ?? 0,
      montant_compte_parrain:
          (json['montant_compte_parrain'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$UtilisateurToJson(Utilisateur instance) =>
    <String, dynamic>{
      'id_db': instance.id_db,
      'pseudo': instance.pseudo,
      'nom': instance.nom,
      'photo': instance.photo,
      'oneIgnalUserid': instance.oneIgnalUserid,
      'carte_identite': instance.carte_identite,
      'numero_carte_identite': instance.numero_carte_identite,
      'code_parrain': instance.code_parrain,
      'code_user_parrainage': instance.code_user_parrainage,
      'prenom': instance.prenom,
      'codePinSecurity': instance.codePinSecurity,
      'haveCodeSecurity': instance.haveCodeSecurity,
      'is_valide': instance.is_valide,
      'retrait_is_valide': instance.retrait_is_valide,
      'is_blocked': instance.is_blocked,
      'is_partenaire': instance.is_partenaire,
      'phoneNumber': instance.phoneNumber,
      'pay_phone': instance.pay_phone,
      'pay_prefix_phone': instance.pay_prefix_phone,
      'demande_partenaire': instance.demande_partenaire,
      'nombre_retrait': instance.nombre_retrait,
      'nombre_depot': instance.nombre_depot,
      'nombre_parrainage': instance.nombre_parrainage,
      'nombre_pari_parrainage': instance.nombre_pari_parrainage,
      'pays': instance.pays,
      'region': instance.region,
      'ville': instance.ville,
      'role': instance.role,
      'montant': instance.montant,
      'montant_compte_parrain': instance.montant_compte_parrain,
    };

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    TransactionData()
      ..id = json['id'] as String
      ..user_id = json['user_id'] as String
      ..type = json['type'] as String
      ..type_compte = json['type_compte'] as String
      ..depotType = json['depotType'] as String
      ..montant = (json['montant'] as num).toDouble()
      ..createdAt = json['createdAt'] as int?
      ..updatedAt = json['updatedAt'] as int?
      ..status = json['status'] as String;

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'type': instance.type,
      'type_compte': instance.type_compte,
      'depotType': instance.depotType,
      'montant': instance.montant,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'status': instance.status,
    };

Pari _$PariFromJson(Map<String, dynamic> json) => Pari()
  ..id = json['id'] as String?
  ..user_id = json['user_id'] as String?
  ..resultStatus = json['resultStatus'] as String?
  ..status = json['status'] as String?
  ..createdAt = json['createdAt'] as int?
  ..updatedAt = json['updatedAt'] as int?
  ..score = json['score'] as int?
  ..montant = (json['montant'] as num?)?.toDouble()
  ..teams_id =
      (json['teams_id'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$PariToJson(Pari instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'resultStatus': instance.resultStatus,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'score': instance.score,
      'montant': instance.montant,
      'teams_id': instance.teams_id,
    };

MatchPari _$MatchPariFromJson(Map<String, dynamic> json) => MatchPari()
  ..id = json['id'] as String?
  ..status = json['status'] as String?
  ..pari_a_id = json['pari_a_id'] as String?
  ..pari_b_id = json['pari_b_id'] as String?
  ..user_a_id = json['user_a_id'] as String?
  ..user_b_id = json['user_b_id'] as String?
  ..createdAt = json['createdAt'] as int?
  ..updatedAt = json['updatedAt'] as int?
  ..montant = (json['montant'] as num?)?.toDouble()
  ..pari_id =
      (json['pari_id'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$MatchPariToJson(MatchPari instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'pari_a_id': instance.pari_a_id,
      'pari_b_id': instance.pari_b_id,
      'user_a_id': instance.user_a_id,
      'user_b_id': instance.user_b_id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'montant': instance.montant,
      'pari_id': instance.pari_id,
    };

Pseudo _$PseudoFromJson(Map<String, dynamic> json) => Pseudo()
  ..id = json['id'] as String?
  ..nom = json['nom'] as String?;

Map<String, dynamic> _$PseudoToJson(Pseudo instance) => <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
    };
