
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import 'package:pulp_flash/pulp_flash.dart';

import '../../../../providers/equipe_provider.dart';
import '../../../../providers/providers.dart';


class TransactionRetrait extends StatefulWidget {
  final String typeCompte;

  const TransactionRetrait({super.key, required this.typeCompte});

  @override
  State<TransactionRetrait> createState() => _AllPariState();
}

class _AllPariState extends State<TransactionRetrait> {
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



  Widget item(TransactionData trans,double width,double height){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        borderOnForeground: true, // Cette ligne est facultative, elle indique si la bordure doit être dessinée devant ou derrière l'enfant de la carte
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: trans.status==TransactionStatus.VALIDER.name?Colors.green:trans.status==TransactionStatus.ENCOURS.name?Colors.grey: Colors.red,// Remplacez Colors.red par la couleur de votre choix
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
                      FontAwesome.money,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  // SizedBox(width: width*0.3,),
                  Text("${formaterDateMatch(DateTime.fromMillisecondsSinceEpoch(trans.createdAt!))}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),


                  Container()

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${trans.montant} XOF",style: TextStyle(
                      color: trans.status==TransactionStatus.VALIDER.name?Colors.green:trans.status==TransactionStatus.ENCOURS.name?Colors.grey: Colors.red,// Remplacez Colors.red par la couleur de votre choix
                      fontWeight: FontWeight.w600,fontSize: 15),),


                  trans.status==TransactionStatus.ENCOURS.name? Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(
color: Colors.black,                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child:  TextButton(


                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: trans.id));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('code copié dans le presse-papiers'),
                          ));
                        },
                        child: Text("Copier le code",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 12),),
                      )

                  ):Container(),


                  Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: trans.status==TransactionStatus.VALIDER.name?Colors.green:trans.status==TransactionStatus.ENCOURS.name?Colors.grey: Colors.red,// Remplacez Colors.red par la couleur de votre choix
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child:  Container(


                        child: Text("${trans.status==TransactionStatus.VALIDER.name?"Validée":trans.status==TransactionStatus.ANNULER.name?"Annulée":"Encours"}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 12),),
                      )

                  )
                ],
              ),


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
      child: StreamBuilder<List<TransactionData>>(
          stream: equipeProvider.getUserTransactionRetrait(serviceProvider.loginUser.id_db!,widget.typeCompte),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if (snapshot.hasData) {
              List<TransactionData> transactions =snapshot.data;
              return SizedBox(
                height: height*0.76,
                width: width,                                    //    height: height*0.5,
                //   width: width,
                child: ListView.builder(

                  itemCount: transactions.length,
                  itemBuilder: (BuildContext context,
                      int index) {
                    TransactionData transactionData = snapshot.data[index];
                    return item(transactionData, width, height);
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
