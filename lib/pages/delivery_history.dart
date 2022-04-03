import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/components/delivery_card.dart';
import 'package:green_app/models/delivery_item.dart';
import 'package:green_app/services/delivery_database.dart';

class DeliveryHistory extends StatefulWidget {
  static const String routeName= '/deliveryHistory';
  const DeliveryHistory({Key? key}) : super(key: key);

  @override
  _DeliveryHistoryState createState() => _DeliveryHistoryState();
}

class _DeliveryHistoryState extends State<DeliveryHistory> {

  List<DeliveryItem> itemList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final database = DeliveryDatabase();
    List<DeliveryItem>? results = await database.readData();

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
        title: Text('Delivery History'),
        actions: [
          IconButton(
              onPressed: (){
                //Navigator.of(context).pushNamed();
                },
              icon: Icon(Icons.add_circle, size: 27,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: itemList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return DeliveryCard(delivery: itemList.elementAt(index));
            }),
      )
    );
  }
}
