import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/history.dart';
import 'package:konami_bet/pages/profil/pari/user_pari.dart';
import 'package:konami_bet/pages/profil/wallet/homeWallet.dart';

import 'package:provider/provider.dart';

import '../../providers/equipe_provider.dart';
import '../../providers/providers.dart';


class Profil extends StatefulWidget {
  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    late ServiceProvider serviceProvider =
    Provider.of<ServiceProvider>(context, listen: false);
    late EquipeProvider equipeProvider =
    Provider.of<EquipeProvider>(context, listen: false);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

           Container(
             alignment: Alignment.center,
             height: 150,
             width: 150,
             decoration: BoxDecoration(
               color: Colors.green,
               borderRadius: BorderRadius.all(Radius.circular(200))
             ),
             child: Padding(
               padding: const EdgeInsets.all(30),
               child: Text("${serviceProvider.loginUser.nom}".substring(0, 1).toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 70),),
             ),
           ),
            SizedBox(height: 10),
            Text("${serviceProvider.loginUser.nom}".toUpperCase(),style: TextStyle(fontSize: 20),),
            SizedBox(height: 10),
            Text("${serviceProvider.loginUser.phoneNumber}"),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {

                    },
                    child: Center(child: Row(
                      children: [
                        Text("Code : ${serviceProvider.loginUser.codeSecurity==null?"pas de code":serviceProvider.loginUser.codeSecurity}"),
                        SizedBox(width: 10,),
                        ElevatedButton(onPressed: () {
                          Clipboard.setData(ClipboardData(text: serviceProvider.loginUser.codeSecurity.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('code copié dans le presse-papiers'),
                          ));
                        },
                            child: Text("Copier")),
                      ],
                    ))),

              ],
            ),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                // color: CustomConstants.kPrimaryColor,

                child: TextButton(
                  style: TextButton.styleFrom(
                    // primary: CustomConstants.kPrimaryColor,
                    padding: EdgeInsets.all(20),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWallet(),));
                    // Navigator.pushNamed(context, "/subscription");


                    // Share.share('https://play.google.com/store/apps/details?id=com.hilexpertiz.mykeys.mykeys');
                    //Share.share('https://example.com', subject: "Partager l'application");
                  },
                  child: Row(
                    children: [
                      Icon(MaterialIcons.account_balance_wallet,size: 22,color: Colors.green,),
                      SizedBox(width: 20),
                      Expanded(child: Text("Mon Compte",style: TextStyle(color: Colors.black),)),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            ),
            /*
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                // color: CustomConstants.kPrimaryColor,

                child: TextButton(
                  style: TextButton.styleFrom(
                    // primary: CustomConstants.kPrimaryColor,
                    padding: EdgeInsets.all(20),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, "/subscription");


                    // Share.share('https://play.google.com/store/apps/details?id=com.hilexpertiz.mykeys.mykeys');
                    //Share.share('https://example.com', subject: "Partager l'application");
                  },
                  child: Row(
                    children: [
                      Icon(MaterialIcons.account_balance_wallet,size: 22,color: Colors.green,),
                      SizedBox(width: 20),
                      Expanded(child: Text("Retrait",style: TextStyle(color: Colors.black),)),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            ),

             */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                // color: CustomConstants.kPrimaryColor,

                child: TextButton(
                  style: TextButton.styleFrom(
                    // primary: CustomConstants.kPrimaryColor,
                    padding: EdgeInsets.all(20),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHistoListMatch(),));

                    // Navigator.pushNamed(context, "/subscription");


                    // Share.share('https://play.google.com/store/apps/details?id=com.hilexpertiz.mykeys.mykeys');
                    //Share.share('https://example.com', subject: "Partager l'application");
                  },
                  child: Row(
                    children: [
                      Icon(MaterialCommunityIcons.soccer_field,size: 22,color: Colors.green,),
                      SizedBox(width: 20),
                      Expanded(child: Text("Mes Matchs",style: TextStyle(color: Colors.black),)),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                // color: CustomConstants.kPrimaryColor,

                child: TextButton(
                  style: TextButton.styleFrom(
                    // primary: CustomConstants.kPrimaryColor,
                    padding: EdgeInsets.all(20),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserHistoriquePari(),));
                    // Navigator.pushNamed(context, "/subscription");


                    // Share.share('https://play.google.com/store/apps/details?id=com.hilexpertiz.mykeys.mykeys');
                    //Share.share('https://example.com', subject: "Partager l'application");
                  },
                  child: Row(
                    children: [
                      Icon(Entypo.ticket,size: 22,color: Colors.green,),
                      SizedBox(width: 20),
                      Expanded(child: Text("Mes Paris",style: TextStyle(color: Colors.black),)),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                // color: CustomConstants.kPrimaryColor,

                child: TextButton(
                  style: TextButton.styleFrom(
                    // primary: CustomConstants.kPrimaryColor,
                    padding: EdgeInsets.all(20),
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFFF5F6F9),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "phone");

                    // Navigator.pushNamed(context, "/subscription");


                    // Share.share('https://play.google.com/store/apps/details?id=com.hilexpertiz.mykeys.mykeys');
                    //Share.share('https://example.com', subject: "Partager l'application");
                  },
                  child: Row(
                    children: [
                      Icon(Icons.login,size: 22,color: Colors.red,),
                      SizedBox(width: 20),
                      Expanded(child: Text("Déconnexion",style: TextStyle(color: Colors.red),)),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
