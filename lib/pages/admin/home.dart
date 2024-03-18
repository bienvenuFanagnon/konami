import 'package:flutter/material.dart';
import 'package:konami_bet/providers/providers.dart';
import 'package:konami_bet/services/soccer_services.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);


  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late ServiceProvider serviceProvider =
  Provider.of<ServiceProvider>(context, listen: false);


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
    return  Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      body: Container(),
    );
  }
}
