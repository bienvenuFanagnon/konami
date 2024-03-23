
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import 'package:pulp_flash/pulp_flash.dart';

import '../../../../providers/equipe_provider.dart';
import '../../../../providers/providers.dart';


class AllPari extends StatefulWidget {
  const AllPari({super.key});

  @override
  State<AllPari> createState() => _AllPariState();
}

class _AllPariState extends State<AllPari> {
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);

  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);

  String formatDateMatch = "dd/MM/yyyy HH:mm";

  bool onTap=false;

  bool is_all=true;

  bool is_story=false;

  String formaterDateMatch(DateTime date) {
    return DateFormat(formatDateMatch).format(date);
  }

  Widget item(Pari pari,double width,double height){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        borderOnForeground: true, // Cette ligne est facultative, elle indique si la bordure doit être dessinée devant ou derrière l'enfant de la carte
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: pari.resultStatus==PariResultStatus.GAGNER.name?Colors.green:pari.resultStatus==PariResultStatus.NAN.name?Colors.grey: Colors.red,// Remplacez Colors.red par la couleur de votre choix
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
                  Text("${formaterDateMatch(DateTime.fromMillisecondsSinceEpoch(pari.createdAt!))}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),



                  Icon(pari.status==PariStatus.DISPONIBLE.name?Icons.lock_open_outlined:Icons.lock,color:pari.status==PariStatus.DISPONIBLE.name?Colors.green: Colors.red,)

                ],
              ),
              Text("${pari.resultStatus}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for(Equipe eq in pari.teams!)
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
                  Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: pari.resultStatus==PariResultStatus.GAGNER.name?Colors.green:pari.resultStatus==PariResultStatus.NAN.name?Colors.grey: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child:  Container(


                          child: Text(pari.resultStatus==PariResultStatus.GAGNER.name?"Gagné":pari.resultStatus==PariResultStatus.NAN.name?"Encours":"Perdu",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 15),))

                  )
                ],
              ),
              SizedBox(width: width*0.3,),
              Card(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${pari.montant} Fcfa",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900,fontSize: 15),),
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: StreamBuilder<List<Pari>>(
          stream: equipeProvider.getUserAllListPari(serviceProvider.loginUser.id_db!),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if (snapshot.hasData) {
              List<Pari> paries =snapshot.data;
              return SizedBox(
                height: height*0.76,
                width: width,                                    //    height: height*0.5,
                //   width: width,
                child: ListView.builder(

                  itemCount: paries.length,
                  itemBuilder: (BuildContext context,
                      int index) {
                    Pari pari = snapshot.data[index];
                    return item(pari, width, height);
                  },),
              );
            } else if (snapshot.hasError) {
              print("error ${snapshot.error}");
              return Icon(Icons.error_outline);
            } else {
              return Center(child: Container( height: 50,width: 50,  child: CircularProgressIndicator()));
            }
          }),
    );
  }
}
