import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:konami_bet/services/database.dart';
import 'package:konami_bet/services/soccer_services.dart';
import 'package:shared_preferences/shared_preferences.dart';





class ServiceProvider extends ChangeNotifier {
late VerificationDuLancementService verificationDuLancementService = VerificationDuLancementService();
late MiseAJourMatchesService miseAJourMatchesService = MiseAJourMatchesService();
late MatchService matchService = MatchService();
late PariService pariService = PariService();
late Utilisateur loginUser=Utilisateur();
late Utilisateur userVerify =Utilisateur();
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
getLoginUser(){

  notifyListeners();
}
  creerPari(Pari pari){
  pariService.create(pari);
  notifyListeners();
  }
  
  createUser(String nom, pays,String code,BuildContext context) async {
 try{
   Utilisateur u= Utilisateur();
   u.phoneNumber=loginUser.phoneNumber;
   u.id_db=loginUser.id_db;
   u.nom=nom;
   u.codeSecurity=code;
   u.pays=pays;

   print("error1");
   await utilisateurService.create(u);
   print("error2");
   Navigator.pushNamed(context, 'phone');
 }catch(e){
   Fluttertoast.showToast(msg: 'erreur ${e.toString()}');
   print(e.toString());
 }

  notifyListeners();
  }
  getUserById(String id,BuildContext context) async {
  List<Utilisateur> listu=[];

  listu=await utilisateurService.getUserById(id);
  if(listu.isNotEmpty){
    this.loginUser=Utilisateur();
     this.loginUser=listu[0];
    print("user data providers");
    print("user data : ${this.loginUser.toJson()}");
    print( this.loginUser.id_db);

    Navigator.pushNamed(context, '/');
     // notifyListeners();
  }else{

    Navigator.pushNamed(context, 'phone');
  }
//  notifyListeners();
  }

   creatAllMatchByApi() async {
     String date = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
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

  updateNomberOfVerication(){

  notifyListeners();
  }
  deleteMatchFinished(String id)async{
   matchService.deleteById(id);
  notifyListeners();
  }
}