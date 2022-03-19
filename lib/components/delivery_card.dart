import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_app/pages/edit_delivery.dart';
import 'package:intl/intl.dart';
import 'package:green_app/models/delivery_item.dart';

class DeliveryCard extends StatefulWidget {
  final DeliveryItem delivery;

  const DeliveryCard({Key? key, required this.delivery}) : super(key: key);

  @override
  State<DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {

  Widget _getWidget(String date) {
    if(DateFormat('d-m-y').parse(date).isBefore(DateTime.now().add(const Duration(days: 1)))){
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
              onPressed: () {},
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
                Image.network(
                  widget.delivery.flowerUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.fitHeight),
                const SizedBox(width: 10),
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
