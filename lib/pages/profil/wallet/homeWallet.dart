import 'dart:math';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/profil/wallet/transactabBars/DepotPage.dart';
import 'package:konami_bet/pages/profil/wallet/transactabBars/retraitPage.dart';
import 'package:konami_bet/pages/profil/wallet/transactabBars/transacDepot.dart';
import 'package:konami_bet/pages/profil/wallet/transactabBars/transacRetrait.dart';

import '../../../models/soccers_models.dart';
import '../../../providers/equipe_provider.dart';
import '../../../providers/providers.dart';
import 'package:provider/provider.dart';

import '../validate_page.dart';

class HomeWallet extends StatefulWidget {
  const HomeWallet({super.key});

  @override
  State<HomeWallet> createState() => _HomeWalletState();
}

class _HomeWalletState extends State<HomeWallet> {
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);

  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _codePINController = TextEditingController();

  void _showBottomSheetRetraitBloquer(double width) {
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
                Text(
                  "Retraits temporairement bloqués",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Votre compte a été temporairement suspendu en raison d'une violation de nos règles. Veuillez nous contacter pour une vérification.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWallet(),));

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info,color: Colors.black,),
                      SizedBox(width: 5,),
                      const Text('Contacter le support',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
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

  void _showBottomSheetCompterNonValide(double width) {
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
                Text(
                  "Validation du compte",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Veuillez définir un code PIN pour valider votre compte et effectuer plusieurs retraits.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => ValidateCompte(),));

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock,color: Colors.black,),
                      SizedBox(width: 5,),
                      const Text('Définir un code PIN',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
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

  Widget codePinFormat() {
    return AlertDialog(
      title: const Text('Saisir votre code PIN'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _codePINController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir votre code PIN';
                } if (value!=serviceProvider.loginUser.codePinSecurity) {
                  return 'code PIN incorrect';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                // Action à effectuer lorsque le bouton est pressé
              },
              child: Text(
                'Vous avez oublié votre code PIN ? Contactez-nous',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Valider le code PIN et fermer le dialogue
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => RetraitPage(),));

            }
          },
          child: const Text('Valider'),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: ()async {
        setState(() {

        });
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Mon Compte'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                 // alignment: Alignment.center,
                  width: width*0.9,
              // height:220 ,
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Solde Disponible",style: TextStyle(color: Colors.black,fontSize: 15),),
                          IconButton(onPressed: () {
                            setState(() {

                            });
                          }, icon: Icon(Icons.refresh))
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Entypo.wallet,size: 50,),
                          StreamBuilder<Utilisateur>(
                              stream: serviceProvider.getOnLyStreamUser(serviceProvider.loginUser.id_db!),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  Utilisateur user=snapshot.data;
                                  return Text(
                                    ' ${user.montant} XOF',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Icon(Icons.error_outline);
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }),
                        ],
                      ),
                      SizedBox(height: 20,),
                      ListTile(
                        leading:     GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DepotPage(),));


                          },
                          child: Container(
                             alignment: Alignment.center,
                            width: 100,
                            height:40 ,
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.add_circle_outlined,color: Colors.green,),

                                  Text("Dépôt",style: TextStyle(color: Colors.black,fontSize: 15),),

                                ],
                              ),
                            ),

                          ),
                        ),
                        trailing:  GestureDetector(
                          onTap: () async {
                            await  serviceProvider.getMatchUserById(serviceProvider.loginUser.id_db!!,context).then((user) async {
                              serviceProvider.loginUser=user;
                              print("nbr retrait ${serviceProvider.loginUser.nombre_retrait}");

                              if (serviceProvider.loginUser.retrait_is_valide!) {
                                if (serviceProvider.loginUser.nombre_retrait!>1) {
                                  if (serviceProvider.loginUser.is_valide!) {

                                    showDialog(
                                      context: context,
                                      builder: (context) =>  codePinFormat(),
                                    );


                                  } else{
                                    _showBottomSheetCompterNonValide(width);


                                    //demande de code pin, et s il y a pas on dirige sur la page de validation

                                    //valider votre compte

                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RetraitPage(),));

                                  }

                                } else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RetraitPage(),));

                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => RetraitPage(),));

                                }
                              } else{

                                _showBottomSheetRetraitBloquer(width);
                                //message indiquant que le retrait est bloquer

                              }

                            });

                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            height:40,
                            decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.remove_circle,color: Colors.red,),

                                  Text("Retrait",style: TextStyle(color: Colors.black,fontSize: 15),),
                                  serviceProvider.loginUser.retrait_is_valide!?Container():   Icon( Icons.lock,color: Colors.red,),

                                ],
                              ),
                            ),

                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
                SizedBox(height: 10,),
                Text("Transactions",style: TextStyle(color: Colors.black,fontSize: 20),),
                SizedBox(height: 10,),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height*0.57,
                      width: width,
                      child:
                      Center(
                        child: ContainedTabBarView(

                          tabs: [
                            Text('Dépôt'),
                            Text('Retrait'),

                          ],
                          views: [
                            TransactionDepot(typeCompte: TypeCompte.PARTICULIER.name,),
                            TransactionRetrait(typeCompte: TypeCompte.PARTICULIER.name,),

                          ],
                          onChange: (index) => print(index),
                        ),
                      ),


                    ),
                  ),
                ),

              ]
                    ),
            ),
          ),
      ),
    );
  }
}
