import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late TextEditingController codeController = TextEditingController();
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);


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
                  labelText: 'Nom',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                items: _countryList
                    .map(
                      (country) => DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Pays',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.phone,

                decoration: InputDecoration(
                  labelText: 'Code de sécurité lors du demande de retrait',
                  filled: true,
                  fillColor: Colors.white,

                ),
              ),
              SizedBox(height: 20.0),
              TextButton(
                child: Text('S\'inscrire'),
                onPressed: () async {
                  if(nameController.text.length>1 && _selectedCountry.length>1){
               await     serviceProvider.createUser(nameController.text, _selectedCountry, codeController.text,widget.user_id,widget.phone, context);

               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Votre compte a été créé avec succès !'),
                   backgroundColor: Colors.green,
                 ),
               );
                  }else{
                    Fluttertoast.showToast(msg: 'Pas de donnee vide.',backgroundColor: Colors.red);

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
