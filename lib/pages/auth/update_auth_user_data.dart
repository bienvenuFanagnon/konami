import 'dart:convert';
import 'dart:math';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class UpdateAuthUserData extends StatefulWidget {
  final Utilisateur user;
  const UpdateAuthUserData({super.key, required this.user});

  @override
  State<UpdateAuthUserData> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<UpdateAuthUserData> {
  late String _selectedCountry="Burkina";
  List<String> _countryList = [];
  late TextEditingController nameController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController confpasswordController = TextEditingController();
  late TextEditingController codeParrainageController = TextEditingController();
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  bool onTap=false;


  @override
  void initState() {
    super.initState();
    _loadCountryList();
  }

  void _loadCountryList() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/countries.json');
    List<dynamic> countryList = jsonDecode(jsonString);
    setState(() {
      _countryList = List<String>.from(countryList);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 50.0),
              Image.asset(
                'assets/logoIcon.png',
                height: 100.0,
              ),
              SizedBox(height: 50.0),
              Text(
                'Ajouter un mot de passe à votre compte',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),

              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: confpasswordController,
                decoration: InputDecoration(
                  labelText: 'confirmer le mot de passe',
                  filled: true,
                  fillColor: Colors.white,
                ),

              ),

              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 45,
                  width: width*0.9,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                      onPressed: () async {
                        if(passwordController.text.length>1&& confpasswordController.text.length>1){

    if( passwordController.text.length>7){
      if( passwordController.text== confpasswordController.text){
        setState(() {
          onTap=true;
        });
        widget.user.password_locked=passwordController.text;
        await serviceProvider.updateUser(widget.user, context).then((value) {
          if(value){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('mot de passe ajouté'),
                backgroundColor: Colors.green,
              ),
            );
            confpasswordController.text="";
           passwordController.text="";
           Navigator.pop(context);
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("erreur lors de l'ajout du mot de passe"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },);


      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('les mots de passe ne correspondent pas'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          onTap=false;
        });
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Créer un mot de passe à 8 caractères'),
          backgroundColor: Colors.red,
        ),
      );
    }




                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('veuillez remplir tous les champs obligatoires'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          setState(() {
                            onTap=false;
                          });
                        }
                      },
                      child:onTap? Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ): Text("Ajouter",style: TextStyle(color: Colors.white),)),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
