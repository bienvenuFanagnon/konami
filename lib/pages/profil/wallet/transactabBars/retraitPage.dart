import 'dart:math';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/profil/wallet/transactabBars/transacDepot.dart';
import 'package:konami_bet/pages/profil/wallet/transactabBars/transacRetrait.dart';


import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/soccers_models.dart';
import '../../../../providers/equipe_provider.dart';
import '../../../../providers/providers.dart';

class Agent {
  final String name;
  final String imageUrl;

  Agent({required this.name, required this.imageUrl});
}
class RetraitPage extends StatefulWidget {
  const RetraitPage({super.key});

  @override
  State<RetraitPage> createState() => _RetraitPageState();
}

class _RetraitPageState extends State<RetraitPage> {
  bool ontap=false;
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);
  final List<Agent> agents = [
    Agent(name: 'Agent 1', imageUrl: 'https://picsum.photos/200'),

  ];
  Future<void> launchWhatsApp(String phone,) async {
    //  var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
    // String url = "https://wa.me/?tel:+228$phone&&text=YourTextHere";
    String url = "whatsapp://send?phone="+phone+"&text=Salut ,\n*Pseudo du compte*: *@${serviceProvider.loginUser.pseudo!.toUpperCase()}*,\n\n je vous contacte via *${"Konami".toUpperCase()}* pour un retrait\n";
    if (!await launchUrl(Uri.parse(url))) {
      final snackBar = SnackBar(duration: Duration(seconds: 2),content: Text("Impossible d\'ouvrir WhatsApp",textAlign: TextAlign.center, style: TextStyle(color: Colors.red),));

      // Afficher le SnackBar en bas de la page
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception('Impossible d\'ouvrir WhatsApp');
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Retrait'),
        ),
        body: Center(

          child: Container(

            padding: EdgeInsets.all(20),

            child: Form(
              key: _formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Veuillez contacter un agent avant de commencer l\'opération.',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Pour un retrait manuel, saisissez le montant et validez pour créer la transaction. Après validation, vous recevrez un code de transaction. Copiez-le et envoyez-le à un agent pour vérification et pour recevoir votre paiement.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Liste des agents disponibles:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),

                  Expanded(
                    child: ListView.builder(
                      itemCount: agents.length,
                      itemBuilder: (context, index) {
                        final agent = agents[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/logoIcon.png"),
                          ),
                          title: Text(agent.name),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Handle contact agent action
                              print('Contacting agent ${agent.name}');
                              serviceProvider.getAppData().then((value) {
                                if (value.isNotEmpty) {
                                  launchWhatsApp("${value.first.phoneConatct}");

                                }
                              },);
                              //launchWhatsApp("+22896198801");

                            },
                            child: const Text('Contacter'),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _montantController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer un montant';
                      }
                      if (double.parse(value)<500) {
                        return 'montant >=500 xof';
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
                      backgroundColor: Colors.green,
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



                            if (user.montant>=double.parse(_montantController.text)) {

                              TransactionData transaction = TransactionData(// Pending, validated, or rejected
                              );
                              var random = Random();
                              //transaction.id="";
                              transaction.user_id= user.id_db!;
                              transaction.type=TypeTransaction.RETRAIT.name;
                              transaction.depotType=TypeTranDepot.EXTERNE.name;
                              transaction.type_compte=TypeCompte.PARTICULIER.name;

                              transaction.montant=double.parse(_montantController.text);
                              transaction.status=TransactionStatus.ANNULER.name;
                              transaction.createdAt=DateTime.now().millisecondsSinceEpoch;
                              transaction.updatedAt=DateTime.now().millisecondsSinceEpoch;
                              await  equipeProvider.createTransaction(transaction);
                              if (transaction.status==TransactionStatus.VALIDER.name) {
                                user.montant=user.montant-double.parse(_montantController.text);
                                user.nombre_retrait=user.nombre_retrait!+1;
                                //  print("apres : ${user.montant}");
                                await  serviceProvider.updateUser(user, context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Votre compte a été  débité  avec succès !'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }

                            }  else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("solde insuffisant"),
                                  backgroundColor: Colors.red,
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
