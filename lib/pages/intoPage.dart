import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin {


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

        body: Container(
          decoration: BoxDecoration(

            image: DecorationImage(
              image: AssetImage('assets/into-bg.jpeg'),
              fit: BoxFit.cover,

            ),

          ),
          child: new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: new Container(
              decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0,bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return RadialGradient(
                            center: Alignment.topLeft,
                            radius: 1.0,
                            colors: <Color>[Colors.indigo, Colors.green],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          'KONAMI',
                          style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.w900,),
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "infos");
                              // Votre action
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo.shade700,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: width*0.4,
                              height: 50,
                              child: Text('Comment ça marche?',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(height: 10,),


                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, "chargement");
                              // Votre action
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo.shade700,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: width*0.4,
                              height: 50,
                              child: Text('JOUER',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          TextButton(onPressed: () {
                            Navigator.pushNamed(context, "contact");

                          }, child: Text("Nous contacter",style: TextStyle(color: Colors.white60),))
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),

        )

    );
  }
}
