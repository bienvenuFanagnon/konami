import 'package:flutter/material.dart';

import '../../profil/wallet/transactabBars/DepotPage.dart';
import 'contact_agent.dart';

class CheckPaymentPage extends StatelessWidget {


  void showMobileMoneyFeatureUnderDevelopmentModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fonctionnalité en cours de développement'),
        content: const Text(
          'La fonctionnalité de dépôt par mobile money est actuellement en cours de développement et sera disponible très bientôt. Nous vous remercions de votre patience.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue
              ),
              
              onPressed: () {
                // Handle manual payment button press
                print('Manual payment button pressed');
                 //Navigator.push(context, MaterialPageRoute(builder: (context) => DepotPage(),));
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ManualDepositPage(),));

              },
              child: Text('Paiement Manuel',style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
              ),
              onPressed: () {
                // Handle mobile money button press
                print('Mobile Money button pressed');
                showMobileMoneyFeatureUnderDevelopmentModal(context);

              },
              child: Text('Mobile Money',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
