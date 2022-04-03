import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/components/flower_card.dart';
import 'package:green_app/models/flower_item.dart';
import 'package:green_app/pages/add_flower_item.dart';
import 'package:green_app/pages/shop.dart';
import 'package:green_app/pages/user_delivery_details.dart';
import 'package:green_app/services/flower%20_item_database.dart';

import 'delivery_form.dart';
import 'delivery_history.dart';
import 'edit_user.dart';

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

  //retrieve flower list from inventory(database)
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

  //build a flower grid dynamically using the flower list from inventory
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Greenery Shop'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Edit_user(),
                ));
          },
              icon: Icon(Icons.person, size: 30,)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return FlowerCard(flower: itemList.elementAt(index));
            }),
      ),
      floatingActionButton: SpeedDial( // floating menu button list
        animatedIcon: AnimatedIcons.menu_home,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add, color: Colors.teal,),
            onTap: () {
              Navigator.of(context).pushNamed(AddItem.routeName);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.shopping_cart, color: Colors.teal,),
            onTap: () {
              Navigator.of(context).pushNamed(Shop.routeName);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.history_outlined, color: Colors.teal,),
            onTap: () {
              //Navigator.of(context).pushNamed(DeliveryHistory.routeName);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.history, color: Colors.teal,),
            onTap: () {
              Navigator.of(context).pushNamed(DeliveryHistory.routeName);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.delivery_dining_sharp, color: Colors.teal,),
            onTap: () {
              Navigator.of(context).pushNamed(UserDeliveryDetails.routeName);
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
