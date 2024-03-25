import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../models/soccers_models.dart';
import '../providers/equipe_provider.dart';
import '../providers/providers.dart';
import 'dart:math' as math;

class MatchLive extends StatefulWidget {
  final MatchPari match;
  const MatchLive({super.key, required this.match});

  @override
  State<MatchLive> createState() => _MatchState();
}

class _MatchState extends State<MatchLive> with SingleTickerProviderStateMixin {
  int genererScoreAleatoire() {
    Random random = Random();
    return random.nextInt(30);
  }

  late AnimationController _controller;

  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
      Provider.of<EquipeProvider>(context, listen: false);
  bool onTap = false;

  void showWinBottomSheet(BuildContext context, double gains) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Félicitations ! ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Vous avez gagné ce match !",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Vos gains : ${gains.toStringAsFixed(2)} €",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Continuer"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                                          SizedBox(height: 10,),
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
                                          SizedBox(height: 10,),

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
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                          match.pari_a!.resultStatus ==
                                                  PariResultStatus.PERDU.name
                                              ? Text(
                                                  "perdu",
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
                                                          color: Colors.black,
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
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                          match.pari_b!.resultStatus ==
                                                  PariResultStatus.PERDU.name
                                              ? Text(
                                                  "perdu",
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
                                                          color: Colors.black,
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
                                    match.status ==
                                        MatchStatus.FINISHED.name
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
                                        await equipeProvider
                                            .getOnlyMatch(
                                            match.id!)
                                            .then(
                                              (value) async {
                                            if (value.status !=
                                                MatchStatus
                                                    .FINISHED
                                                    .name) {
                                              match.status =
                                                  MatchStatus
                                                      .FINISHED
                                                      .name;
                                              match.pari_a!
                                                  .score =
                                                  genererScoreAleatoire();
                                              match.pari_b!
                                                  .score =
                                                  genererScoreAleatoire();
                                              while (match.pari_a!
                                                  .score ==
                                                  match.pari_b!
                                                      .score) {
                                                match.pari_a!
                                                    .score =
                                                    genererScoreAleatoire();
                                                match.pari_b!
                                                    .score =
                                                    genererScoreAleatoire();
                                              }
                                              if (match.pari_a!
                                                  .score! >
                                                  match.pari_b!
                                                      .score!) {
                                                await serviceProvider
                                                    .getMatchUserById(
                                                    match
                                                        .pari_a!
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
                                                    transaction
                                                        .type =
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
                                                        .createdAt = DateTime
                                                        .now()
                                                        .millisecondsSinceEpoch;
                                                    transaction
                                                        .updatedAt = DateTime
                                                        .now()
                                                        .millisecondsSinceEpoch;
                                                    await equipeProvider
                                                        .createTransaction(
                                                        transaction);
                                                  },
                                                );

                                                match.pari_a!
                                                    .resultStatus =
                                                    PariResultStatus
                                                        .GAGNER
                                                        .name;
                                                match.pari_b!
                                                    .resultStatus =
                                                    PariResultStatus
                                                        .PERDU
                                                        .name;
                                              } else {
                                                await serviceProvider
                                                    .getMatchUserById(
                                                    match
                                                        .pari_b!
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
                                                    transaction
                                                        .type =
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
                                                        .createdAt = DateTime
                                                        .now()
                                                        .millisecondsSinceEpoch;
                                                    transaction
                                                        .updatedAt = DateTime
                                                        .now()
                                                        .millisecondsSinceEpoch;
                                                    await equipeProvider
                                                        .createTransaction(
                                                        transaction);
                                                  },
                                                );
                                                match.pari_a!
                                                    .resultStatus =
                                                    PariResultStatus
                                                        .PERDU
                                                        .name;
                                                match.pari_b!
                                                    .resultStatus =
                                                    PariResultStatus
                                                        .GAGNER
                                                        .name;
                                              }

                                              await equipeProvider
                                                  .updatePari(
                                                  match
                                                      .pari_a!,
                                                  context);
                                              await equipeProvider
                                                  .updatePari(
                                                  match
                                                      .pari_b!,
                                                  context);
                                              await equipeProvider
                                                  .updateMatch(
                                                  match,
                                                  context);

                                              await serviceProvider
                                                  .getUserAndOperation(
                                                  match
                                                      .user_a!
                                                      .code_user_parrainage!
                                                      .toLowerCase(),
                                                  context);
                                              await serviceProvider
                                                  .getUserAndOperation(
                                                  match
                                                      .user_b!
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
                                          fontWeight:
                                          FontWeight.w600,
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
                                  child: SizedBox(
                                    width: 20,
                                      height: 20,

                                      child: CircularProgressIndicator(color: Colors.green,)),
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
                                                          Icon(Entypo.game_controller,color: Colors.black,),
                                                          Text(
                                                              'Lancer le jeu',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      Colors.white),
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
