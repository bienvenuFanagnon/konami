import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                    'assets/img1.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We need to register your phone without getting started!",
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
                           phone="";
                           _isLoading = false;
                         });

                         Navigator.pushNamed(context, 'verify');
                       },
                       codeAutoRetrievalTimeout: (String verificationId) {},
                     );
                   }
                          //Navigator.pushNamed(context, 'verify');

                        },
                        child: Text("Send the code")),
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