import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constant/constColors.dart';
import '../../../constant/logo.dart';
import '../../../constant/sizeText.dart';
import '../../../constant/textCustom.dart';

import '../providers/equipe_provider.dart';
import '../providers/providers.dart';
import 'admin/addAppInfo.dart';
import 'admin/addAppInfo.dart';



class AppInfos extends StatefulWidget {
  const AppInfos({super.key});

  @override
  State<AppInfos> createState() => _AppInfosState();
}

class _AppInfosState extends State<AppInfos> {


  final List<String> noms = ['Alice', 'Bob', 'Charlie'];
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);

  Random random = Random();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: TextCustomerPageTitle(
          titre: "konami infos Comment ça marche?",
          fontSize: 15,
          couleur: ConstColors.textColors,
          fontWeight: FontWeight.normal,
        ),


        //title: Text(widget.title),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: ()async {
          setState(() {

          });

        },
        child: SingleChildScrollView(

          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                serviceProvider.loginUser.role==RoleUser.ADMIN.name?Container(
                  alignment:Alignment.center ,
                  width: 150,
                  child: ElevatedButton(onPressed: () {
                    Navigator.push(context,  MaterialPageRoute(builder: (context) => NewAppInfo(),));
                  }, child: Row(
                    children: [
                      Icon(Icons.add),
                      Text("Nouvelle"),
                    ],
                  )),
                ):serviceProvider.loginUser.role==RoleUser.SUPERADMIN.name?Container(
                  alignment:Alignment.center ,
                  width: 150,
                  child: ElevatedButton(onPressed: () {
                    Navigator.push(context,  MaterialPageRoute(builder: (context) => NewAppInfo(),));
                  }, child: Row(
                    children: [
                      Icon(Icons.add),
                      Text("Nouvelle"),
                    ],
                  )),
                ): Container(

                ),
                FutureBuilder<List<Information>>(
                    future: equipeProvider.getListInfo(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<Information> list=snapshot.data;
                        return ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Random random = Random();
                            print("info ${list[index].toJson()}");

                            // Générer un nombre aléatoire entre 0 et 10000

                            return GestureDetector(
                              onTap: () {
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: TextCustomerMenu(

                                        titre: "${list[index].titre}".toUpperCase(),
                                        fontSize: 15,
                                        couleur: Colors.blue,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: TextCustomerMenu(

                                      titre: "${list[index].description}",
                                      fontSize: SizeText.homeProfileTextSize,
                                      couleur: ConstColors.textColors,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                 list[index].media_url!.isEmpty?Container(): Container(
                                    width: width,
                                   // height: height*0.4,

                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      child: Container(

                                        child: Image.network('${list[index].media_url}',  fit: BoxFit.fill,),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  SizedBox(height: 30,)
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error_outline);
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          height: 30,
                            width: 30,

                            child: CircularProgressIndicator());
                      }
                    })


              ],
            ),
          ),
        ),
      ),

    );
  }
}

class ConversationList extends StatefulWidget {
  int classe;
  String name;
  String messageText;
  String imageUrl;
  int points;
  double avatarSize;
  bool isMessageRead;
  ConversationList(
      {required this.classe,
        required this.name,
        required this.avatarSize,
        required this.messageText,
        required this.imageUrl,
        required this.points,
        required this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.classe}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.classe>10?Colors.red:Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.classe ==1?Image.asset(
                    'assets/images/trophee.png',
                    height: 20,
                    width: 20,
                  ):widget.classe ==2?Image.asset(
                    'assets/images/trophee2.png',
                    height: 20,
                    width: 20,
                  ):widget.classe ==3?Image.asset(
                    'assets/images/trophee3.png',
                    height: 20,
                    width: 20,
                  ):Container(
                    height: 20,
                    width: 20,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  maxRadius: widget.avatarSize,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.messageText,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: widget.isMessageRead
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${widget.points} Points',
            style: TextStyle(
                fontSize: 12,
                fontWeight:
                widget.isMessageRead ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
