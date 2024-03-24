import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/pages/history.dart';
import 'package:konami_bet/pages/profil/pari/user_pari.dart';
import 'package:konami_bet/pages/profil/wallet/homeWallet.dart';
import 'package:konami_bet/pages/profil_partenaire/devenir_partenaire.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
             height: 100,
             width: 100,
             decoration: BoxDecoration(
               color: Colors.green,
               borderRadius: BorderRadius.all(Radius.circular(200))
             ),
             child: Padding(
               padding: const EdgeInsets.all(30),
               child: Text("${serviceProvider.loginUser.pseudo}".substring(0, 1).toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30),),
             ),
           ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${serviceProvider.loginUser.pseudo}".toUpperCase(),style: TextStyle(fontSize: 20),),
                Text("${serviceProvider.loginUser.is_partenaire!?"Partenaire ":"Particulier"}",style: TextStyle(fontSize: 12,color:serviceProvider.loginUser.is_partenaire!?Colors.green:Colors.red ),),

              ],
            ),
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
                    child: Center(child:
                    Row(
                      children: [
                        Text("Code : ${serviceProvider.loginUser.code_parrain==null?"pas de code":serviceProvider.loginUser.code_parrain}".toUpperCase()),

                        SizedBox(width: 10,),
                        ElevatedButton(
                            onPressed: () {
                          Clipboard.setData(ClipboardData(text: serviceProvider.loginUser.code_parrain.toString().toUpperCase()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('code copié dans le presse-papiers'),
                          ));
                        },
                            child: Text("Copier")),
                      ],
                    )
                    )
                ),

              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("parrainées : ".toUpperCase()),

                SizedBox(width: 10,),
                Text("${serviceProvider.loginUser.nombre_parrainage}".toUpperCase(),style: TextStyle(color: Colors.green),),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 40,
                width: width*0.8,
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {

                    },
                    child: Text("Veuillez valider votre compte !",style: TextStyle(color: Colors.white),)),
              ),
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
                    if (!serviceProvider.loginUser.is_partenaire!) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DevenirPartenaire(),));

                    }
                    // Navigator.pushNamed(context, "/subscription");


                    // Share.share('https://play.google.com/store/apps/details?id=com.hilexpertiz.mykeys.mykeys');
                    //Share.share('https://example.com', subject: "Partager l'application");
                  },
                  child: Row(
                    children: [
                      Icon(MaterialIcons.supervised_user_circle,size: 22,color: Colors.green,),
                      SizedBox(width: 20),
                      Expanded(child: Text("${!serviceProvider.loginUser.is_partenaire!?"Comment devenir partenaire ?":"Mon Compte Partenaire"}",style: TextStyle(color:!serviceProvider.loginUser.is_partenaire!?Colors.red: Colors.black),)),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWallet(),));
                    // Navigator.pushNamed(context, "/subscription");


                    // Share.share('https://play.google.com/store/apps/details?id=com.hilexpertiz.mykeys.mykeys');
                    //Share.share('https://example.com', subject: "Partager l'application");
                  },
                  child: Row(
                    children: [
                      Icon(FontAwesome.info_circle,size: 22,color: Colors.green,),
                      SizedBox(width: 20),
                      Expanded(child: Text("Comment ça marche?",style: TextStyle(color: Colors.black),)),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWallet(),));
                    // Navigator.pushNamed(context, "/subscription");


                    // Share.share('https://play.google.com/store/apps/details?id=com.hilexpertiz.mykeys.mykeys');
                    //Share.share('https://example.com', subject: "Partager l'application");
                  },
                  child: Row(
                    children: [
                      Icon(MaterialIcons.contact_mail,size: 22,color: Colors.green,),
                      SizedBox(width: 20),
                      Expanded(child: Text("Contact",style: TextStyle(color: Colors.black),)),
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
                    serviceProvider.deleteToken().then((value) {
                      if (value!) {
                        Navigator.pushNamed(context, "phone");

                      }  else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erreur de déconnexiont"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },);

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
