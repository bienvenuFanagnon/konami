import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:konami_bet/pages/auth/verify.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import 'function.dart';

class UserPassword extends StatefulWidget {
  final Utilisateur user;
  const UserPassword({Key? key, required this.user}) : super(key: key);
  static String verify ="";

  @override
  State<UserPassword> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<UserPassword> {
  TextEditingController countryController = TextEditingController();
  late String phone="";
  late bool isValidPhoneNumber=false;
  late bool _isLoading = false;
  late TextEditingController passwordController = TextEditingController();

  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  showErrorDialog(BuildContext context,String text) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: true,
      dialogType: DialogType.error,
      showCloseIcon: true,
      title: "Envoi code SMS",
      desc:
      text,
      btnCancelOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.error,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();

  }
  sendOtpCode(String phone) {
    //onTap = true;
    setState(() {
      _isLoading = true;
    });
    final _auth = FirebaseAuth.instance;
    if (isValidPhoneNumber) {
      if (phone.isNotEmpty) {

        // notData=false;

        authWithPhoneNumber(phone, onCodeSend: (verificationId, v) {
          //  onTap = false;
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (c) => VerificationOtp(
                verificationId: verificationId,
                phoneNumber: phone,
              )));
        }, onAutoVerify: (v) async {
          await _auth.signInWithCredential(v);
          setState(() {
            _isLoading = false;
          });
          //   Navigator.of(context).pop();
        },  onFailed: (e) {
          //    onTap = false;
          setState(() {
            _isLoading = false;
          });
          var errorMessage = "An error occurred";
          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = 'Le numéro de téléphone saisi est invalide.';
              break;
            case 'too-many-requests':
              errorMessage = 'Vous avez fait trop de demandes. Veuillez réessayer plus tard.';
              break;
            default:
              errorMessage = 'Une erreur inconnue est survenue. Veuillez réessayer plus tard';
          //errorMessage = e.toString();
          }
          showErrorDialog( context, errorMessage);
          print(" erreur : ${e.toString()}");
        }, autoRetrieval: (v) {});
      }else{
        //onTap = false;
        // notData=true;
        setState(() {
          _isLoading = false;
          isValidPhoneNumber=false;
        });
      }
    }

  }

  sendOtpCode2(String phone) async {
    //onTap = true;
    setState(() {
      _isLoading = true;
    });
    final _auth = FirebaseAuth.instance;
    if (isValidPhoneNumber) {
      if (phone.isNotEmpty) {
        /*
        serviceProvider.getUserByPhone(phone).then((users) {
          if(users.isNotEmpty){

          }
        },)
                  showErrorDialog( context, errorMessage);

         */
        final random = Random.secure();

        int nombreAleatoire = random.nextInt(9000) + 1000;
        serviceProvider.smsCode=0;

        serviceProvider.smsCode=nombreAleatoire;
        await  serviceProvider.getUserByPhone(phone).then((users) async {
          if(users.isNotEmpty){
            if(users.first.is_connected!=null) {
              users.first.is_connected=false;

            }

            if(users.first.oneIgnalUserid.toString()!=OneSignal.User.pushSubscription.id!.toString()) {

              if(users.first.is_connected!) {

              }else{
                await serviceProvider
                    .sendNotification([users.first.oneIgnalUserid!=null&&users.first.oneIgnalUserid!.isNotEmpty?users.first.oneIgnalUserid!:OneSignal.User.pushSubscription.id!],
                    "📢 Code:  ${nombreAleatoire}")
                    .then((value) {
                  if(value){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => VerificationOtp(
                          verificationId: "verificationId",
                          phoneNumber: phone,
                        )));

                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(

                      SnackBar(
                        backgroundColor: Colors.red,

                        content: Text("Erreur d'envoi du code! Veuillez réessayer.",style: TextStyle(color: Colors.white),),
                      ),
                    );

                  }
                },);

              }

            }else{
              await serviceProvider
                  .sendNotification([users.first.oneIgnalUserid!=null&&users.first.oneIgnalUserid!.isNotEmpty?users.first.oneIgnalUserid!:OneSignal.User.pushSubscription.id!],
                  "📢 Code:  ${nombreAleatoire}")
                  .then((value) {
                if(value){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => VerificationOtp(
                        verificationId: "verificationId",
                        phoneNumber: phone,
                      )));

                }else{
                  ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(
                      backgroundColor: Colors.red,

                      content: Text("Erreur d'envoi du code! Veuillez réessayer.",style: TextStyle(color: Colors.white),),
                    ),
                  );

                }
              },);

            }



          }else{
            await serviceProvider
                .sendNotification([OneSignal.User.pushSubscription.id!],
                "📢 Code:  ${nombreAleatoire}")
                .then((value) {
              if(value){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => VerificationOtp(
                      verificationId: "verificationId",
                      phoneNumber: phone,
                    )));


              }else{
                ScaffoldMessenger.of(context).showSnackBar(

                  SnackBar(
                    backgroundColor: Colors.red,

                    content: Text("Erreur d'envoi du code! Veuillez réessayer.",style: TextStyle(color: Colors.white),),
                  ),
                );

              }
            },);




          }

        },);

        setState(() {
          _isLoading = false;
          isValidPhoneNumber=false;
        });



      }else{
        //onTap = false;
        // notData=true;
        setState(() {
          _isLoading = false;
          isValidPhoneNumber=false;
        });
      }
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+228";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/login.png',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Votre mot de passe",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Veuillez saisir votre mot de passe valide pour se connecter",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed:_isLoading ? null : () async {
                     if(passwordController.text.isNotEmpty){
                       setState(() {
                         _isLoading = true;
                       });
    if(passwordController.text==widget.user.password_locked){
      await  serviceProvider.getUserById( widget.user.id_db!,widget.user.phoneNumber!, context);
      setState(() {
        _isLoading = false;
      });
    }else{
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('mot de passe incorrect'),
          backgroundColor: Colors.red,
        ),
      );
    }


                     }else{
                       setState(() {
                         _isLoading = false;
                       });
                     }
                            //Navigator.pushNamed(context, 'verify');

                          },
                          child: Text("Se Connecter",style: TextStyle(color: Colors.white),)),
                    )
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.white70,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.green,),
                  ),
                ),
              ),
          ],
        ),
      );

  }
}