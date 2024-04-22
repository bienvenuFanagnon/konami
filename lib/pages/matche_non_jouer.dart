import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import 'package:pulp_flash/pulp_flash.dart';
import '../../providers/providers.dart';
import '../providers/equipe_provider.dart';
import 'details/pari_details.dart';
import 'match.dart';

class MyListMatch extends StatefulWidget {
  const MyListMatch({Key? key}) : super(key: key);

  @override
  State<MyListMatch> createState() => _MyListMatchState();
}

class _MyListMatchState extends State<MyListMatch> {
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);
  String formatDateMatch = "dd/MM/yyyy HH:mm";
  bool onTap=false;
  String formaterDateMatch(DateTime date) {
    return DateFormat(formatDateMatch).format(date);
  }

  Widget item(MatchPari matchPari,double width,double height){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        borderOnForeground: true, // Cette ligne est facultative, elle indique si la bordure doit être dessinée devant ou derrière l'enfant de la carte
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: matchPari.status==MatchStatus.ATTENTE.name?Colors.green: Colors.red, // Remplacez Colors.red par la couleur de votre choix
            width: 2.0, // Définissez l'épaisseur de la bordure selon vos besoins
          ),
          borderRadius: BorderRadius.circular(15.0), // Définissez le rayon de la bordure de la carte selon vos besoins
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
                  Text("${formaterDateMatch(DateTime.fromMillisecondsSinceEpoch(matchPari.createdAt!))}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                  Icon(MaterialIcons.live_tv,color: matchPari.status==MatchStatus.ENCOURS.name?Colors.green:Colors.black,),


                 // Icon(matchPari.status==MatchStatus.ENCOURS.name?Icons.lock_open_outlined:Icons.lock,color:matchPari.status==PariStatus.DISPONIBLE.name?Colors.green: Colors.red,)

                ],
              ),
              Text("${matchPari.status}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      /*
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 5,),
                          Text("@${matchPari.user_a!.pseudo!}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 15),),
                        ],
                      ),

                       */
                      SizedBox(height: 10,),
                      matchPari.user_a_id!=serviceProvider.loginUser.id_db?Text("Adverse".toUpperCase(),style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 15),):   Text("Vous".toUpperCase(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 15),),

                      Text("Equipes A",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for(Equipe eq in matchPari.pari_a!.teams!)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(

                                    child: Image.network("${eq.logo!}",fit: BoxFit.cover,),
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text("Score Total",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                      Text("${matchPari.pari_a!.score==null?0:matchPari.pari_a!.score}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                    ],
                  ),
                  Column(
                    children: [
                      /*
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 5,),
                          Text("@${matchPari.user_b!.pseudo!}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 15),),
                        ],
                      ),

                       */
                      SizedBox(height: 10,),

                      matchPari.user_b_id!=serviceProvider.loginUser.id_db?Text("Adverse".toUpperCase(),style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 15),):   Text("Vous".toUpperCase(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 15),),

                      Text("Equipes B",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for(Equipe eq in matchPari.pari_b!.teams!)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(

                                    child: Image.network("${eq.logo!}",fit: BoxFit.cover,),
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text("Score Total",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                      Text("${matchPari.pari_b!.score==null?0:matchPari.pari_b!.score}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                    ],
                  ),



                ],
              ),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateb) {
                    return    TextButton(onPressed:onTap?() {

                    } :() async {

                      setStateb(() {
                        onTap=true;

                      });
                    await  equipeProvider.getOnlyMatch(matchPari.id!).then((value) async {
                        if (value.status!=MatchStatus.FINISHED.name) {
                          await    serviceProvider.getAppData().then(((appData) {
                            if (appData.isNotEmpty) {
                              if (appData.first.videos!.isNotEmpty) {
                                appData.first.videos!.shuffle();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MatchLive( match:value, urlVideo: appData.first.videos!.first ,),));


                              }
                            }

                          }));
                        }  else{
                          /*
                          await    serviceProvider.getAppData().then(((appData) {
                            if (appData.isNotEmpty) {
                              if (appData.first.videos!.isNotEmpty) {
                                appData.first.videos!.shuffle();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MatchLive( match:value, urlVideo: appData.first.videos!.first ,),));


                              }
                            }

                          }));

                           */
                          print("match non disponible : ${value.status}");
                        }
                      },);



                      setStateb(() {
                        onTap=false;

                      });
                      /*
                          equipeProvider.getOnlyPari(pari.id!).then((value) async {
                            if (value.status==PariStatus.DISPONIBLE.name) {
                              print("disponible : ${value.status}");
                              value.status=PariStatus.ENCOURS.name;
                              await equipeProvider.updatePari(value, context);
                              setStateb(() {
                                onTap=false;

                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPari(pari: pari,),));

                            } else{

                              SnackBar snackBar = SnackBar(
                                content: Text('Un autre utilisateur est en train de miser là-dessus.',textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              print("non disponible : ${value.status}");
                              //  value.status=PariStatus.DISPONIBLE.name;
                              //    await equipeProvider.updatePari(value, context);
                              setStateb(() {
                                onTap=false;

                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPari(pari: pari,),));


                            }
                          },);


                           */



                    }, child:
                    Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                            color: matchPari.status==MatchStatus.ATTENTE.name?Colors.green: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: onTap? Container(
                            height: 20,
                            width: 20,

                            child: CircularProgressIndicator()):matchPari.status==MatchStatus.ENCOURS.name?Text("Voir",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 15),):Text("Jouer",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 15),)));
                  }
              ),
              SizedBox(width: width*0.3,),
              Card(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${matchPari.montant} Fcfa",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900,fontSize: 15),),
              )),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Matchs En Cours'),
        ),
        body: RefreshIndicator(

          onRefresh: ()async {
            setState(() {

            });
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Les matchs non jouer'),
                        /*
                        GestureDetector(
                          onTap: () {

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamSelectedPage(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: badges.Badge(
                              badgeContent: Text(
                                '${equipeProvider.teams_selected.length}',
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Icon(Icons.shopping_cart),
                            ),
                          ),
                        ),

                         */
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    StreamBuilder<List<MatchPari>>(
                        stream: equipeProvider.getListMatch(serviceProvider.loginUser.id_db!),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {

                          if (snapshot.hasData) {
                            List<MatchPari> matches =snapshot.data;
                            return SizedBox(
                              height: height*0.76,
                              width: width,                                    //    height: height*0.5,
                              //   width: width,
                              child: ListView.builder(

                                itemCount: matches.length,
                                itemBuilder: (BuildContext context,
                                    int index) {
                                  MatchPari match = snapshot.data[index];
                                  return item(match, width, height);
                                },),
                            );
                          } else if (snapshot.hasError) {
                            print("erreur ${snapshot.error.toString()}");
                            return Icon(Icons.error_outline);
                          } else {
                            return Center(child: Container( height: 50,width: 50,  child: CircularProgressIndicator()));
                          }
                        }),
                    SizedBox(
                      height: 300,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
