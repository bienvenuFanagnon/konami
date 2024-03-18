import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:konami_bet/models/soccers_models.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';

class PariEnCours extends StatefulWidget {
  const PariEnCours({Key? key}) : super(key: key);

  @override
  State<PariEnCours> createState() => _PariEnCoursState();
}

class _PariEnCoursState extends State<PariEnCours> {
  late ServiceProvider serviceProvider =
      Provider.of<ServiceProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pari En Cours'),
        ),
        body: Container());
  }
}
