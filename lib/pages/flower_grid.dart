import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/components/flower_card.dart';
import 'package:green_app/models/flower_item.dart';
import 'package:green_app/pages/add_flower_item.dart';
import 'package:green_app/services/flower%20_item_database.dart';

class FlowerGrid extends StatefulWidget {
  static const String routeName= '/FlowerGrid';

  @override
  State<FlowerGrid> createState() => _FlowerGridState();
}

class _FlowerGridState extends State<FlowerGrid> {
  List<FlowerItem> itemList = [];
  List flowerItemList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    final database = FlowerItemDatabase();
    List<FlowerItem>? results = await database.readData();

    if(results == null){
      Fluttertoast.showToast(msg: 'Unable to retrieve data!');
    } else{
      setState(() {
        itemList = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Greenery Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return FlowerCard(flower: itemList.elementAt(index));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddItem.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
