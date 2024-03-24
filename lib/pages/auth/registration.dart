import 'dart:convert';
import 'dart:math';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class RegistrationPage extends StatefulWidget {
  final String user_id;
  final String phone;
  const RegistrationPage({super.key, required this.user_id, required this.phone});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late String _selectedCountry="Burkina";
  List<String> _countryList = [];
  late TextEditingController nameController = TextEditingController();
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
                'Inscription',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Pseudo*',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: codeParrainageController,
                decoration: InputDecoration(
                  labelText: 'Code parrainage(optionel)',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              /*
              CSCPicker(

               // currentCountry: "TG",

                ///Enable disable state dropdown [OPTIONAL PARAMETER]
               // showStates: true,

                /// Enable disable city drop down [OPTIONAL PARAMETER]
               // showCities: true,

                ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
             //   flagState: CountryFlag.DISABLE,

                ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    border:
                    Border.all(color: Colors.grey.shade300, width: 1)),

                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                disabledDropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade300,
                    border:
                    Border.all(color: Colors.grey.shade300, width: 1)),

                ///placeholders for dropdown search field
                countrySearchPlaceholder: "Pays",
                stateSearchPlaceholder: "Region",
                citySearchPlaceholder: "Ville",

                ///labels for dropdown
                countryDropdownLabel: "Pays",
                stateDropdownLabel: "Region",
                cityDropdownLabel: "Ville",

                ///Default Country
               // defaultCountry: CscCountry.Togo,

                ///Country Filter [OPTIONAL PARAMETER]
              //  countryFilter: [CscCountry.India,CscCountry.United_States,CscCountry.Canada],

                ///Disable country dropdown (Note: use it with default country)
                //disableCountry: true,

                ///selected item style [OPTIONAL PARAMETER]
                selectedItemStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),

                ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                dropdownHeadingStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),

                ///DropdownDialog Item style [OPTIONAL PARAMETER]
                dropdownItemStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),

                ///Dialog box radius [OPTIONAL PARAMETER]
                dropdownDialogRadius: 10.0,

                ///Search bar radius [OPTIONAL PARAMETER]
                searchBarRadius: 10.0,

                ///triggers once country selected in dropdown
                onCountryChanged: (value) {
                  setState(() {
                    ///store value in country variable
                    countryValue = value;
                  });
                },

                ///triggers once state selected in dropdown
                onStateChanged: (value) {
                  setState(() {
                    ///store value in state variable
                    stateValue = value!;
                  });
                },

                ///triggers once city selected in dropdown
                onCityChanged: (value) {
                  setState(() {
                    ///store value in city variable
                    cityValue = value!;
                  });
                },

                ///Show only specific countries using country filter
                // countryFilter: ["United States", "Canada", "Mexico"],
              ),

               */
              CSCPicker(

                cityDropdownLabel: "Villes *",
                countryDropdownLabel: "Pays *",
                stateDropdownLabel: "Regions *",
                //currentCountry: "TG",
               // defaultCountry: CscCountry.Togo,
                searchBarRadius: width / 20,
                dropdownDialogRadius: width / 20,


                onCountryChanged: (value) {
                  countryValue = value.toString();

                  setState(() {


                  });
                },
                onStateChanged:(value) {
                  stateValue =value==null?"": value!.toString();
                  setState(() {


                  });
                },
                onCityChanged:(value) {
                  cityValue = value==null?"": value!.toString();

                  setState(() {

                  });


                },
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
                        if(nameController.text.length>1 && countryValue.length>1&& cityValue.length>1&& stateValue.length>1){
                          setState(() {
                            onTap=true;
                          });
                          await     serviceProvider.checkPseudo(nameController.text, context).then((value) async {
                            if (!value) {
                              Utilisateur user =Utilisateur();
                              user.pseudo=nameController.text;
                              user.pays=countryValue;
                              user.region=stateValue;
                              user.ville=cityValue;
                              user.role=RoleUser.USER.name;
                              user.demande_partenaire=StatusDemandePartenaire.NAN.name;
                              user.phoneNumber=widget.phone;

                              Random random = Random();

                              int randomNumber = random.nextInt(9999) + 1;
                              user.code_parrain= "${user.pseudo}${randomNumber}".toLowerCase();

                              if (codeParrainageController.text.length>1) {
                                await serviceProvider.getUserByCodeParrain(codeParrainageController.text.toLowerCase(),  context).then((value) {
                                  if (value) {
                                    user.code_user_parrainage=codeParrainageController.text;

                                  }
                                },);

                              }
                              await serviceProvider.createUser(user, widget.user_id, context);
                              Pseudo ps =Pseudo();
                              ps.nom= user.pseudo;
                              await serviceProvider..createPseudo(ps);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Votre compte a été créé avec succès !'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              setState(() {
                                onTap=false;
                              });
                            }  else{

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Ce pseudo est déjà utilisé par un autre utilisateur.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() {
                                onTap=false;
                              });
                            }
                          },);


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
                      ): Text("S'inscrire",style: TextStyle(color: Colors.white),)),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
