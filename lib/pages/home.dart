import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatelessWidget {
  static String routeName = '/';

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){},
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
              onPressed: () {},
              child: Text('Rangeena'),
            )
          ],
        ),
      ),
    );
  }

}
