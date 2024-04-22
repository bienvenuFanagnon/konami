import 'dart:async';
import 'dart:math';

import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class CinetPay extends StatefulWidget {
  const CinetPay({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CinetPay> {
  TextEditingController amountController = TextEditingController();
  Map<String, dynamic>? response;
  Color? color;
  IconData? icon;
  String? message;
  bool show = false;
  late String site_id="5870078";
  late String api_key="102325650865f879a7b10492.83921456";
  late String api_key2="44230249865fce27e6c61c3.62649311";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String title = 'CinetPay Demo';
    return  Scaffold(
          appBar: AppBar(
            title: const Text(title),
            centerTitle: true,
          ),
          body: SafeArea(
              child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          show ? Icon(icon, color: color, size: 150) : Container(),
                          show ? Text(message!) : Container(),
                          show ? const SizedBox(height: 50.0) : Container(),
                          const Text(
                            "Example integration Package for Flutter",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 50.0),
                          Text(
                            "Cart informations.",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          const SizedBox(height: 50.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: const EdgeInsets.symmetric(horizontal: 50.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: Colors.green),
                            ),
                            child: TextField(
                              controller: amountController,
                              decoration: const InputDecoration(
                                hintText: "Amount",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          ElevatedButton(
                            child: const Text("Pay with CinetPay"),
                            onPressed: () async {
                              String amount = amountController.text;
                              if (amount.isEmpty) {
                                // Mettre une alerte
                                return;
                              }
                              double _amount;
                              try {
                                _amount = double.parse(amount);

                                if (_amount < 100) {
                                  // Mettre une alerte
                                  return;
                                }

                                if (_amount > 1500000) {
                                  // Mettre une alerte
                                  return;
                                }
                              } catch (exception) {
                                return;
                              }

                              amountController.clear();

                              final String transactionId = Random()
                                  .nextInt(100000000)
                                  .toString(); // Mettre en place un endpoint à contacter côté serveur pour générer des ID unique dans votre BD

                              await Get.to(CinetPayCheckout(
                                title: 'Payment Checkout',
                                titleStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                titleBackgroundColor: Colors.green,
                                configData: <String, dynamic>{
                                  'apikey': '${api_key}',
                                  'site_id': int.parse("${site_id}"),
                                  'notify_url': 'https://app-new.cinetpay.com/'
                                },
                                paymentData: <String, dynamic>{
                                  'transaction_id': transactionId,
                                  'amount': _amount,
                                  'currency': 'XOF',
                                  'channels': 'ALL',
                                  'description': 'Payment test',
                                },
                                waitResponse: (data) {
                                  if (mounted) {
                                    setState(() {
                                      response = data;
                                      print(response);
                                      icon = data['status'] == 'ACCEPTED'
                                          ? Icons.check_circle
                                          : Icons.mood_bad_rounded;
                                      color = data['status'] == 'ACCEPTED'
                                          ? Colors.green
                                          : Colors.redAccent;
                                      show = true;
                                      Get.back();
                                    });
                                  }
                                },
                                onError: (data) {
                                  if (mounted) {
                                    setState(() {
                                      response = data;
                                      message = response!['description'];
                                      print("cinepay erreur");

                                      print(response);
                                      icon = Icons.warning_rounded;
                                      color = Colors.yellowAccent;
                                      show = true;
                                      Get.back();
                                    });
                                  }
                                },
                              ));
                            },
                          )
                        ],
                      ),
                    ],
                  ))));
  }
}