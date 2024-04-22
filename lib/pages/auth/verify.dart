import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void onVerifySmsCode() async {
    loading = true;
    setState(() {});
    await validateOtp(smsCode, widget.verificationId,context);
    loading = false;

    setState(() {});
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
                Text(
                  "Veuillez entrer le code que vous venez de recevoir sur votre numéro de téléphone ${widget.phoneNumber}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Pinput(
                  length: 6,
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
                        onPressed: smsCode.length < 6 || loading
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
