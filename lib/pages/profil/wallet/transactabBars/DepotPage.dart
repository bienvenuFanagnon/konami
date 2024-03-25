import 'dart:math';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/profil/wallet/transactabBars/transacDepot.dart';
import 'package:konami_bet/pages/profil/wallet/transactabBars/transacRetrait.dart';


import 'package:provider/provider.dart';

import '../../../../models/soccers_models.dart';
import '../../../../providers/equipe_provider.dart';
import '../../../../providers/providers.dart';
class DepotPage extends StatefulWidget {
  const DepotPage({super.key});

  @override
  State<DepotPage> createState() => _RetraitPageState();
}

class _RetraitPageState extends State<DepotPage> {
  bool ontap=false;
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);

  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Depot'),
        ),
        body: Center(
          child: Container(

            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _montantController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer un montant';
                      }
                      if (double.parse(value)<1000) {
                        return 'montant >=1000 xof';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Montant',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child:ontap? Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ): Text('Valider',style: TextStyle(color: Colors.white),),
                    onPressed:ontap?() {

                    }: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          ontap=true;
                        });
                        try{
                          await  serviceProvider.getMatchUserById(serviceProvider.loginUser.id_db!!,context).then((user) async {



                            TransactionData transaction = TransactionData(// Pending, validated, or rejected
                            );
                            var random = Random();
                            //transaction.id="";
                            transaction.user_id= user.id_db!;
                            transaction.type=TypeTransaction.DEPOT.name;
                            transaction.depotType=TypeTranDepot.EXTERNE.name;
                            transaction.type_compte=TypeCompte.PARTICULIER.name;
                            transaction.montant=double.parse(_montantController.text);
                            transaction.status=TransactionStatus.values[random.nextInt(3)].name;
                            transaction.createdAt=DateTime.now().millisecondsSinceEpoch;
                            transaction.updatedAt=DateTime.now().millisecondsSinceEpoch;
                            await  equipeProvider.createTransaction(transaction);
                            if (transaction.status==TransactionStatus.VALIDER.name) {
                              user.montant=user.montant+double.parse(_montantController.text);
                              user.nombre_depot=user.nombre_depot!+1;

                              //  print("apres : ${user.montant}");
                              await  serviceProvider.updateUser(user, context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Votre compte a été crédité avec succès !'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }



                          },);

                          _montantController.text="";
                          // Envoyer la demande de dépôt
                          print('Demande de dépôt envoyée avec le montant ${_montantController.text}');
                          setState(() {
                            ontap=false;
                          });

                          Navigator.pop(context);
                        }catch(e){
                          setState(() {
                            ontap=false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Une erreur s'est produite. Veuillez réessayer."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
