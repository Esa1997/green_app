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
import 'delivery_history.dart';
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
    return FlowerGrid();
  }
}
