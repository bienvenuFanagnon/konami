import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import 'package:pulp_flash/pulp_flash.dart';
import '../../providers/providers.dart';
import '../providers/equipe_provider.dart';
import 'details/pari_details.dart';

class PariEnCours extends StatefulWidget {
  const PariEnCours({Key? key}) : super(key: key);

  @override
  State<PariEnCours> createState() => _PariEnCoursState();
}

class _PariEnCoursState extends State<PariEnCours> {
  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);
  String formatDateMatch = "dd MMM yyyy";
  bool onTap=false;
  String formaterDateMatch(DateTime date) {
    return DateFormat(formatDateMatch).format(date);
  }

  Widget item(Pari pari,double width,double height){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        borderOnForeground: true, // Cette ligne est facultative, elle indique si la bordure doit être dessinée devant ou derrière l'enfant de la carte
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: pari.status==PariStatus.DISPONIBLE.name?Colors.green: Colors.red, // Remplacez Colors.red par la couleur de votre choix
            width: 2.0, // Définissez l'épaisseur de la bordure selon vos besoins
          ),
          borderRadius: BorderRadius.circular(15.0), // Définissez le rayon de la bordure de la carte selon vos besoins
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.sports_soccer,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                 // SizedBox(width: width*0.3,),
                  Text("${formaterDateMatch(DateTime.fromMillisecondsSinceEpoch(pari.createdAt!))}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),



                  Icon(pari.status==PariStatus.DISPONIBLE.name?Icons.lock_open_outlined:Icons.lock,color:pari.status==PariStatus.DISPONIBLE.name?Colors.green: Colors.red,)

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for(Equipe eq in pari.teams!)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(

                            child: Image.network("${eq.logo!}",fit: BoxFit.cover,),
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setStateb) {
                        return    TextButton(onPressed:onTap?() {

                        } :() async {

                          setStateb(() {
                            onTap=true;

                          });
                          equipeProvider.getOnlyPari(pari.id!).then((value) async {
                            if (value.status==PariStatus.DISPONIBLE.name) {
                              print("disponible : ${value.status}");
                              value.status=PariStatus.ENCOURS.name;
                              await equipeProvider.updatePari(value, context);
                              setStateb(() {
                                onTap=false;

                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPari(pari: pari,),));

                            } else{

                              SnackBar snackBar = SnackBar(
                                content: Text('Un autre utilisateur est en train de miser là-dessus.',textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              print("non disponible : ${value.status}");
                               //  value.status=PariStatus.DISPONIBLE.name;
                           //    await equipeProvider.updatePari(value, context);
                              setStateb(() {
                                onTap=false;

                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPari(pari: pari,),));


                            }
                          },);





                        }, child:
                        Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                color: pari.status==PariStatus.DISPONIBLE.name?Colors.green: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: onTap? Container(
                              height: 20,
                                width: 20,

                                child: CircularProgressIndicator()):Text("Jouer",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 15),)));
                      }
                  ),


                ],
              ),
              SizedBox(width: width*0.3,),
              Card(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${pari.montant} Fcfa",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900,fontSize: 15),),
              )),
            ],
          ),
        ),
      ),
    );
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Pari En Cours'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Les paries en cours'),
                      /*
                      GestureDetector(
                        onTap: () {

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeamSelectedPage(),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: badges.Badge(
                            badgeContent: Text(
                              '${equipeProvider.teams_selected.length}',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(Icons.shopping_cart),
                          ),
                        ),
                      ),

                       */
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  StreamBuilder<List<Pari>>(
                      stream: equipeProvider.getListPari(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {

                        if (snapshot.hasData) {
                          List<Pari> paries =snapshot.data;
                          return SizedBox(
                            height: height*0.76,
                            width: width,                                    //    height: height*0.5,
                            //   width: width,
                            child: ListView.builder(

                              itemCount: paries.length,
                              itemBuilder: (BuildContext context,
                                  int index) {
                                Pari pari = snapshot.data[index];
                                return item(pari, width, height);
                              },),
                          );
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error_outline);
                        } else {
                          return Container( height: 50,width: 50,  child: CircularProgressIndicator());
                        }
                      }),
                  SizedBox(
                    height: 300,
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
