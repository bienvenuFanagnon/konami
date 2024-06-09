import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket/flutter_ticket.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/soccers_models.dart';
import '../../providers/equipe_provider.dart';
import '../../providers/providers.dart';
import '../match.dart';
import '../profil/wallet/homeWallet.dart';

class DetailsPari extends StatefulWidget {
  final Pari pari;
  const DetailsPari({super.key, required this.pari});

  @override
  State<DetailsPari> createState() => _DetailsPariState();
}

class _DetailsPariState extends State<DetailsPari> with WidgetsBindingObserver {
  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
      Provider.of<EquipeProvider>(context, listen: false);
  String formatDateMatch = "dd MMM yyyy";
  bool onTap = false;

  String formaterDateMatch(DateTime date) {
    return DateFormat(formatDateMatch).format(date);
  }

  Pari monPari = Pari();
  List<Equipe> my_teams = [];
  Widget item(Pari pari, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        borderOnForeground:
            true, // Cette ligne est facultative, elle indique si la bordure doit être dessinée devant ou derrière l'enfant de la carte
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: pari.status == PariStatus.DISPONIBLE.name
                ? Colors.green
                : Colors
                    .red, // Remplacez Colors.red par la couleur de votre choix
            width:
                2.0, // Définissez l'épaisseur de la bordure selon vos besoins
          ),
          borderRadius: BorderRadius.circular(
              15.0), // Définissez le rayon de la bordure de la carte selon vos besoins
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.sports_soccer,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  // SizedBox(width: width*0.3,),
                  //    Text("${formaterDateMatch(DateTime.fromMillisecondsSinceEpoch(pari.createdAt!))}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                  Icon(
                    pari.status == PariStatus.DISPONIBLE.name
                        ? Icons.lock_open_outlined
                        : Icons.lock,
                    color: pari.status == PariStatus.DISPONIBLE.name
                        ? Colors.green
                        : Colors.red,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (Equipe eq in pari.teams!)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              child: Image.network(
                                "${eq.logo!}",
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
              SizedBox(
                width: width * 0.3,
              ),
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${pari.montant} Fcfa",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                      fontSize: 15),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(double width) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: width,
          //height: 200,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Votre solde est insuffisant.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeWallet(),
                        ));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Recharger',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: ,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget myItem(Pari pari, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        borderOnForeground:
            true, // Cette ligne est facultative, elle indique si la bordure doit être dessinée devant ou derrière l'enfant de la carte
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: pari.status == PariStatus.DISPONIBLE.name
                ? Colors.green
                : Colors
                    .red, // Remplacez Colors.red par la couleur de votre choix
            width:
                2.0, // Définissez l'épaisseur de la bordure selon vos besoins
          ),
          borderRadius: BorderRadius.circular(
              15.0), // Définissez le rayon de la bordure de la carte selon vos besoins
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.sports_soccer,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  // SizedBox(width: width*0.3,),
                  //Text("${formaterDateMatch(DateTime.fromMillisecondsSinceEpoch(pari.createdAt!))}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                  Icon(
                    pari.status == PariStatus.DISPONIBLE.name
                        ? Icons.lock_open_outlined
                        : Icons.lock,
                    color: pari.status == PariStatus.DISPONIBLE.name
                        ? Colors.green
                        : Colors.red,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (Equipe eq in pari.teams!)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              child: Image.network(
                                "${eq.logo!}",
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
              SizedBox(
                width: width * 0.3,
              ),
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${pari.montant} Fcfa",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                      fontSize: 15),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  bool isIn(List<Equipe> team_id, String current_team_id) {
    return team_id.any((item) => item.id == current_team_id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    monPari = Pari();
    my_teams = [];
    monPari.teams = [];
    monPari.montant = widget.pari.montant;
    monPari.user_id = serviceProvider.loginUser.id_db!;
    monPari.status = PariStatus.DISPONIBLE.name;

    monPari.createdAt = DateTime.now()
        .millisecondsSinceEpoch; // Get current time in milliseconds
    monPari.updatedAt = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("etat de la page ${state.name} ");
    if (state == AppLifecycleState.paused) {
      print("sort de la page");
      // Action à effectuer lorsque l'application est mise en arrière-plan
      // ou lorsque l'utilisateur quitte la page de manière inattendue
      // (par exemple, lorsque le téléphone s'éteint)
      // Placez votre code ici.
      /* equipeProvider.getOnlyPari(widget.pari.id!).then((value) async {
        if (value.status==PariStatus.PARIER.name) {
          value.status==PariStatus.DISPONIBLE.name;
          print("update en cours");

          await  equipeProvider.updatePari(value, context);
          print("update fini");

        }
      },);

      */
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // Affichez une boîte de dialogue de confirmation
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Voulez-vous vraiment quitter ?'),
            content: Text('Toutes vos modifications seront perdues.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Non'),
              ),
              TextButton(
                onPressed: () async {
                  await equipeProvider.getOnlyPari(widget.pari.id!).then(
                    (value) async {
                      if (value.status != PariStatus.PARIER.name) {
                        value.status = PariStatus.DISPONIBLE.name;
                        print("update en cours");

                        await equipeProvider.updatePari(value, context);
                        print("update fini");
                      }
                    },
                  );
                  Navigator.pop(context, true);
                },
                child: Text('Oui'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Créer un match'),
        ),
        body: Container(
          //width: 375,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //  mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.sports_soccer,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                      // SizedBox(width: width*0.3,),
                      // Text("${formaterDateMatch(DateTime.fromMillisecondsSinceEpoch(widget.pari.createdAt!))}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                      Container(
                        height: 30,
                        width: 30,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Ticket(
                    innerRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    outerRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4.0),
                        blurRadius: 2.0,
                        spreadRadius: 2.0,
                        color: Color.fromRGBO(196, 196, 196, .76),
                      )
                    ],
                    child: Container(
                      width: width,
                      height: height * 0.35,
                      color: Colors.blue.shade100,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Equipes Adverse',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 0.0),
                          item(widget.pari, width, height)
                        ],
                      ),
                    ),
                  ),
                  Ticket(
                    innerRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    outerRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 2.0,
                        spreadRadius: 2.0,
                        color: Color.fromRGBO(196, 196, 196, .76),
                      )
                    ],
                    child: Container(
                      width: width,
                      height: height * 0.35,
                      color: Colors.green.shade100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  'Ajouter vos Equipes',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  equipeProvider.teams.length <
                                                          1
                                                      ? Center(
                                                          child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              child:
                                                                  CircularProgressIndicator()))
                                                      : SingleChildScrollView(
                                                          child: SizedBox(
                                                            height:
                                                                height * 0.5,
                                                            //  width: 200,
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  equipeProvider
                                                                      .teams
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                Equipe team =
                                                                    equipeProvider
                                                                            .teams[
                                                                        index];
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                  child: Card(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          2.0),
                                                                      child:
                                                                          Container(
                                                                        //width: 200,
                                                                        child: ListTile(
                                                                            title: Padding(
                                                                              padding: const EdgeInsets.only(left: 5.0),
                                                                              child: Icon(
                                                                                Icons.sports_soccer,
                                                                                color: Colors.green,
                                                                                size: 20,
                                                                              ),
                                                                            ),
                                                                            subtitle: Text("${team.nom!}"),
                                                                            leading: Card(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(2.0),
                                                                                child: Container(
                                                                                  child: Image.network(
                                                                                    "${team.logo!}",
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                  width: 40,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            trailing: isIn(monPari.teams!, team.id!)
                                                                                ? TextButton(
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        // teams.add(team);
                                                                                        monPari.teams!.remove(team);

                                                                                        //saveTeams(teams);
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      "Retirer",
                                                                                      style: TextStyle(color: Colors.red),
                                                                                    ))
                                                                                : TextButton(
                                                                                    onPressed: () {
                                                                                      //   await deleteToken();
                                                                                      setState(() {
                                                                                        // teams.add(team);
                                                                                        if (monPari.teams!.length > 2) {
                                                                                          Navigator.pop(context);
                                                                                          SnackBar snackBar = SnackBar(
                                                                                            content: Text(
                                                                                              'le nombre maximal est atteint 3',
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(color: Colors.red),
                                                                                            ),
                                                                                          );
                                                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                        } else {
                                                                                          monPari.teams!.add(team);
                                                                                          Navigator.pop(context);
                                                                                        }

                                                                                        //saveTeams(teams);
                                                                                      });
                                                                                    },
                                                                                    child: Text(
                                                                                      "Ajouter",
                                                                                      style: TextStyle(color: Colors.green),
                                                                                    ))),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add_circle_outlined,
                                    color: Colors.lightBlue,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(height: 0.0),
                          myItem(monPari, width, height)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: onTap
                      ? () {}
                      : () async {
                          if (monPari.teams!.length == 3) {
                            setState(() {
                              onTap = true;
                            });

                            try {
                              await serviceProvider
                                  .getUserByIdContente(
                                      serviceProvider.loginUser.id_db!, context)
                                  .then(
                                (value) async {
                                  if (value) {
                                    if (serviceProvider.loginUser.montant > 0 &&
                                        serviceProvider.loginUser.montant >=
                                            monPari.montant!) {
                                      SnackBar snackBar1 = SnackBar(
                                        content: Text(
                                          "En attente de vérification, veuillez patienter quelques secondes...",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.green),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar1);
                                      final random = Random();
                                      await Future.delayed(Duration(seconds: random.nextInt(8) + 5));
                                      await equipeProvider
                                          .getOnlyPari(widget.pari.id!)
                                          .then((value) async {
                                        if (value.status !=
                                            PariStatus.PARIER.name) {
                                          try {
                                            String id = FirebaseFirestore
                                                .instance
                                                .collection('PariEnCours')
                                                .doc()
                                                .id;
                                            //  Pari pari=Pari();
                                            monPari.id = id;
                                            monPari.score = 0;
                                            monPari.teams_id = [];
                                            monPari.resultStatus =
                                                PariResultStatus.NAN.name;

                                            monPari.status =
                                                PariStatus.PARIER.name;
                                            for (Equipe eq in monPari.teams!) {
                                              monPari.teams_id!.add(eq.id!);
                                            }
                                            monPari.teams = [];
                                            //   pari.createdAt= DateTime.now().millisecondsSinceEpoch;// Get current time in milliseconds
                                            //   pari.updatedAt= DateTime.now().millisecondsSinceEpoch;
                                            await FirebaseFirestore.instance
                                                .collection('PariEnCours')
                                                .doc(id)
                                                .set(monPari.toJson());
                                            serviceProvider.loginUser.montant =
                                                serviceProvider
                                                        .loginUser.montant -
                                                    monPari.montant!;
                                            await serviceProvider.updateUser(
                                                serviceProvider.loginUser,
                                                context);

                                            widget.pari.status =
                                                PariStatus.PARIER.name;
                                            await equipeProvider.updatePari(
                                                widget.pari, context);

                                            MatchPari match = MatchPari();
                                            String match_id = FirebaseFirestore
                                                .instance
                                                .collection('PariEnCours')
                                                .doc()
                                                .id;
                                            match.id = match_id;
                                            match.pari_a = monPari;
                                            match.pari_a_id = monPari.id;
                                            match.pari_b = widget.pari;
                                            match.pari_b_id = widget.pari.id;
                                            match.user_a_id = serviceProvider
                                                .loginUser.id_db!;
                                            match.user_b_id =
                                                widget.pari.user_id;
                                            match.montant = widget.pari.montant;
                                            match.status =
                                                MatchStatus.ATTENTE.name;
                                            match.createdAt = DateTime.now()
                                                .millisecondsSinceEpoch; // Get current time in milliseconds
                                            match.updatedAt = DateTime.now()
                                                .millisecondsSinceEpoch;
                                            await FirebaseFirestore.instance
                                                .collection('Matches')
                                                .doc(match.id)
                                                .set(match.toJson());

                                            SnackBar snackBar = SnackBar(
                                              content: Text(
                                                "Le pari a été ajouté avec succès",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            );
                                            // equipeProvider.teams_selected=[];
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            setState(() {
                                              onTap = false;
                                            });
                                            await serviceProvider
                                                .getAppData()
                                                .then(((appData) {
                                              if (appData.isNotEmpty) {
                                                if (appData
                                                    .first.videos!.isNotEmpty) {
                                                  appData.first.videos!
                                                      .shuffle();
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MatchLive(
                                                          match: match,
                                                          urlVideo: appData
                                                              .first
                                                              .videos!
                                                              .first,
                                                        ),
                                                      ));
                                                }
                                              }
                                            }));
                                            List<String> userIds = [];
                                            userIds.add(widget
                                                .pari.user!.oneIgnalUserid!);
                                            /*
                                            print("p user : ${widget
                                                .pari.user!.toJson()}");

                                             */
                                               // userIds.add(serviceProvider.loginUser.oneIgnalUserid!);
                                                if (userIds.isNotEmpty) {
                                                     await serviceProvider
                                                      .sendNotification(userIds,
                                                          "🤝🥅Un match est créé avec un de vos paris");
                                                }
                                      
                                            //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MatchLive(match: match,),));
                                          } catch (e) {
                                            setState(() {
                                              onTap = false;
                                            });
                                            SnackBar snackBar = SnackBar(
                                              content: Text(
                                                "Désolé, une erreur s'est produite. Veuillez vérifier votre connexion et réessayer ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        } else {
                                          setState(() {
                                            onTap = false;
                                          });
                                          SnackBar snackBar = SnackBar(
                                            content: Text(
                                              "pari non disponible",
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      });
                                    } else {
                                      _showBottomSheet(width);
                                    } //sold in
                                  } else {}
                                },
                              );
                            } catch (e) {
                              print("erreur update post : ${e}");
                              setState(() {
                                onTap = false;
                              });
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  "erreur",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            setState(() {
                              onTap = false;
                            });
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                "Le nombre d'équipes requis 3",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            // Traiter le montant saisi
                          }

                          setState(() {
                            onTap = false;
                          });
                        },
                  child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: width * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: onTap
                          ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Jouer Maintenant',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
