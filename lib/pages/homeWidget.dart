import 'package:flutter/material.dart';

class HorizontalDropdownList extends StatefulWidget {
  final List<Widget> cardItems;

  HorizontalDropdownList({ required this.cardItems});

  @override
  _HorizontalDropdownListState createState() => _HorizontalDropdownListState();
}

class _HorizontalDropdownListState extends State<HorizontalDropdownList> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height*0.09,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: widget.cardItems,
          ),
        ),
      ],
    );
  }
}

