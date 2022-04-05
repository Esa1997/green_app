import 'package:flutter/material.dart';
import 'package:green_app/pages/flower_grid.dart';


class Home extends StatefulWidget {
  static const String routeName = '/Home';
  const Home({Key? key,}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return FlowerGrid();
  }
}
