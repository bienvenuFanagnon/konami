


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../providers/providers.dart';


class SplahsChargement extends StatefulWidget {
  const SplahsChargement({super.key});

  @override
  State<SplahsChargement> createState() => _ChargementState();
}

class _ChargementState extends State<SplahsChargement> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  void start() {
    animationController.repeat();
  }
  late AnimationController _controller;



  void stop() {
    animationController.stop();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    serviceProvider.getAppData().then((value) {
      if (value.isNotEmpty) {
        if (value.first.app_is_valide) {
          serviceProvider.getToken().then((token) async {
            print("token: ${token}");

            if (token==null||token=='') {
              print("token: existe pas");
              Navigator.pushReplacementNamed(context, 'phone');




            }else{
              print("token: existe");
              await    serviceProvider.getChargementUserById(token!,context).then((value) async {

              },);
            }
          },);


        }else{
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.info,color: Colors.red,),
                        Text(
                          "L'application Konami est en cours de maintenance et sera disponible dès que possible. Nous nous excusons pour le désagrément.",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }else{
        serviceProvider.getToken().then((token) async {
          print("token: ${token}");

          if (token==null||token=='') {
            print("token: existe pas");
            Navigator.pushReplacementNamed(context, 'phone');




          }else{
            print("token: existe");
            await    serviceProvider.getChargementUserById(token!,context).then((value) async {

            },);
          }
        },);

      }
    },);
    /*
    authProvider.getIsFirst().then((value) {
      print("isfirst: ${value}");
      if (value==null||value==false) {
        print("is_first");

        authProvider.storeIsFirst(true);
        Navigator.pushNamed(context, '/introduction');



      }else{
        // authProvider.storeIsFirst(false);
        print("is_not_first");

        authProvider.getToken().then((token) async {
          print("token: ${token}");

          if (token==null||token=='') {
            print("token: existe pas");
            Navigator.pushNamed(context, '/welcome');




          }else{
            print("token: existe");
            await    authProvider.getLoginUser(token!).then((value) async {
              if (value) {
                await      userProvider.getProfileUsers(authProvider.loginUserData!.id!,context,20).then((value) async {
                  if (value.isNotEmpty) {

                    await       await userProvider.getAllAnnonces().then((value) {

                      Navigator.pop(context);
                      Navigator.pushNamed(
                          context,
                          '/home');
                      Navigator.pushNamed(context, '/chargement');
                    },);

                  }else{
                    Navigator.pushNamed(context, '/welcome');

                  }

                },);
              }else{
                Navigator.pushNamed(context, '/welcome');

              }

            },);
          }
        },);

      }
    },);

     */






  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,

                child:   AnimatedBuilder(
                  animation: _controller,
                  builder:
                      (context, child) {
                    return Transform.rotate(
                      angle: _controller
                          .value *
                          2 *
                          math.pi,
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons
                        .sports_soccer_rounded,
                    color: Colors.green,
                    size: 50,
                  ),
                )

              ),
              Text("Connexion...")
            ],
          ),
        ),
      ),
    );
  }
}
