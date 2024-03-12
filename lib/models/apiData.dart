class SoccerGoal {
  SoccerGoal({
    required this.matches,
  });
  late final List<Matches> matches;

  SoccerGoal.fromJson(Map<String, dynamic> json){
    matches = List.from(json['matches']).map((e)=>Matches.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['matches'] = matches.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Matches {
  Matches({
    required this.area,
    required this.competition,
    required this.season,
    required this.id,
    required this.utcDate,
    required this.status,
    this.minute,
    this.injuryTime,
    this.attendance,
    this.venue,
    required this.matchday,
    required this.stage,
    this.group,
    required this.lastUpdated,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.goals,
    required this.penalties,
    required this.bookings,
    required this.substitutions,
    required this.odds,
    required this.referees,
  });
  late final Area area;
  late final Competition competition;
  late final Season season;
  late final int id;
  late final String utcDate;
  late final String status;
  late final String? minute;
  late final int? injuryTime;
  late final Null attendance;
  late final String? venue;
  late final int matchday;
  late final String stage;
  late final String? group;
  late final String lastUpdated;
  late final HomeTeam homeTeam;
  late final AwayTeam awayTeam;
  late final Score score;
  late final List<Goals> goals;
  late final List<Penalties> penalties;
  late final List<dynamic> bookings;
  late final List<dynamic> substitutions;
  late final Odds odds;
  late final List<Referees> referees;

  Matches.fromJson(Map<String, dynamic> json){
    area = Area.fromJson(json['area']);
    competition = Competition.fromJson(json['competition']);
    season = Season.fromJson(json['season']);
    id = json['id'];
    utcDate = json['utcDate'];
    status = json['status'];
    minute = null;
    injuryTime = null;
    attendance = null;
    venue = null;
    matchday = json['matchday'];
    stage = json['stage'];
    group = null;
    lastUpdated = json['lastUpdated'];
    homeTeam = HomeTeam.fromJson(json['homeTeam']);
    awayTeam = AwayTeam.fromJson(json['awayTeam']);
    score = Score.fromJson(json['score']);
    goals = List.from(json['goals']).map((e)=>Goals.fromJson(e)).toList();
    penalties = List.from(json['penalties']).map((e)=>Penalties.fromJson(e)).toList();
    bookings = List.castFrom<dynamic, dynamic>(json['bookings']);
    substitutions = List.castFrom<dynamic, dynamic>(json['substitutions']);
    odds = Odds.fromJson(json['odds']);
    referees = List.from(json['referees']).map((e)=>Referees.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['area'] = area.toJson();
    _data['competition'] = competition.toJson();
    _data['season'] = season.toJson();
    _data['id'] = id;
    _data['utcDate'] = utcDate;
    _data['status'] = status;
    _data['minute'] = minute;
    _data['injuryTime'] = injuryTime;
    _data['attendance'] = attendance;
    _data['venue'] = venue;
    _data['matchday'] = matchday;
    _data['stage'] = stage;
    _data['group'] = group;
    _data['lastUpdated'] = lastUpdated;
    _data['homeTeam'] = homeTeam.toJson();
    _data['awayTeam'] = awayTeam.toJson();
    _data['score'] = score.toJson();
    _data['goals'] = goals.map((e)=>e.toJson()).toList();
    _data['penalties'] = penalties.map((e)=>e.toJson()).toList();
    _data['bookings'] = bookings;
    _data['substitutions'] = substitutions;
    _data['odds'] = odds.toJson();
    _data['referees'] = referees.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Area {
  Area({
    required this.id,
    required this.name,
    required this.code,
    this.flag,
  });
  late final int id;
  late final String name;
  late final String code;
  late final String? flag;

  Area.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    code = json['code'];
    flag = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['code'] = code;
    _data['flag'] = flag;
    return _data;
  }
}

class Competition {
  Competition({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.emblem,
  });
  late final int id;
  late final String name;
  late final String code;
  late final String type;
  late final String? emblem;

  Competition.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
    emblem = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['code'] = code;
    _data['type'] = type;
    _data['emblem'] = emblem;
    return _data;
  }
}

class Season {
  Season({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    this.winner,
    required this.stages,
  });
  late final int id;
  late final String startDate;
  late final String endDate;
  late final int currentMatchday;
  late final Null winner;
  late final List<String> stages;

  Season.fromJson(Map<String, dynamic> json){
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    currentMatchday = json['currentMatchday'];
    winner = null;
    stages = List.castFrom<dynamic, String>(json['stages']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['startDate'] = startDate;
    _data['endDate'] = endDate;
    _data['currentMatchday'] = currentMatchday;
    _data['winner'] = winner;
    _data['stages'] = stages;
    return _data;
  }
}

class HomeTeam {
  HomeTeam({
    required this.id,
    required this.name,
    required this.shortName,
    this.tla,
    this.crest,
    required this.coach,
    this.leagueRank,
    this.formation,
    required this.lineup,
    required this.bench,
  });
  late final int id;
  late final String name;
  late final String shortName;
  late final String? tla;
  late final String? crest;
  late final Coach coach;
  late final int? leagueRank;
  late final String? formation;
  late final List<Lineup> lineup;
  late final List<Bench> bench;

  HomeTeam.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    shortName = json['shortName'];
    tla = null;
    crest = null;
    coach = Coach.fromJson(json['coach']);
    leagueRank = null;
    formation = null;
    lineup = List.from(json['lineup']).map((e)=>Lineup.fromJson(e)).toList();
    bench = List.from(json['bench']).map((e)=>Bench.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['shortName'] = shortName;
    _data['tla'] = tla;
    _data['crest'] = crest;
    _data['coach'] = coach.toJson();
    _data['leagueRank'] = leagueRank;
    _data['formation'] = formation;
    _data['lineup'] = lineup.map((e)=>e.toJson()).toList();
    _data['bench'] = bench.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Coach {
  Coach({
    this.id,
    this.name,
    this.nationality,
  });
  late final int? id;
  late final String? name;
  late final String? nationality;

  Coach.fromJson(Map<String, dynamic> json){
    id = null;
    name = null;
    nationality = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['nationality'] = nationality;
    return _data;
  }
}

class Lineup {
  Lineup({
    required this.id,
    required this.name,
    this.position,
    required this.shirtNumber,
  });
  late final int id;
  late final String name;
  late final String? position;
  late final int shirtNumber;

  Lineup.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    position = null;
    shirtNumber = json['shirtNumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['position'] = position;
    _data['shirtNumber'] = shirtNumber;
    return _data;
  }
}

class Bench {
  Bench({
    required this.id,
    required this.name,
    this.position,
    required this.shirtNumber,
  });
  late final int id;
  late final String name;
  late final String? position;
  late final int shirtNumber;

  Bench.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    position = null;
    shirtNumber = json['shirtNumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['position'] = position;
    _data['shirtNumber'] = shirtNumber;
    return _data;
  }
}

class AwayTeam {
  AwayTeam({
    required this.id,
    required this.name,
    required this.shortName,
    this.tla,
    required this.crest,
    required this.coach,
    this.leagueRank,
    this.formation,
    required this.lineup,
    required this.bench,
  });
  late final int id;
  late final String name;
  late final String shortName;
  late final String? tla;
  late final String crest;
  late final Coach coach;
  late final int? leagueRank;
  late final String? formation;
  late final List<Lineup> lineup;
  late final List<Bench> bench;

  AwayTeam.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    shortName = json['shortName'];
    tla = null;
    crest = json['crest'];
    coach = Coach.fromJson(json['coach']);
    leagueRank = null;
    formation = null;
    lineup = List.from(json['lineup']).map((e)=>Lineup.fromJson(e)).toList();
    bench = List.from(json['bench']).map((e)=>Bench.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['shortName'] = shortName;
    _data['tla'] = tla;
    _data['crest'] = crest;
    _data['coach'] = coach.toJson();
    _data['leagueRank'] = leagueRank;
    _data['formation'] = formation;
    _data['lineup'] = lineup.map((e)=>e.toJson()).toList();
    _data['bench'] = bench.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Score {
  Score({
    this.winner,
    required this.duration,
    required this.fullTime,
    required this.halfTime,
  });
  late final String? winner;
  late final String duration;
  late final FullTime fullTime;
  late final HalfTime halfTime;

  Score.fromJson(Map<String, dynamic> json){
    winner = null;
    duration = json['duration'];
    fullTime = FullTime.fromJson(json['fullTime']);
    halfTime = HalfTime.fromJson(json['halfTime']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['winner'] = winner;
    _data['duration'] = duration;
    _data['fullTime'] = fullTime.toJson();
    _data['halfTime'] = halfTime.toJson();
    return _data;
  }
}

class FullTime {
  FullTime({
    this.home,
    this.away,
  });
  late final int? home;
  late final int? away;

  FullTime.fromJson(Map<String, dynamic> json){
    home = null;
    away = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}

class HalfTime {
  HalfTime({
    this.home,
    this.away,
  });
  late final int? home;
  late final int? away;

  HalfTime.fromJson(Map<String, dynamic> json){
    home = null;
    away = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}

class Goals {
  Goals({
    required this.minute,
    this.injuryTime,
    required this.type,
    required this.team,
    required this.scorer,
    this.assist,
    required this.score,
  });
  late final int minute;
  late final Null injuryTime;
  late final String type;
  late final Team team;
  late final Scorer scorer;
  late final Null assist;
  late final Score score;

  Goals.fromJson(Map<String, dynamic> json){
    minute = json['minute'];
    injuryTime = null;
    type = json['type'];
    team = Team.fromJson(json['team']);
    scorer = Scorer.fromJson(json['scorer']);
    assist = null;
    score = Score.fromJson(json['score']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['minute'] = minute;
    _data['injuryTime'] = injuryTime;
    _data['type'] = type;
    _data['team'] = team.toJson();
    _data['scorer'] = scorer.toJson();
    _data['assist'] = assist;
    _data['score'] = score.toJson();
    return _data;
  }
}

class Team {
  Team({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Team.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Scorer {
  Scorer({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Scorer.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Penalties {
  Penalties({
    required this.player,
    required this.team,
    required this.scored,
  });
  late final Player player;
  late final Team team;
  late final bool scored;

  Penalties.fromJson(Map<String, dynamic> json){
    player = Player.fromJson(json['player']);
    team = Team.fromJson(json['team']);
    scored = json['scored'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['player'] = player.toJson();
    _data['team'] = team.toJson();
    _data['scored'] = scored;
    return _data;
  }
}

class Player {
  Player({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Player.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Odds {
  Odds({
    this.homeWin,
    this.draw,
    this.awayWin,
  });
  late final double? homeWin;
  late final double? draw;
  late final double? awayWin;

  Odds.fromJson(Map<String, dynamic> json){
    homeWin = null;
    draw = null;
    awayWin = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['homeWin'] = homeWin;
    _data['draw'] = draw;
    _data['awayWin'] = awayWin;
    return _data;
  }
}

class Referees {
  Referees({
    required this.id,
    required this.name,
    required this.type,
    required this.nationality,
  });
  late final int id;
  late final String name;
  late final String type;
  late final String nationality;

  Referees.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    nationality = json['nationality'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['nationality'] = nationality;
    return _data;
  }
}