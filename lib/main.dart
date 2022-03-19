import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_app/pages/add_flower_item.dart';
import 'package:green_app/pages/delivery_history.dart';
import 'package:green_app/pages/edit_flower_item.dart';
import 'package:green_app/pages/flower_grid.dart';
import 'package:green_app/pages/home.dart';
import 'package:green_app/pages/shop.dart';
import 'package:green_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: Home.routeName,
        routes: {
          Home.routeName: (context) => Home(),
          FlowerGrid.routeName: (context) => FlowerGrid(),
          AddItem.routeName: (context) => AddItem(),
          Shop.routeName: (context) => Shop(),
          DeliveryHistory.routeName: (context) => DeliveryHistory(),
        },
      ),
    );
  }
}