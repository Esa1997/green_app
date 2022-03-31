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

  Widget _getWidget(String date) {
    if(DateFormat('d-m-y').parse(date).isBefore(DateTime.now().add(const Duration(days: 2)))){
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
    }else{
      return Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Image.network(
                //   widget.delivery.flowerUrl,
                //   width: 70,
                //   height: 70,
                //   fit: BoxFit.fitHeight),
                // const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.delivery.receiverName,
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black, fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.delivery.receiverAddress,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600], fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.delivery.date,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600], fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.delivery.total,
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
