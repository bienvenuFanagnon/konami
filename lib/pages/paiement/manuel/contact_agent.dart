import 'package:flutter/material.dart';
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
  final List<Agent> agents = [
    Agent(name: 'Agent 1', imageUrl: 'https://picsum.photos/200'),
    Agent(name: 'Agent 2', imageUrl: 'https://picsum.photos/201'),
    Agent(name: 'Agent 3', imageUrl: 'https://picsum.photos/202'),
  ];

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
          Expanded(
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
                      // Handle contact agent action
                      print('Contacting agent ${agent.name}');
                      serviceProvider.getAppData().then((value) {
                        if (value.isNotEmpty) {
                          launchWhatsApp("${value.first.phoneConatct}");

                        }
                      },);


                    },
                    child: const Text('Contacter'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Agent {
  final String name;
  final String imageUrl;

  Agent({required this.name, required this.imageUrl});
}
