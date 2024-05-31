import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konami_bet/pages/auth/registration.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import 'function.dart';


class VerificationOtp extends StatefulWidget {

  const VerificationOtp(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);
  final String verificationId;
  final String phoneNumber;



  @override
  State<VerificationOtp> createState() => _VerificationOtpState();
}

class _VerificationOtpState extends State<VerificationOtp> {
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  String smsCode = "";
  bool loading = false;
  bool resend = false;
  int count = 20;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final _auth = FirebaseAuth.instance;


// Méthode pour récupérer l'UID de l'utilisateur après vérification SMS et vérifier s'il existe dans Firestore
  Future<void> checkUserAndRedirect(String email) async {

    User? user = _auth.currentUser;

    if (user != null && user.phoneNumber != null) {
      // Récupérer l'UID de l'utilisateur actuel
      String uid = user.uid;

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore
          .collection('Utilisateur') // Remplacez par le nom de votre collection
          .where('id_db', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot userDocument = querySnapshot.docs.first;
        // Ici, vous pouvez accéder aux données de l'utilisateur via userDocument.data()
        showWarningDialog(_scaffoldKey!.currentContext!,"Ce compte existe déjà");
        print('Utilisateur existe');
        loading = false;
      } else {

        loading = false;
      }

    } else {
      // L'utilisateur n'est pas connecté ou le numéro de téléphone n'est pas disponible

    }
  }

  showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: true,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Succes',
      desc:
      'Vérification réussie',
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();

  }
  showErrorDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: true,
      dialogType: DialogType.error,
      showCloseIcon: true,
      title: 'Error',
      desc:
      'Erreur de verification',
      btnCancelOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.error,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();

  }
  showWarningDialog(BuildContext context,String msg) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: true,
      dialogType: DialogType.warning,
      showCloseIcon: true,
      title: 'Warning',
      desc:
      msg,
      btnCancelOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.warning,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();

  }

  @override
  void initState() {
    super.initState();
    decompte();
  }

  late Timer timer;

  void decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (count < 1) {
        timer.cancel();
        count = 20;
        resend = true;
        setState(() {});
        return;
      }
      count--;
      setState(() {});
    });
  }

  void onResendSmsCode() {
    resend = false;
    setState(() {});
    authWithPhoneNumber(widget.phoneNumber, onCodeSend: (verificationId, v) {
      loading = false;
      decompte();
      setState(() {});
    }, onAutoVerify: (v) async {
      await _auth.signInWithCredential(v);
      Navigator.of(context).pop();
    }, onFailed: (e) {
      loading = false;
      setState(() {});
      showErrorDialog(_scaffoldKey!.currentContext!);
      print("Le code est erroné");
    }, autoRetrieval: (v) {});
  }
  Future<void> onResendSmsCode2() async {
    resend = false;
    loading = false;
    try{
      decompte();
      setState(() {});
      final random = Random.secure();

      int nombreAleatoire = random.nextInt(9000) + 1000;
      serviceProvider.smsCode=0;
      serviceProvider.smsCode=nombreAleatoire;

      serviceProvider.getUserByPhone(widget.phoneNumber).then((users) async {
        if(users.isNotEmpty){
          await serviceProvider
              .sendNotification([users.first.oneIgnalUserid!=null&&users.first.oneIgnalUserid!.isNotEmpty?users.first.oneIgnalUserid!:OneSignal.User.pushSubscription.id!],
              "📢 Code:  ${nombreAleatoire}")
              .then((value) {
            if(value){

            }else{
              ScaffoldMessenger.of(context).showSnackBar(

                SnackBar(
                  backgroundColor: Colors.red,

                  content: Text("Erreur d'envoi du code! Veuillez réessayer.",style: TextStyle(color: Colors.white),),
                ),
              );

            }
          },);



        }else{
          await serviceProvider
              .sendNotification([OneSignal.User.pushSubscription.id!],
              "📢 Code:  ${nombreAleatoire}")
              .then((value) {
                if(value){

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



      loading = false;
      setState(() {});

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          backgroundColor: Colors.red,

          content: Text("Erreur d'envoi du code! Veuillez réessayer.",style: TextStyle(color: Colors.white),),
        ),
      );

    }


  }

  void onVerifySmsCode() async {
    try{
      loading = true;
      setState(() {});
      await validateOtp(smsCode, widget.verificationId,context);
      loading = false;

      setState(() {});
    }catch(e){
      loading = false;

      setState(() {});
    }

   // showSuccessDialog(_scaffoldKey!.currentContext!);
    //checkUserAndRedirect("${widget.phoneNumber!}"+"@gmail.com");
    // Navigator.of(context).pop();
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SignUpFormEtap3();
        },
      ),
    );

     */

  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void onVerifySmsCode2() async {
    try{
      loading = true;
      setState(() {});
      //  await validateOtp(smsCode, widget.verificationId,context);

      if(serviceProvider.smsCode.toString()==smsCode){
        serviceProvider.getUserByPhone(widget.phoneNumber!).then((value) async {
          if(value.isNotEmpty){
            await  serviceProvider.getUserById( value.first.id_db!,widget.phoneNumber!, context);

          } else {
            String id = firestore
                .collection('Utilisateur')
                .doc()
                .id;
            Navigator.pushReplacement(
                context,
                CupertinoDialogRoute(
                    builder: (context) => RegistrationPage(
                      user_id: id,
                      phone: widget.phoneNumber!,
                    ),
                    context: context));

            //Navigator.pushNamed(context, 'register');
          }
        },);

      }else{
        //   print("code1 : ${serviceProvider.smsCode}");
        //  print("code2 : ${smsCode}");
        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            backgroundColor: Colors.red,

            content: Text('Le code est erroné! Veuillez réessayer.',style: TextStyle(color: Colors.white),),
          ),
        );
      }

    }catch(e){
      loading = false;

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          backgroundColor: Colors.red,

          content: Text("Erreur de vérification! Veuillez réessayer.",style: TextStyle(color: Colors.white),),
        ),
      );
    }



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          elevation:0
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height*0.2,
                    child: Image.asset(
                      "assets/logoIcon.png",
                      fit: BoxFit.contain,
                    )
                ),

                const Text(
                  "Verification de Code",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                /*
                Text(
                  "Veuillez entrer le code que vous venez de recevoir sur votre numéro de téléphone ${widget.phoneNumber}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),

                 */
                Text(
                  "Veuillez saisir le code reçu par notification",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Pinput(
                  length: 4,
                  onChanged: (value) {
                    smsCode = value;
                    setState(() {});
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: !resend ? null : onResendSmsCode,
                    child: Text(!resend
                        ? "00:${count.toString().padLeft(2, "0")}"
                        : "resend code",style: TextStyle(color: Colors.blue),),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 50,
                      width: 400,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 15)),
                        onPressed: smsCode.length < 4 || loading
                            ? null
                            : onVerifySmsCode,
                        child: loading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                            : const Text(
                          'Vérifier',
                          style: TextStyle(fontSize: 15,color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
