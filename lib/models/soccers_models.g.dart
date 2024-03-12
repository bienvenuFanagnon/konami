// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soccers_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Matches _$MatchesFromJson(Map<String, dynamic> json) => Matches()
  ..id = json['id'] as int?
  ..id_db = json['id_db'] as String?
  ..homeTeamName = json['homeTeamName'] as String?
  ..awayTeamName = json['awayTeamName'] as String?
  ..homeTeamId = json['homeTeamId'] as int?
  ..awayTeamId = json['awayTeamId'] as int?
  ..homeTeamLogo = json['homeTeamLogo'] as String?
  ..awayTeamLogo = json['awayTeamLogo'] as String?
  ..awayTeamScore = json['awayTeamScore'] as int?
  ..homeTeamScore = json['homeTeamScore'] as int?
  ..dateDuMatch = json['dateDuMatch'] as String?
  ..heureDuMatch = json['heureDuMatch'] as String?
  ..status = json['status'] as String?
  ..minute = json['minute'] as String?
  ..competition = json['competition'] as String?;

Map<String, dynamic> _$MatchesToJson(Matches instance) => <String, dynamic>{
      'id': instance.id,
      'id_db': instance.id_db,
      'homeTeamName': instance.homeTeamName,
      'awayTeamName': instance.awayTeamName,
      'homeTeamId': instance.homeTeamId,
      'awayTeamId': instance.awayTeamId,
      'homeTeamLogo': instance.homeTeamLogo,
      'awayTeamLogo': instance.awayTeamLogo,
      'awayTeamScore': instance.awayTeamScore,
      'homeTeamScore': instance.homeTeamScore,
      'dateDuMatch': instance.dateDuMatch,
      'heureDuMatch': instance.heureDuMatch,
      'status': instance.status,
      'minute': instance.minute,
      'competition': instance.competition,
    };

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
  ..id_db = json['id_db'] as String?
  ..homeTeamLogo = json['homeTeamLogo'] as String?
  ..awayTeamLogo = json['awayTeamLogo'] as String?
  ..homeTeamName = json['homeTeamName'] as String?
  ..awayTeamName = json['awayTeamName'] as String?
  ..dateDuMatch = json['dateDuMatch'] as String?
  ..heureDuMatch = json['heureDuMatch'] as String?
  ..competition = json['competition'] as String?
  ..id_home_user = json['id_home_user'] as String?
  ..id_user = json['id_user'] as String?
  ..id_away_user = json['id_away_user'] as String?
  ..home_score = json['home_score'] as int?
  ..away_score = json['away_score'] as int?
  ..typePari = json['typePari'] as String?
  ..id_match = json['id_match'] as String?
  ..user_home_pari = json['user_home_pari'] as String?
  ..user_away_pari = json['user_away_pari'] as String?
  ..prix = (json['prix'] as num?)?.toDouble()
  ..winner = json['winner'] as String?
  ..status = json['status'] as String?;

Map<String, dynamic> _$PariToJson(Pari instance) => <String, dynamic>{
      'id_db': instance.id_db,
      'homeTeamLogo': instance.homeTeamLogo,
      'awayTeamLogo': instance.awayTeamLogo,
      'homeTeamName': instance.homeTeamName,
      'awayTeamName': instance.awayTeamName,
      'dateDuMatch': instance.dateDuMatch,
      'heureDuMatch': instance.heureDuMatch,
      'competition': instance.competition,
      'id_home_user': instance.id_home_user,
      'id_user': instance.id_user,
      'id_away_user': instance.id_away_user,
      'home_score': instance.home_score,
      'away_score': instance.away_score,
      'typePari': instance.typePari,
      'id_match': instance.id_match,
      'user_home_pari': instance.user_home_pari,
      'user_away_pari': instance.user_away_pari,
      'prix': instance.prix,
      'winner': instance.winner,
      'status': instance.status,
    };

VerificationDuLancement _$VerificationDuLancementFromJson(
        Map<String, dynamic> json) =>
    VerificationDuLancement()
      ..id_db = json['id_db'] as String?
      ..date = json['date'] as String?
      ..lancer = json['lancer'] as bool?;

Map<String, dynamic> _$VerificationDuLancementToJson(
        VerificationDuLancement instance) =>
    <String, dynamic>{
      'id_db': instance.id_db,
      'date': instance.date,
      'lancer': instance.lancer,
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
