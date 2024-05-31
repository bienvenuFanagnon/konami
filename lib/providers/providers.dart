import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:konami_bet/pages/auth/registration.dart';
import 'package:konami_bet/services/database.dart';
import 'package:konami_bet/services/soccer_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'equipe_provider.dart';

class ServiceProvider extends ChangeNotifier {
  late VerificationDuLancementService verificationDuLancementService =
      VerificationDuLancementService();
  late MiseAJourMatchesService miseAJourMatchesService =
      MiseAJourMatchesService();
  late int smsCode=0;
  late MatchService matchService = MatchService();
  late PariService pariService = PariService();
  late Utilisateur loginUser = Utilisateur();
  late Utilisateur matchUser = Utilisateur();
  late Utilisateur userVerify = Utilisateur();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late UtilisateurService utilisateurService = UtilisateurService();
  late String? token = '';
  Future<void> storeIsFirst(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirst', value);
  }

  Future<bool?> getIsFirst() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // token = prefs.getString('token');
    // print("get token : ${token}");
    //notifyListeners();
    return prefs.getBool('isFirst');
  }

  Future<void> storeToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', value);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // print("get token : ${token}");
    //notifyListeners();
    return prefs.getString('token');
  }

  Future<bool?> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("get token : ${token}");
    //notifyListeners();
    return prefs.remove('token');
  }

  creerPari(Pari pari) {
    pariService.create(pari);
    notifyListeners();
  }

  Future<bool> createUser(
      Utilisateur u, String id, BuildContext context) async {
    try {
      print("error1");
      await utilisateurService.create(u, id);
      print("error2");
      getChargementUserById(id, context);
      // Navigator.pushNamed(context, 'phone');
      return true;
    } catch (e) {
      return false;
      print(e.toString());
    }

    notifyListeners();
  }

  Future<List<String>> getAllUsersOneSignaUserId() async {
    late List<Utilisateur> list = [];

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Utilisateur');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get().then((value) {
      return value;
    }).catchError((onError) {});

    // Get data from docs and convert map to List
    list = querySnapshot.docs
        .map((doc) => Utilisateur.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
            late List<String> listOSUserid = [];

    for (Utilisateur u in list) {
      if (u.oneIgnalUserid!.length>5) {
              listOSUserid.add(u.oneIgnalUserid!);

      }
    }

    return listOSUserid;
  }

  getUserById(String id, String phone, BuildContext context) async {
    List<Utilisateur> listu = [];

    listu = await utilisateurService.getUserById(id);
    if (listu.isNotEmpty) {
      this.loginUser = Utilisateur();
      this.loginUser = listu[0];
      print("OneSignal=====");


      print("OneSignal id : ${OneSignal.User.pushSubscription.id}");
      print("OneSignal token : ${OneSignal.User.pushSubscription.token}");

      this.loginUser.oneIgnalUserid = OneSignal.User.pushSubscription.id;
      updateUser(this.loginUser, context);
      print("user data providers");
      print("user data : ${this.loginUser.toJson()}");
      print(this.loginUser.id_db);
      storeToken(loginUser!.id_db!);

      if (loginUser.is_blocked!) {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Votre compte a été bloqué',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Suite à des violations de confidentialité, votre compte a été bloqué. Veuillez nous contacter pour la résolution.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'contact');

                        // Ouvrir une page de contact
                      },
                      child: Text(
                        'Contactez-nous',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              );
            });
      } else {
        Navigator.pushReplacementNamed(context, '/');
      }
      // notifyListeners();
    } else {
      Navigator.pushReplacement(
          context,
          CupertinoDialogRoute(
              builder: (context) => RegistrationPage(
                    user_id: id,
                    phone: phone,
                  ),
              context: context));

      //Navigator.pushNamed(context, 'register');
    }
//  notifyListeners();
  }

  Future<Utilisateur> getMatchUserById(String id, BuildContext context) async {
    List<Utilisateur> listu = [];
    this.matchUser = Utilisateur();
    listu = await utilisateurService.getUserById(id);
    if (listu.isNotEmpty) {
      this.matchUser = listu.first;
      // notifyListeners();
    } else {
      this.matchUser = Utilisateur();
    }
    return this.matchUser;
//  notifyListeners();
  }

  getChargementUserById(String id, BuildContext context) async {
    List<Utilisateur> listu = [];
    try {
      listu = await utilisateurService.getUserById(id);
      if (listu.isNotEmpty) {
        this.loginUser = Utilisateur();
        this.loginUser = listu[0];
        this.loginUser.oneIgnalUserid ="";

  this.loginUser.oneIgnalUserid = OneSignal.User.pushSubscription.id;

        print("OneSignal=====");


        //this.loginUser.oneIgnalUserid = this.loginUser.id_db!;
        updateUser(this.loginUser, context);
        print("user data providers");
        print("user data : ${this.loginUser.toJson()}");
        // print( this.loginUser.id_db);
        storeToken(loginUser!.id_db!);

        if (loginUser.is_blocked!) {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Votre compte a été bloqué',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Suite à des violations de confidentialité, votre compte a été bloqué. Veuillez nous contacter pour la résolution.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'contact');

                          // Ouvrir une page de contact
                        },
                        child: Text(
                          'Contactez-nous',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else {
          Navigator.pushReplacementNamed(context, '/');
        }

        // notifyListeners();
      } else {
        //  Navigator.push(context, CupertinoDialogRoute(builder: (context) => RegistrationPage(user_id: id,), context: context));

        Navigator.pushReplacementNamed(context, 'phone');
      }
    } catch (e) {
      Navigator.pushReplacementNamed(context, 'phone');
    }

//  notifyListeners();
  }

  Future<bool> getUserByCodeParrain(
      String codeParrain, BuildContext context) async {
    List<Utilisateur> listu = [];
    Utilisateur userParrain = Utilisateur();
    try {
      listu = await utilisateurService.getUserByPseudoCode(codeParrain);
      if (listu.isNotEmpty) {
        userParrain = listu[0];
        print("user data providers");
        print("user parrain data : ${this.loginUser.toJson()}");
        userParrain.nombre_parrainage = userParrain.nombre_parrainage! + 1;

        updateUser(userParrain, context);

        return true;

        // notifyListeners();
      } else {
        //  Navigator.push(context, CupertinoDialogRoute(builder: (context) => RegistrationPage(user_id: id,), context: context));
        return false;
      }
    } catch (e) {
      return false;
    }

//  notifyListeners();
  }

  Future<bool> getUserAndOperation(
      String codeParrain, BuildContext context) async {
    print("user parrain code : ${codeParrain}");

    late EquipeProvider equipeProvider =
        Provider.of<EquipeProvider>(context, listen: false);
    List<Utilisateur> listu = [];
    Utilisateur userParrain = Utilisateur();
    try {
      listu = await utilisateurService.getUserByPseudoCode(codeParrain);
      if (listu.isNotEmpty) {
        userParrain = listu[0];
        print("user data providers");
        print("user parrain data : ${userParrain.toJson()}");
        if (userParrain.nombre_parrainage! > 19) {
          if (userParrain.is_partenaire!) {
            userParrain.nombre_pari_parrainage =
                userParrain.nombre_pari_parrainage! + 1;
            if (userParrain.nombre_pari_parrainage! > 99) {
              userParrain.montant_compte_parrain =
                  userParrain.montant_compte_parrain! + 2000;
              await getAppData().then(
                (appdatas) async {
                  if (appdatas.isNotEmpty) {
                    appdatas.first.adminSolde =
                        appdatas.first.adminSolde - 2000;
                    await updateAppData(appdatas.first, context);
                  }
                },
              );
              userParrain.nombre_pari_parrainage = 0;
              TransactionData transaction =
                  TransactionData(// Pending, validated, or rejected
                      );
              //transaction.id="";
              transaction.user_id = userParrain.id_db!;
              transaction.type = TypeTransaction.DEPOT.name;
              transaction.depotType = TypeTranDepot.INTERNE.name;
              transaction.type_compte = TypeCompte.PARTENAIRE.name;

              transaction.montant = 2000;
              transaction.status = TransactionStatus.VALIDER.name;
              transaction.createdAt = DateTime.now().millisecondsSinceEpoch;
              transaction.updatedAt = DateTime.now().millisecondsSinceEpoch;
              await equipeProvider.createTransaction(transaction);
              if(userParrain.oneIgnalUserid!.length>5){
                await sendNotification([userParrain.oneIgnalUserid!],
                    "🤑 Un depot de : 2000 fcfa sur le compte partenaire! ✨");
              }

            }
          }
        }

        updateUser(userParrain, context);

        return true;

        // notifyListeners();
      } else {
        //  Navigator.push(context, CupertinoDialogRoute(builder: (context) => RegistrationPage(user_id: id,), context: context));
        return false;
      }
    } catch (e) {
      return false;
    }

//  notifyListeners();
  }

  Future<List<Utilisateur>> getUserByPhone(String phone) async {
    late List<Utilisateur> list= [];


    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('Utilisateur');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.where("phoneNumber",isEqualTo: phone!).get()
        .then((value){
      print("Utilisateur");
      print(value);
      return value;
    }).catchError((onError){

    });

    // Get data from docs and convert map to List
    list = querySnapshot.docs.map((doc) =>
        Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();


    return list;

  }


  Future<bool> getUserByIdContente(String id, BuildContext context) async {
    List<Utilisateur> listu = [];

    listu = await utilisateurService.getUserById(id);
    if (listu.isNotEmpty) {
      this.loginUser = Utilisateur();
      this.loginUser = listu[0];
      print("user data providers");
      print("user data : ${this.loginUser.toJson()}");
      print(this.loginUser.id_db);
      return true;
      // notifyListeners();
    } else {
      return false;
    }
//  notifyListeners();
  }

  Future<bool> updateUser(Utilisateur user, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Utilisateur')
          .doc(user.id_db)
          .update(user.toJson());

      return true;
    } catch (e) {
      print("erreur update post : ${e}");
      return false;
    }
  }

  Stream<Utilisateur> getOnLyStreamUser(String id) async* {
    var pariStream = FirebaseFirestore.instance
        .collection('Utilisateur')
        .where("id_db", isEqualTo: '${id}')
        //  .where("status",isNotEqualTo:'${PariStatus.PARIER.name}')
        // .where("dataType",isEqualTo:'${PostDataType.IMAGE.name}')
        //.orderBy('createdAt', descending: true)

        .snapshots();
    Utilisateur user = Utilisateur();

    //  UserData userData=UserData();
    await for (var snapshot in pariStream) {
      for (var post in snapshot.docs) {
        //  print("post : ${jsonDecode(post.toString())}");
        user = Utilisateur.fromJson(post.data());

        //  listPari=paries;
      }
      yield user;
    }
  }

  creatAllMatchByApi() async {
    String date =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    /*
     List<Matches> listMatchDb = [];
     listMatchDb = await matchService.getAllMatches();
     bool isUpdate=false;




     if(listMatchDb.isNotEmpty){
       //mise a jours
    if(listMatchDb[0].id_db!.length!>5){
      listMatchApi = await  footballDataApi.fetchSoccerList();

        if (listMatchApi.isNotEmpty) {
          for (final item1 in listMatchDb) {
            for (final item2 in listMatchApi) {

              if (item1.id == item2.id) {
                print("mise a jour");
                Matches match = item2;
                match.id_db = item1.id_db;
                matchService.update(match.id_db!, match.toJson());
                isUpdate=true;
              }else{
                print("match n existe plus");


              }
            }
          }
          if(isUpdate=false){
            //supprimer tout les matches
            matchService.deleteAllData();
          }
        }else{
          print("pas de donnee de l api");
        }

    }else{
      //supprimer tout les matches
      matchService.deleteAllData();
      //creer des match
      listMatchApi = await  footballDataApi.fetchSoccerList();
      if(listMatchApi.isNotEmpty){
        for(final item in listMatchApi){
          await matchService.create(item);
        }
      }


    }


     }
     else{
       //creer des match
       listMatchApi = await  footballDataApi.fetchSoccerList();
       if(listMatchApi.isNotEmpty){
         for(final item in listMatchApi){
           await matchService.create(item);
         }
       }
     }



     print("les datas provider");
     //print(listMatchApi.toString());

      */
    notifyListeners();
  }

  Future<Pari> getOnlyPari(String id) async {
    //await getAppData();
    late List<Pari> list = [];

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('PariEnCours');
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await collectionRef.where("id", isEqualTo: id!).get().then((value) {
      print(value);
      return value;
    }).catchError((onError) {});

    // Get data from docs and convert map to List
    list = querySnapshot.docs
        .map((doc) => Pari.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    return list.first;
  }

  Future<bool> checkPseudo(String id, BuildContext context) async {
    late List<Pseudo> list = [];
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('Pseudos');
      // Get docs from collection reference
      QuerySnapshot querySnapshot =
          await collectionRef.where("nom", isEqualTo: id!).get().then((value) {
        print(value);
        return value;
      });

      // Get data from docs and convert map to List
      list = querySnapshot.docs
          .map((doc) => Pseudo.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) {
        return true;
        // notifyListeners();
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
//  notifyListeners();
  }

  Future<bool> createPseudo(Pseudo data) async {
    String id = firestore.collection('Pseudos').doc().id;
    data.id = id;
    bool status = false;

    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          FirebaseFirestore.instance.collection('Pseudos').doc(id);
      docRef.set(data.toJson());

      //  await firestore.collection('Matches').doc(id).set(data.toJson());
      print("///////////-- SAVE pseudo --///////////////");
      return true;
    } on FirebaseException catch (error) {
      return false;
    }
  }

  Future<bool> createAppData(AppData data) async {
    String id = firestore.collection('AppData').doc().id;
    data.id = id;
    bool status = false;

    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          FirebaseFirestore.instance.collection('AppData').doc(id);
      docRef.set(data.toJson());

      //  await firestore.collection('Matches').doc(id).set(data.toJson());
      print("///////////-- SAVE appdata --///////////////");
      return true;
    } on FirebaseException catch (error) {
      return false;
    }
  }

  Future<List<AppData>> getAppData() async {
    late List<AppData> list = [];
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('AppData');
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await collectionRef.get().then((value) {
        print(value);
        return value;
      });

      // Get data from docs and convert map to List
      list = querySnapshot.docs
          .map((doc) => AppData.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) {
        return list;
        // notifyListeners();
      } else {
        AppData appData = AppData();
        appData.nombre_parrainage = 20;
        appData.adminSolde = 0.0;
        appData.soldeTotal = 0.0;
        createAppData(appData);

        return [];
      }
    } catch (e) {
      return [];
    }
//  notifyListeners();
  }

  Future<bool> updateAppData(AppData data, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('AppData')
          .doc(data.id)
          .update(data.toJson());

      return true;
    } catch (e) {
      print("erreur update  : ${e}");
      return false;
    }
  }

  deleteMatchFinished(String id) async {
    matchService.deleteById(id);
    notifyListeners();
  }

  Future<bool> makePayment() async {
    // Remplacez les valeurs suivantes par vos propres informations de compte Perfect Money
    String accountID = '4529863';
    String passPhrase = 'Cy1ACdOpNzC4qX38fFc5aqkku';
    String payerAccount = 'U29094329';
    String payeeAccount = 'U29094329';
    double amount = 1; // Montant à transférer
    String paymentID = '1223';

    String url =
        'https://perfectmoney.com/acct/confirm.asp?AccountID=$accountID&PassPhrase=$passPhrase&Payer_Account=$payerAccount&Payee_Account=$payeeAccount&Amount=$amount&PAY_IN=1&PAYMENT_ID=$paymentID';

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Analyser la réponse pour extraire les données nécessaires
        // Par exemple, vous pouvez utiliser un package HTML parser comme `html` pour extraire les champs de formulaire cachés si nécessaire
        print(response.body);
        return true;
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur : $e');
      return false;
    }
  }

  void main() {
    makePayment();
  }

  String oneSignalUrl = 'https://api.onesignal.com/notifications';
  String applogo =
      "https://firebasestorage.googleapis.com/v0/b/konami-bet.appspot.com/o/appmedias%2Flogokonami%20(2)%20(1).png?alt=media&token=eab2ad9d-35c2-42ea-ac6c-4f4142e8124f";
  String oneSignalAppId =
      'eeab82ff-8f16-445d-b907-75188cf4f56d'; // Replace with your app ID
  String oneSignalAuthorization =
      'YjEwNmY0MGQtODFhYi00ODBkLWIzZjgtZTVlYTFkMjQxZDA0'; // Replace with your authorization key

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  Future<bool> sendNotification(List<String> userIds, String message) async {
    print(
        'state current user data  ================================================');

    print(OneSignal.User.pushSubscription.id);

    final body = {
      'contents': {'en': message},
      'app_id': oneSignalAppId,

      "include_player_ids":
     // "include_subscription_ids":
          userIds, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

      // android_accent_color reprsent the color of the heading text in the notifiction
      "android_accent_color": "FF9976D2",

      "small_icon": applogo,

      "large_icon": applogo,

      "headings": {"en": "konami"},
      //"included_segments": ["Active Users", "Inactive Users"],
      "data": {"foo": "bar"},
      'name': 'konami',
      'custom_data': {'order_id': 123, 'Prix': '500 fcfa'},
    };

    final response = await http.post(
      Uri.parse(oneSignalUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Basic $oneSignalAuthorization",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully!');
      print('sending notification: ${response.body}');
      return true;
    } else {
      print('Error sending notification: ${response.statusCode}');
      print('Error sending notification: ${response.body}');
      return false;

    }
  }

  Future<UserNotif?> fetchUserNotif() async {
    const String baseUrl = 'https://api.onesignal.com/apps/';
    const String appId = 'eeab82ff-8f16-445d-b907-75188cf4f56d'; // Replace with your OneSignal app ID
    const String apiKey = 'YjEwNmY0MGQtODFhYi00ODBkLWIzZjgtZTVlYTFkMjQxZDA0'; // Replace with your OneSignal API key

    final String url = '$baseUrl$appId/users';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $apiKey', // Replace with appropriate authorization format
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers,
        body: jsonEncode({
          'subscriptions': [{'type': 'AndroidPush'}]
        }),

      );
      print('Error fetching user notification: ${response.statusCode}');
      print('user notif created: ${response.body}');
      if (response.statusCode == 200||response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        print('user notif created: ${response.body}');

        return UserNotif.fromJson(json);
      } else {
        print('Error fetching user notification: ${response.statusCode}');
        print('user notif created: ${response.body}');

        return null;
      }
    } catch (error) {
      print('Error fetching user notification: $error');
      return null;
    }
  }


}



class UserNotif {
  final String onesignalId;
  final List<Subscription> subscriptions;
 // final Map<String, String> properties;

  UserNotif({
    required this.onesignalId,
    required this.subscriptions,
   // required this.properties,
  });

  factory UserNotif.fromJson(Map<String, dynamic> json) {
    return UserNotif(
      onesignalId: json['identity']['onesignal_id'],
      subscriptions: (json['subscriptions'] as List)
          .map((subscription) => Subscription.fromJson(subscription))
          .toList(),
     // properties: json['properties']['tags']?.cast<String, String>() ?? {},
    );
  }
}

class Subscription {
  final String id;
  final String appId;
 // final String token;
  final String type;

  Subscription({
    required this.id,
    required this.appId,
    //required this.token,
    required this.type,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      appId: json['app_id'],
     // token: json['token'],
      type: json['type'],
    );
  }
}

