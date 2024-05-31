import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../providers/providers.dart';
import 'package:provider/provider.dart';

final _auth = FirebaseAuth.instance;
void authWithPhoneNumber(String phone,
    {required Function(String value, int? value1) onCodeSend,
      required Function(PhoneAuthCredential value) onAutoVerify,
      required Function(FirebaseAuthException value) onFailed,
      required Function(String value) autoRetrieval}) async {
  _auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: const Duration(seconds: 20),
    verificationCompleted: onAutoVerify,
    verificationFailed: onFailed,
    codeSent: onCodeSend,
    codeAutoRetrievalTimeout: autoRetrieval,
  );
}

Future<bool> validateOtp(String smsCode, String verificationId,BuildContext context) async {

  try{
    late ServiceProvider serviceProvider =
    Provider.of<ServiceProvider>(context, listen: false);
    final _credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    UserCredential userAuth= await _auth.signInWithCredential(_credential);
    await  serviceProvider.getUserById( userAuth.user!.uid!,userAuth.user!.phoneNumber!, context);
    //serviceProvider.storeToken( userAuth.user!.uid!);

    return true;

  }catch(e){
    return false;


  }

}

Future<void> disconnect() async {
  await _auth.signOut();
  return;
}

User? get user => _auth.currentUser;

