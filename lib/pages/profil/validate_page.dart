
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';




class ValidateCompte extends StatefulWidget {

  @override
  State<ValidateCompte> createState() => _NewAppInfoState();
}

class _NewAppInfoState extends State<ValidateCompte> {
  final _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController codeController = TextEditingController();

  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool onTap = false;

  late XFile? imageProfile= XFile('');
  late XFile? imageCard= XFile('');

  final ImagePicker picker = ImagePicker();

  late List<String> commentCaMarche=["Comment ca marche?","Comment ca marche?","Comment ca marche?","Comment ca marche?"];

  Future<void> _getImageProfile() async {
    await picker.pickImage(source: ImageSource.gallery).then((images) {
      // Mettre à jour la liste des images
      setState(() {
        imageProfile =
        images!;
      });
    });
  }Future<void> _getImageCard() async {
    await picker.pickImage(source: ImageSource.gallery).then((images) {
      // Mettre à jour la liste des images
      setState(() {
        imageCard =
        images!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: AppBar(
        title: Text('Valider et sécuriser votre compte'),
      ),

      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: ExpansionTile(
                    title: Text("A Lire",   style: TextStyle(
                      color: Colors.red,
                    ),),
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '**Sécuriser vos fonds et vos informations personnelles.**',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '**Protéger votre compte contre les accès non autorisés.**',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ), Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '**Pouvoir récupérer votre compte en cas de problème.**',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],

                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Formulaire',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),

                TextFormField(
                  controller: codeController,
                  decoration: InputDecoration(
                    hintText: "Code pin",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Le code pin est obligatoire';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Confirmation",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'La confirmation est obligatoire';
                    }
                    if (value!=codeController.text) {
                      return 'Le code PIN et la confirmation ne correspondent pas.';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _numeroController,
                  decoration: InputDecoration(
                    hintText: "Numero de carte d'identité",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Le Numero de carte d'identité est obligatoire";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),



                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _getImageCard();
                      },
                      child: Container(
                        height: 40,

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.add_circle_outlined),
                              ),
                              SizedBox(width: 5,),
                              Text("Carte nationale d'identité(recto/verso)",style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    imageCard!.path.length>1
                        ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(

                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Image.file(
                              File(imageCard!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                    )
                        : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Icon(Entypo.v_card,size: 50,),
                      ),
                    ),
                  ],
                ),



                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Vous acceptez d'être lié par les Termes et conditions d'utilisation"),
                ),
                SizedBox(
                  height: height*0.12,
                ),

              ],
            ),
          ),
        ),
      ),
      bottomSheet:    Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
              onTap:onTap?(){}:() async {
                //_getImages();
                if (_formKey.currentState!.validate()) {

                  setState(() {
                    onTap=true;
                  });

                  try {

                    // infos.description = _descriptionController.text;


                    if (imageCard!.path.length>1) {
                      serviceProvider.loginUser.codePinSecurity = codeController.text;
                      serviceProvider.loginUser.numero_carte_identite = _numeroController.text;
                      serviceProvider.loginUser.is_valide=true;




                        Reference storageReference =
                        FirebaseStorage.instance.ref().child(
                            'media_users/${Path.basename(File(imageCard!.path).path)}');

                        UploadTask uploadTask = storageReference
                            .putFile(File(imageCard!.path)!);
                        await uploadTask.whenComplete(() async {
                          await storageReference
                              .getDownloadURL()
                              .then((fileURL) {
                            print("url media");
                            //  print(fileURL);

                            serviceProvider.loginUser.photo=fileURL;
                          });
                        });


                      await serviceProvider.updateUser( serviceProvider.loginUser, context);

                      _numeroController.text='';
                      _prenomController.text='';
                      codeController.text='';
                      imageProfile=XFile("");
                      imageCard=XFile("");
                      setState(() {
                        onTap=false;
                      });


                      SnackBar snackBar = SnackBar(
                        content: Text(
                          "La demande a été validé avec succès !",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green),
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      Navigator.pop(context);

                    }else{
                      setState(() {
                        onTap=false;
                      });
                      SnackBar snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          ' Veuillez remplir tous les champs.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                    }


                  } catch (e) {
                    print("erreur ${e}");
                    setState(() {
                      onTap=false;
                    });
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        'La validation  a échoué. Veuillez réessayer.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                  }
                }

              },
              child:onTap? Center(
                  child: Container(child: CircularProgressIndicator(),)
              ): Container(
                height: 60,
                width: width*8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Text("Valider votre compte",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
              )),
        ),
      ),
    );
  }
}
