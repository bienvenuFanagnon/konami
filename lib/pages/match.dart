import 'package:flutter/material.dart';

import '../models/soccers_models.dart';

class MatchLive extends StatefulWidget {
  final MatchPari match;
  const MatchLive({super.key, required this.match});

  @override
  State<MatchLive> createState() => _MatchState();
}

class _MatchState extends State<MatchLive> {
  bool onTap=false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Matche'),
        ),
        body: Container(
          child: Column(
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

                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(200))
                          ),
                          width:width*0.8 ,
                            height: height*0.3,

                            child: Image.asset("assets/back.jpg",fit: BoxFit.cover,))
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                    ),
                 child: Column(
                   children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text('Equipes'),
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
                       padding: const EdgeInsets.only(top: 8.0,bottom: 4),
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
                                   ): Text('Commencer',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),)),),
                             ],
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),


                ),
              ),
            ],
          ),
        ),
    );
  }
}
