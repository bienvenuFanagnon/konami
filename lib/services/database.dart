
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:konami_bet/models/soccers_models.dart';


class MatchService {

  MatchService();


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
// fonctions creer, recuperer, effacer et mise a jurs des donnees firebase


  test(){
    // Créez une référence de document
    final DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('test')
        .doc('monDocument');

// Créez une carte imbriquée de données JSON
    final Map<String, dynamic> data = {
      'nom': 'Jean',
      'age': 30,
      'adresse': {
        'rue': '123, rue Principale',
        'ville': 'Montréal',
        'pays': 'Canada'
      }
    };

// Enregistrez la carte de données JSON imbriquée dans Firestore
    docRef.set(data);
  }

  void deleteAllData(){
    try {
      FirebaseFirestore.instance
          .collection('Matches')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      print("suppression*********");
    } catch (e) {
      print(e);
    }


  }
  // Supprime un document dans une collection Firebase par ID
  Future<void> deleteById(String documentId) async {
    await FirebaseFirestore.instance
        .collection("Matches")
        .doc(documentId)
        .delete();
    print('Document supprimé avec succès');
  }

  void update(String dataId, Map<String, dynamic> dataMap) async {
    try {
      firestore.collection('Matches').doc(dataId).update(dataMap);
      print("mise a jour .......");

    } catch (e) {
      print(e);
    }
  }



  void delete() async {
    try {
      firestore.collection('Matches').doc('testUser').delete();
    } catch (e) {
      print(e);
    }
  }



  void fromJson(Object? data) {}

}

class VerificationDuLancementService {

  VerificationDuLancementService();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
// fonctions creer, recuperer, effacer et mise a jurs des donnees firebase

  void update(String dataId, Map<String, dynamic> dataMap) async {
    try {
      firestore.collection('VerificationDuLancement').doc(dataId).update(dataMap);
    } catch (e) {
      print(e);
    }
  }



  void delete() async {
    try {
      FirebaseFirestore.instance
          .collection('VerificationDuLancement')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print(e);
    }
  }





}

class MiseAJourMatchesService {

  MiseAJourMatchesService();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
// fonctions creer, recuperer, effacer et mise a jurs des donnees firebase


  void update(String dataId, Map<String, dynamic> dataMap) async {
    try {
      firestore.collection('MiseAJourMatches').doc(dataId).update(dataMap);
    } catch (e) {
      print(e);
    }
  }



  void delete() async {
    try {
      firestore.collection('MiseAJourMatches').doc('testUser').delete();
    } catch (e) {
      print(e);
    }
  }


  Future<List<MiseAJourMatches>> getAllMatches() async {
    late List<MiseAJourMatches> list= [];


    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('MiseAJourMatches');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get()
        .then((value){

      return value;
    }).catchError((onError){

    });

    // Get data from docs and convert map to List
    list = querySnapshot.docs.map((doc) =>
        MiseAJourMatches.fromJson(doc.data() as Map<String, dynamic>)).toList();

    return list;

  }


}
class PariService {

  PariService();


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
// fonctions creer, recuperer, effacer et mise a jurs des donnees firebase
  Future<String> create(Pari data) async {
    String id = firestore
        .collection('PariEnCours')
        .doc()
        .id;
    data.id = id;
    try{
      final DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('PariEnCours').doc(id);
      docRef.set(data.toJson());


      //  await firestore.collection('Matches').doc(id).set(data.toJson());
      print("save pari");
    } on FirebaseException catch(error){

    }
    return id;
  }



  void deleteAllData(){
    try {
      FirebaseFirestore.instance
          .collection('PariEnCours')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      print("suppression*********");
    } catch (e) {
      print(e);
    }


  }
  // Supprime un document dans une collection Firebase par ID
  Future<void> deleteById(String documentId) async {
    await FirebaseFirestore.instance
        .collection("PariEnCours")
        .doc(documentId)
        .delete();
    print('Document supprimé avec succès');
  }

  void update(String dataId, Map<String, dynamic> dataMap) async {
    try {
      firestore.collection('PariEnCours').doc(dataId).update(dataMap);
      print("mise a jour .......");

    } catch (e) {
      print(e);
    }
  }



  void delete() async {
    try {
      firestore.collection('Matches').doc('testUser').delete();
    } catch (e) {
      print(e);
    }
  }


  Future<List<Pari>> getAllPari() async {
    late List<Pari> list= [];


    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('PariEnCours');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get()
        .then((value){

      return value;
    }).catchError((onError){

    });

    // Get data from docs and convert map to List
    list = querySnapshot.docs.map((doc) =>
        Pari.fromJson(doc.data() as Map<String, dynamic>)).toList();

    return list;

  }


}

class UtilisateurService {

  UtilisateurService();


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
// fonctions creer, recuperer, effacer et mise a jurs des donnees firebase
  Future<String> create(Utilisateur data,String userid) async {
    String id = firestore
        .collection('Utilisateur')
        .doc()
        .id;
    data.id_db=userid;

    try{
      final DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('Utilisateur').doc(userid);
      docRef.set(data.toJson());


      //  await firestore.collection('Matches').doc(id).set(data.toJson());
      print("///////////-- SAVE soccer data  --///////////////");
    } on FirebaseException catch(error){

    }
    return id;
  }

  test(){
    // Créez une référence de document
    final DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('test')
        .doc('monDocument');

// Créez une carte imbriquée de données JSON
    final Map<String, dynamic> data = {
      'nom': 'Jean',
      'age': 30,
      'adresse': {
        'rue': '123, rue Principale',
        'ville': 'Montréal',
        'pays': 'Canada'
      }
    };

// Enregistrez la carte de données JSON imbriquée dans Firestore
    docRef.set(data);
  }

  void deleteAllData(){
    try {
      FirebaseFirestore.instance
          .collection('Utilisateur')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      print("suppression*********");
    } catch (e) {
      print(e);
    }


  }
  // Supprime un document dans une collection Firebase par ID
  Future<void> deleteById(String documentId) async {
    await FirebaseFirestore.instance
        .collection("Utilisateur")
        .doc(documentId)
        .delete();
    print('Document supprimé avec succès');
  }

  void update(String dataId, Map<String, dynamic> dataMap) async {
    try {
      firestore.collection('Utilisateur').doc(dataId).update(dataMap);
      print("mise a jour .......");

    } catch (e) {
      print(e);
    }
  }



  void delete() async {
    try {
      firestore.collection('Utilisateur').doc('testUser').delete();
    } catch (e) {
      print(e);
    }
  }


  Future<List<Utilisateur>> getAllUser() async {
    late List<Utilisateur> list= [];


    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('Utilisateur');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get()
        .then((value){

      return value;
    }).catchError((onError){

    });

    // Get data from docs and convert map to List
    list = querySnapshot.docs.map((doc) =>
        Utilisateur.fromJson(doc.data() as Map<String, dynamic>)).toList();

    return list;

  }
  Future<List<Utilisateur>> getUserById(String id) async {
    late List<Utilisateur> list= [];


    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('Utilisateur');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.where("id_db",isEqualTo: id!).get()
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

  void fromJson(Object? data) {}

}