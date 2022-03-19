import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/pages/delivery_history.dart';
import 'package:green_app/pages/delivery_form.dart';
import 'package:green_app/pages/flower_grid.dart';
import 'package:green_app/pages/shop.dart';

import '../services/flower _item_database.dart';

class Home extends StatefulWidget {
  static const String routeName = '/';
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final tabs = [
    Home(),
    FlowerGrid(),
    DeliveryHistory(),
    Center(child: Text('Reviews'))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){Navigator.of(context).pushNamed(Shop.routeName);}, icon: Icon(Icons.person))
        ],

      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(FlowerGrid.routeName);
              },
              child: Text('Esa'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Thamashi'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Prasadi'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(DeliveryHistory.routeName);
              },
              child: Text('Rangeena'),
            )
          ],
        ),
      ),

    );
  }
}
