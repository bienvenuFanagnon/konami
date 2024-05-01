import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../models/soccers_models.dart';
import '../providers/equipe_provider.dart';
import '../providers/providers.dart';
import 'dart:math' as math;

class MatchLive extends StatefulWidget {
  final MatchPari match;
  final String urlVideo;
  const MatchLive({super.key, required this.match, required this.urlVideo});

  @override
  State<MatchLive> createState() => _MatchState();
}

class _MatchState extends State<MatchLive> with SingleTickerProviderStateMixin {
  int genererScoreAleatoire() {
    Random random = Random();
    return random.nextInt(30);
  }

  late VideoPlayerController _video_controller;
  bool _isPlaying = false;
  late AnimationController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
      Provider.of<EquipeProvider>(context, listen: false);
  bool onTap = false;
  late String videoUrl1 =
      "https://firebasestorage.googleapis.com/v0/b/konami-bet.appspot.com/o/soccer_media%2FRoboCup2023SoccerSimulation2DFinal.mp4?alt=media&token=6844c22e-963c-4e0a-bea9-a4cf248e6b81";
  late String videoUrl =
      "https://firebasestorage.googleapis.com/v0/b/konami-bet.appspot.com/o/soccer_media%2Fsoccer_v1.mp4?alt=media&token=16cba566-5c94-4c21-b66e-499953f41d56";

  @override
  void initState() {
    // TODO: implement
    _video_controller =
        VideoPlayerController.contentUri(Uri.parse(widget.urlVideo!));
    _video_controller.setVolume(0.0);

    _initializeVideoPlayerFuture = _video_controller.initialize().then((_) {});

    super.initState();

    _isPlaying = true;
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _video_controller.dispose();
    super.dispose();
  }

  void _startPlaying() {
    setState(() {
      _isPlaying = true;
      _video_controller.play();
    });

    // Arrête automatiquement la lecture après 20 secondes
    Timer(Duration(seconds: 20), () {
      setState(() {
        _isPlaying = false;
        _video_controller.pause();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Match'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: StreamBuilder(
              stream: equipeProvider.getOnLyStreamMatch(widget.match.id!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  MatchPari match = snapshot.data;
                  if (match.status == MatchStatus.ENCOURS.name) {
                    _video_controller.setLooping(true);

                    _video_controller.play();
                  }
                  return Container(
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Si vous lancez le jeu, restez sur la page jusqu'à la fin des matches (30 sec).",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10),
                              )),
                        ),
                        Card(
                          color: Colors.transparent.withOpacity(0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${match.status}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(200))),
                                    width: width * 0.8,
                                    height: height * 0.28,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20))),
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            trailing: Text(
                                              "Equipes B",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                            leading: Text(
                                              "Equipes A",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    child: Image.network(
                                                      "${match.pari_a!.teams![0].logo!}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "VS",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    child: Image.network(
                                                      "${match.pari_b!.teams![0].logo!}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    child: Image.network(
                                                      "${match.pari_a!.teams![1].logo!}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "VS",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    child: Image.network(
                                                      "${match.pari_b!.teams![1].logo!}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    child: Image.network(
                                                      "${match.pari_a!.teams![2].logo!}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "VS",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    child: Image.network(
                                                      "${match.pari_b!.teams![2].logo!}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Score Total",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            "${match.pari_a!.score == null ? 0 : match.pari_a!.score}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                          match.user_a_id !=
                                                  serviceProvider
                                                      .loginUser.id_db
                                              ? Text(
                                                  "Adverse",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                )
                                              : Text(
                                                  "Vous",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                          match.pari_a!.resultStatus ==
                                                  PariResultStatus.PERDU.name
                                              ? Text(
                                                  "Perdu",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                )
                                              : match.pari_a!.resultStatus ==
                                                      PariResultStatus
                                                          .GAGNER.name
                                                  ? Text(
                                                      "Gagné",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    )
                                                  : Text(
                                                      "nan",
                                                      style: TextStyle(
                                                          color: Colors.white60,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Score Total",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            "${match.pari_b!.score == null ? 0 : match.pari_b!.score}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                          match.user_b_id !=
                                                  serviceProvider
                                                      .loginUser.id_db
                                              ? Text(
                                                  "Adverse",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                )
                                              : Text(
                                                  "Vous",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                          match.pari_b!.resultStatus ==
                                                  PariResultStatus.PERDU.name
                                              ? Text(
                                                  "Perdu",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                )
                                              : match.pari_b!.resultStatus ==
                                                      PariResultStatus
                                                          .GAGNER.name
                                                  ? Text(
                                                      "Gagné",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    )
                                                  : Text(
                                                      "nan",
                                                      style: TextStyle(
                                                          color: Colors.white60,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent.withOpacity(0.2),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Ionicons.time_outline,
                                      color: match.status ==
                                              MatchStatus.ENCOURS.name
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                    match.status == MatchStatus.FINISHED.name
                                        ? Text(
                                            "Fin",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          )
                                        : match.status ==
                                                MatchStatus.ENCOURS.name
                                            ? TimerCountdown(
                                                enableDescriptions: false,
                                                timeTextStyle: TextStyle(
                                                  color: match.status ==
                                                          MatchStatus
                                                              .ENCOURS.name
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                format: CountDownTimerFormat
                                                    .secondsOnly,
                                                endTime: DateTime.now().add(
                                                  Duration(
                                                    seconds: 30,
                                                  ),
                                                ),
                                                onEnd: () async {
                                                  _video_controller.pause();
                                                  //_video_controller.dispose();

                                                  await equipeProvider
                                                      .getOnlyMatch(match.id!)
                                                      .then(
                                                    (value) async {
                                                      if (value.status !=
                                                          MatchStatus
                                                              .FINISHED.name) {
                                                        match.status =
                                                            MatchStatus
                                                                .FINISHED.name;
                                                        await equipeProvider
                                                            .updateMatch(
                                                            match, context);
                                                        match.pari_a!.score =
                                                            genererScoreAleatoire();
                                                        match.pari_b!.score =
                                                            genererScoreAleatoire();
                                                        while (match.pari_a!
                                                                .score ==
                                                            match.pari_b!
                                                                .score) {
                                                          match.pari_a!.score =
                                                              genererScoreAleatoire();
                                                          match.pari_b!.score =
                                                              genererScoreAleatoire();
                                                        }
                                                        if (match.pari_a!
                                                                .score! >
                                                            match.pari_b!
                                                                .score!) {
                                                          await serviceProvider
                                                              .getMatchUserById(
                                                                  match.pari_a!
                                                                      .user_id!,
                                                                  context)
                                                              .then(
                                                            (user) async {
                                                              // print("avant : ${user.montant}");
                                                              double gain = ((match
                                                                          .montant! *
                                                                      2) -
                                                                  0.1 *
                                                                      (match.montant! *
                                                                          2));

                                                              user.montant =
                                                                  user.montant +
                                                                      gain;
                                                              //  print("apres : ${user.montant}");
                                                              await serviceProvider
                                                                  .updateUser(
                                                                      user,
                                                                      context);

                                                              TransactionData
                                                                  transaction =
                                                                  TransactionData(
                                                                      // Pending, validated, or rejected
                                                                      );
                                                              //transaction.id="";
                                                              transaction
                                                                      .user_id =
                                                                  user.id_db!;
                                                              transaction.type =
                                                                  TypeTransaction
                                                                      .DEPOT
                                                                      .name;
                                                              transaction
                                                                      .depotType =
                                                                  TypeTranDepot
                                                                      .INTERNE
                                                                      .name;
                                                              transaction
                                                                      .type_compte =
                                                                  TypeCompte
                                                                      .PARTICULIER
                                                                      .name;

                                                              transaction
                                                                      .montant =
                                                                  gain;
                                                              transaction
                                                                      .status =
                                                                  TransactionStatus
                                                                      .VALIDER
                                                                      .name;
                                                              transaction
                                                                      .createdAt =
                                                                  DateTime.now()
                                                                      .millisecondsSinceEpoch;
                                                              transaction
                                                                      .updatedAt =
                                                                  DateTime.now()
                                                                      .millisecondsSinceEpoch;
                                                              await equipeProvider
                                                                  .createTransaction(
                                                                      transaction);
                                                            },
                                                          );

                                                          match.pari_a!
                                                                  .resultStatus =
                                                              PariResultStatus
                                                                  .GAGNER.name;
                                                          match.pari_b!
                                                                  .resultStatus =
                                                              PariResultStatus
                                                                  .PERDU.name;
                                                        } else {
                                                          await serviceProvider
                                                              .getMatchUserById(
                                                                  match.pari_b!
                                                                      .user_id!,
                                                                  context)
                                                              .then(
                                                            (user) async {
                                                              // print("avant : ${user.montant}");
                                                              double gain = ((match
                                                                          .montant! *
                                                                      2) -
                                                                  0.1 *
                                                                      (match.montant! *
                                                                          2));

                                                              user.montant =
                                                                  user.montant +
                                                                      gain;
                                                              //   print("apres : ${user.montant}");
                                                              await serviceProvider
                                                                  .updateUser(
                                                                      user,
                                                                      context);
                                                              TransactionData
                                                                  transaction =
                                                                  TransactionData(
                                                                      // Pending, validated, or rejected
                                                                      );
                                                              //transaction.id="";
                                                              transaction
                                                                      .user_id =
                                                                  user.id_db!;
                                                              transaction.type =
                                                                  TypeTransaction
                                                                      .DEPOT
                                                                      .name;
                                                              transaction
                                                                      .depotType =
                                                                  TypeTranDepot
                                                                      .INTERNE
                                                                      .name;
                                                              transaction
                                                                      .type_compte =
                                                                  TypeCompte
                                                                      .PARTICULIER
                                                                      .name;

                                                              transaction
                                                                      .montant =
                                                                  gain;
                                                              transaction
                                                                      .status =
                                                                  TransactionStatus
                                                                      .VALIDER
                                                                      .name;
                                                              transaction
                                                                      .createdAt =
                                                                  DateTime.now()
                                                                      .millisecondsSinceEpoch;
                                                              transaction
                                                                      .updatedAt =
                                                                  DateTime.now()
                                                                      .millisecondsSinceEpoch;
                                                              await equipeProvider
                                                                  .createTransaction(
                                                                      transaction);
                                                            },
                                                          );
                                                          match.pari_a!
                                                                  .resultStatus =
                                                              PariResultStatus
                                                                  .PERDU.name;
                                                          match.pari_b!
                                                                  .resultStatus =
                                                              PariResultStatus
                                                                  .GAGNER.name;
                                                        }

                                                        await equipeProvider
                                                            .updatePari(
                                                                match.pari_a!,
                                                                context);
                                                        await equipeProvider
                                                            .updatePari(
                                                                match.pari_b!,
                                                                context);
                                                        await equipeProvider
                                                            .updateMatch(
                                                                match, context);

                                                        await serviceProvider
                                                            .getUserAndOperation(
                                                                match.user_a!
                                                                    .code_user_parrainage!
                                                                    .toLowerCase(),
                                                                context);
                                                        await serviceProvider
                                                            .getUserAndOperation(
                                                                match.user_b!
                                                                    .code_user_parrainage!
                                                                    .toLowerCase(),
                                                                context);
                                                        await serviceProvider
                                                            .getAppData()
                                                            .then(
                                                          (appdatas) async {
                                                            if (appdatas
                                                                .isNotEmpty) {
                                                              appdatas.first
                                                                  .adminSolde = appdatas
                                                                      .first
                                                                      .adminSolde +
                                                                  0.1 *
                                                                      (match.montant! *
                                                                          2);
                                                              await serviceProvider
                                                                  .updateAppData(
                                                                      appdatas
                                                                          .first,
                                                                      context);
                                                            }
                                                          },
                                                        );

                                                        List<String> userIds = [];
                                                        userIds.add( match.user_b!.oneIgnalUserid!);
                                                        userIds.add( match.user_a!.oneIgnalUserid!);
                                                        /*
                                            print("p user : ${widget
                                                .pari.user!.toJson()}");

                                             */
                                                        // userIds.add(serviceProvider.loginUser.oneIgnalUserid!);
                                                        if (userIds.isNotEmpty) {
                                                          await serviceProvider
                                                              .sendNotification(userIds,
                                                              "⚽️ Match terminé! Voyez le résultat maintenant!");
                                                        }
                                                      } else {
                                                        // print("match non disponible : ${value.status}");
                                                      }
                                                    },
                                                  );

                                                  setState(() {});
                                                  print("Fin");
                                                },
                                              )
                                            : Text(
                                                "0:0",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                    Icon(
                                      MaterialIcons.live_tv,
                                      color: match.status ==
                                              MatchStatus.ENCOURS.name
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white)),
                                  height: height * 0.2,
                                  width: width,
                                  child: FutureBuilder(
                                      future: _initializeVideoPlayerFuture,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return _video_controller
                                                  .value.isInitialized
                                              ? VideoPlayer(
                                                  key: new PageStorageKey(
                                                      widget.urlVideo!),
                                                  _video_controller)
                                              : Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.green,
                                                  ));
                                        } else if (snapshot.hasError) {
                                          print("error ${snapshot.error}");
                                          return Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return _video_controller
                                                  .value.isInitialized
                                              ? VideoPlayer(
                                                  key: new PageStorageKey(
                                                      widget.urlVideo!),
                                                  _video_controller)
                                              : Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.green,
                                                  ));
                                        } else {
                                          return Container(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.green,
                                              ));
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: width,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                      onPressed: match.status !=
                                              MatchStatus.ATTENTE.name
                                          ? () {}
                                          : () async {
                                              SnackBar snackBar = SnackBar(
                                                content: Text(
                                                  "Lancement en cours ... ",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              await equipeProvider
                                                  .getOnlyMatch(match.id!)
                                                  .then(
                                                (value) {
                                                  if (value.status ==
                                                      MatchStatus
                                                          .ATTENTE.name) {
                                                    setState(() async {
                                                      match.status = MatchStatus
                                                          .ENCOURS.name;
                                                      await equipeProvider
                                                          .updateMatch(
                                                              match, context);

                                                      _video_controller.play();
                                                    });
                                                  } else {
                                                    SnackBar snackBar =
                                                        SnackBar(
                                                      content: Text(
                                                        "Le jeu est déjà lancé. ",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);

                                                    print(
                                                        "match non disponible : ${value.status}");
                                                  }
                                                },
                                              );
                                            },
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          width: width * 0.6,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: onTap
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : match.status ==
                                                      MatchStatus.ENCOURS.name
                                                  ? AnimatedBuilder(
                                                      animation: _controller,
                                                      builder:
                                                          (context, child) {
                                                        return Transform.rotate(
                                                          angle: _controller
                                                                  .value *
                                                              2 *
                                                              math.pi,
                                                          child: child,
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .sports_soccer_rounded,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : match.status ==
                                                          MatchStatus
                                                              .FINISHED.name
                                                      ? Text(
                                                          'Fin du jeu',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      : Column(
                                                          children: [
                                                            Icon(
                                                              Entypo
                                                                  .game_controller,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            Text(
                                                              'Lancer le jeu',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
