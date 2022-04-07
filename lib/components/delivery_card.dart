import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_app/pages/edit_delivery.dart';
import 'package:intl/intl.dart';
import 'package:green_app/models/delivery_item.dart';
import '../pages/delivery_history.dart';
import '../services/delivery_database.dart';

class DeliveryCard extends StatefulWidget {
  final DeliveryItem delivery;

  const DeliveryCard({Key? key, required this.delivery}) : super(key: key);

  @override
  State<DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {

  final database = DeliveryDatabase();

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed:  () {
        onDelete();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Are you sure you want to cancel this order?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  onDelete() async {
    try{
      await database.deleteData(id: widget.delivery.id);
    } on Exception catch (error){
      print('Exception: $error');
    } finally {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryHistory(),
          )
      );
    }
  }

  //compare date and display icons accordingly
  // [7]"DateTime class - dart:core library - Dart API", Api.flutter.dev, 2022. [Online]. Available: https://api.flutter.dev/flutter/dart-core/DateTime-class.html. [Accessed: 07- Apr- 2022]
  Widget _getWidget(String date) {
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(date);
    if(tempDate.isAfter(DateTime.now().add(const Duration(days: 2)))){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDelivery(item: widget.delivery),
                    )
                );
              },
              icon: Icon(Icons.edit, color: Colors.teal)
          ),
          IconButton(
              onPressed: () {
                showAlertDialog(context);
              },
              icon: Icon(Icons.delete, color: Colors.red)
          )
        ],
      );
    }else {
      return Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      color: (DateFormat("dd-MM-yyyy").parse(widget.delivery.date).isBefore(DateTime.now()))?
      const Color(0xffd6d6d9): Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( "Receiver Name: ${widget.delivery.receiverName}",
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black, fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text( "Receiver Address: ${widget.delivery.receiverAddress}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600], fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Date: ${widget.delivery.date}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600], fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Total: ${widget.delivery.total}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600], fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
                _getWidget(widget.delivery.date)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
