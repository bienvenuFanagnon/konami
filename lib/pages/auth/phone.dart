import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:konami_bet/pages/auth/verify.dart';

import 'function.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static String verify ="";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  late String phone="";
  late bool _isLoading = false;
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
      });
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
    return Scaffold(
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
                    "Se Connecter",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Veuillez saisir votre numéro de téléphone valide pour se connecter ou créer un compte",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 40,
                          child: TextField(
                            controller: countryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                              onChanged: (value){
                                phone=value;
                                },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone",
                              ),
                            ))
                      ],
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
                            primary: Colors.green.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed:_isLoading ? null : () async {
                   if(phone.length>6){
                     setState(() {
                       _isLoading = true;
                     });
                    await sendOtpCode('${countryController.text+phone}');
                     phone="";

                     /*
                     await FirebaseAuth.instance.verifyPhoneNumber(
                       phoneNumber: '${countryController.text+phone}',
                       verificationCompleted: (PhoneAuthCredential credential) {
                         Fluttertoast.showToast(msg: 'Vérification réussie.');
                         print('Vérification réussie.');
                         print(credential.toString());
                         
                         setState(() {
                           phone="";
                           _isLoading = false;
                         });

                       },
                       verificationFailed: (FirebaseAuthException e) {
                         Fluttertoast.showToast(msg: 'Erreur de vérification : ${e.code}');
                         print('Erreur de vérification : ${e.code}');
                         print(e.toString());
                         setState(() {
                           phone="";
                           _isLoading = false;
                         });

                       },
                       codeSent: (String verificationId, int? resendToken) {
                         MyPhone.verify= verificationId;
                         setState(() {
                          // phone="";
                           _isLoading = false;
                         });

                         print( '${countryController.text+phone}');

                         Navigator.pushNamed(context, 'verify');
                       },
                       codeAutoRetrievalTimeout: (String verificationId) {},
                     );

                      */
                   }
                          //Navigator.pushNamed(context, 'verify');

                        },
                        child: Text("Envoyer le code",style: TextStyle(color: Colors.white),)),
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