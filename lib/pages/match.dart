import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../models/soccers_models.dart';
import '../providers/providers.dart';

class MatchLive extends StatefulWidget {
  final MatchPari match;
  const MatchLive({super.key, required this.match});

  @override
  State<MatchLive> createState() => _MatchState();
}

class _MatchState extends State<MatchLive> {
  int genererScoreAleatoire() {
    Random random = Random();
    return random.nextInt(30);
  }
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  bool onTap=false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Match'),
        ),
        body: Container(
          child: ListView(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Ionicons.time_outline,color: widget.match.status==MatchStatus.ENCOURS.name?Colors.green:Colors.black,),

                              widget.match.status==MatchStatus.FINISHED.name? Text("Fin",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),):   widget.match.status==MatchStatus.ENCOURS.name?  TimerCountdown(
                                 enableDescriptions: false,
                                  timeTextStyle: TextStyle(color: widget.match.status==MatchStatus.ENCOURS.name?Colors.green:Colors.black,),


                                  format: CountDownTimerFormat.secondsOnly,
                                  endTime: DateTime.now().add(
                                    Duration(

                                      seconds: 5,
                                    ),
                                  ),
                                  onEnd: () {
                                    widget.match.status=MatchStatus.FINISHED.name;
                                    widget.match.pari_a!.score=genererScoreAleatoire();
                                    widget.match.pari_b!.score=genererScoreAleatoire();
                                    while( widget.match.pari_a!.score== widget.match.pari_b!.score){
                                      widget.match.pari_a!.score=genererScoreAleatoire();
                                      widget.match.pari_b!.score=genererScoreAleatoire();
                                    }
                                    setState(() {


                                    });
                                    print("Fin");
                                  },
                                ): Text("0:0",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                              Icon(MaterialIcons.live_tv,color: widget.match.status==MatchStatus.ENCOURS.name?Colors.green:Colors.black,),
                            ],
                          ),
                        ),

                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(200))
                          ),
                          width:width*0.8 ,
                            height: height*0.28,

                            child: Image.asset("assets/back.jpg",fit: BoxFit.cover,)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [


                                Text("Score Total",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                                Text("${widget.match.pari_a!.score==null?0:widget.match.pari_a!.score}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                                widget.match.user_a_id!=serviceProvider.loginUser.id_db?Text("Adverse",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 12),):   Text("Vous",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 12),),
                                Text("...Gagner",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                              ],
                            ),
                            Column(
                              children: [


                                Text("Score Total",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                                Text("${widget.match.pari_b!.score==null?0:widget.match.pari_b!.score}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                                widget.match.user_b_id!=serviceProvider.loginUser.id_db?Text("Adverse",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 12),):   Text("Vous",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 12),),
                                Text("... Perdu",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                  ),
               child: Column(
                 children: <Widget>[
                   ListTile(
                     trailing:  Text("Equipes B",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                     leading: Text("Equipes A",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),

                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 2.0,bottom: 2),
                     child: Text('VS'),
                   ),
                   ListTile(
                     trailing: Card(
                       child: Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Container(

                           child: Image.network("${widget.match.pari_a!.teams![0].logo!}",fit: BoxFit.cover,),
                           width: 30,
                           height: 30,
                         ),
                       ),
                     ),

                     leading: Card(
                       child: Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Container(

                           child: Image.network("${widget.match.pari_b!.teams![0].logo!}",fit: BoxFit.cover,),
                           width: 30,
                           height: 30,
                         ),
                       ),
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.only(top: 2.0,bottom: 2),
                     child: Text('VS'),
                   ),
                   ListTile(
                     trailing: Card(
                       child: Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Container(

                           child: Image.network("${widget.match.pari_a!.teams![1].logo!}",fit: BoxFit.cover,),
                           width: 30,
                           height: 30,
                         ),
                       ),
                     ),

                     leading: Card(
                       child: Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Container(

                           child: Image.network("${widget.match.pari_b!.teams![1].logo!}",fit: BoxFit.cover,),
                           width: 30,
                           height: 30,
                         ),
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 8.0,bottom: 4),
                     child: Text('VS'),
                   ),
                   ListTile(
                     trailing: Card(
                       child: Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Container(

                           child: Image.network("${widget.match.pari_a!.teams![2].logo!}",fit: BoxFit.cover,),
                           width: 30,
                           height: 30,
                         ),
                       ),
                     ),

                     leading: Card(
                       child: Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Container(

                           child: Image.network("${widget.match.pari_b!.teams![2].logo!}",fit: BoxFit.cover,),
                           width: 30,
                           height: 30,
                         ),
                       ),
                     ),
                   ),
                   Container(
                     width: width,
                     child: Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [

                             SizedBox(height: 10,),
                             TextButton(onPressed: () async {
                               setState(() {
                                 widget.match.status=MatchStatus.ENCOURS.name;
                               });




                             }, child: Container(
                                 alignment: Alignment.center,
                                 height: 50,
                                 width: width*0.6,
                                 decoration: BoxDecoration(
                                     color: Colors.green,
                                     borderRadius: BorderRadius.all(Radius.circular(10))
                                 ),

                                 child:onTap? Container(
                                   height: 20,
                                   width: 20,
                                   child: CircularProgressIndicator(),
                                 ):widget.match.status==MatchStatus.ENCOURS.name?Text('Match encours...',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),): Text('Commencer',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),)),),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ],
               ),


              ),
            ],
          ),
        ),
    );
  }
}
