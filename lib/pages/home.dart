import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/pages/add_feedback.dart';
import 'package:green_app/pages/edit_user.dart';
import 'package:green_app/pages/feedback_grid.dart';
import 'package:green_app/pages/flower_grid.dart';
import 'package:green_app/pages/shop.dart';

import '../models/user_model.dart';
import '../services/flower _item_database.dart';
import 'edit_feedback.dart';

class Home extends StatefulWidget {

  static const String routeName = '/Home';
  Home({Key? key,}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


  
  int _currentIndex = 0;
  final tabs = [
    Home(),
    FlowerGrid(),
    Center(child: Text('Delivery')),
    Center(child: Text('Reviews'))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Edit_user(),
                )
            );
            }, 
              icon: Icon(Icons.person)
          )
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackGrid(),
                    )
                );
              },
              child: Text('Thamashi'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFeedback(),
                    )
                );
              },
              child: Text('Prasadi'),
            ),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Rangeena'),
            )
          ],
        ),
      ),

    );
  }
}
