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

Utilisateur _$UtilisateurFromJson(Map<String, dynamic> json) => Utilisateur()
  ..id_db = json['id_db'] as String?
  ..nom = json['nom'] as String?
  ..codeSecurity = json['codeSecurity'] as String?
  ..phoneNumber = json['phoneNumber'] as String?
  ..pays = json['pays'] as String?
  ..montant = (json['montant'] as num).toDouble();

Map<String, dynamic> _$UtilisateurToJson(Utilisateur instance) =>
    <String, dynamic>{
      'id_db': instance.id_db,
      'nom': instance.nom,
      'codeSecurity': instance.codeSecurity,
      'phoneNumber': instance.phoneNumber,
      'pays': instance.pays,
      'montant': instance.montant,
    };

Pari _$PariFromJson(Map<String, dynamic> json) => Pari()
  ..id = json['id'] as String?
  ..user_id = json['user_id'] as String?
  ..status = json['status'] as String?
  ..createdAt = json['createdAt'] as int?
  ..updatedAt = json['updatedAt'] as int?
  ..montant = (json['montant'] as num?)?.toDouble()
  ..teams_id =
      (json['teams_id'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$PariToJson(Pari instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
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

MiseAJourMatches _$MiseAJourMatchesFromJson(Map<String, dynamic> json) =>
    MiseAJourMatches()
      ..id_db = json['id_db'] as String?
      ..nombre = json['nombre'] as int?;

Map<String, dynamic> _$MiseAJourMatchesToJson(MiseAJourMatches instance) =>
    <String, dynamic>{
      'id_db': instance.id_db,
      'nombre': instance.nombre,
    };
