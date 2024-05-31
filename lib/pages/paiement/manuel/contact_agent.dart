import 'package:flutter/material.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../../providers/equipe_provider.dart';
import '../../../providers/providers.dart';

class ManualDepositPage extends StatefulWidget {
  const ManualDepositPage({Key? key}) : super(key: key);

  @override
  State<ManualDepositPage> createState() => _ManualDepositPageState();
}

class _ManualDepositPageState extends State<ManualDepositPage> {

  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);
  late EquipeProvider equipeProvider =
  Provider.of<EquipeProvider>(context, listen: false);

  Future<void> launchWhatsApp(String phone,) async {
    //  var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
    // String url = "https://wa.me/?tel:+228$phone&&text=YourTextHere";
    String url = "whatsapp://send?phone="+phone+"&text=Salut ,\n*Pseudo du compte*: *@${serviceProvider.loginUser.pseudo!.toUpperCase()}*,\n\n je vous contacte via *${"Konami".toUpperCase()}* pour un dépôt\n";
    if (!await launchUrl(Uri.parse(url))) {
      final snackBar = SnackBar(duration: Duration(seconds: 2),content: Text("Impossible d\'ouvrir WhatsApp",textAlign: TextAlign.center, style: TextStyle(color: Colors.red),));

      // Afficher le SnackBar en bas de la page
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception('Impossible d\'ouvrir WhatsApp');
    }
  }
  late List<Agent> agents = [
 ];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dépôts ou Retrait Manuels'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pour les dépôts manuels veuillez contacter nos agents en ligne',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          FutureBuilder(
              future: serviceProvider.getAppData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<AppData> appdatas=snapshot.data;
                  agents = [
                  ];
                  if(appdatas.isNotEmpty){
                    for(int i=0;i<appdatas.first.phonesConatct.length;i++){
                      Agent ag=  Agent(phone: '${appdatas.first.phonesConatct[i]}',name: 'Agent ${i+1}', imageUrl: 'https://picsum.photos/200');
                      agents.add(ag);

                    }
                  }


                  return           Expanded(
                    child: ListView.builder(
                      itemCount: agents.length,
                      itemBuilder: (context, index) {
                        final agent = agents[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/logoIcon.png"),
                          ),
                          title: Text(agent.name),
                          trailing: ElevatedButton(
                            onPressed: () {

                              launchWhatsApp("${agent.phone}");



                            },
                            child: const Text('Contacter'),
                          ),
                        );
                      },
                    ),
                  )
                ;
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}

class Agent {
  final String name;
  final String phone;
  final String imageUrl;

  Agent({required this.name, required this.imageUrl, required this.phone});
}
