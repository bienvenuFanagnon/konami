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

class ComptePartenaire extends StatefulWidget {
  const ComptePartenaire({super.key});

  @override
  State<ComptePartenaire> createState() => _HomeWalletState();
}

class _HomeWalletState extends State<ComptePartenaire> {
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);

  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();




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
          title: Text('Mon Compte Partenaire'),
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
                        color: Colors.red.shade200,
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
                                        ' ${user.montant_compte_parrain} XOF',
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
                          SizedBox(height: 10,),

                          ListTile(
                            leading:Text("${serviceProvider.loginUser.nom!}".toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 15),),

                            trailing:  Text("${serviceProvider.loginUser.prenom!}".toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 15),),
                          ),
                          ListTile(
                            leading:Text("Paris des fillules",style: TextStyle(color: Colors.black,fontSize: 15),),

                            trailing:  Text("${serviceProvider.loginUser.nombre_pari_parrainage!} (max:100)",style: TextStyle(color: Colors.white,fontSize: 15),),
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
                              TransactionDepot(typeCompte: TypeCompte.PARTENAIRE.name,),
                              TransactionRetrait(typeCompte: TypeCompte.PARTENAIRE.name,),

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
