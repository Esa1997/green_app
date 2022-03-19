import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_app/models/delivery_item.dart';

class DeliveryCard extends StatelessWidget {
  final DeliveryItem delivery;

  const DeliveryCard({Key? key, required this.delivery}) : super(key: key);

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
                  delivery.flowerUrl,
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
                        delivery.receiverName,
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black, fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        delivery.receiverAddress,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600], fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        delivery.date,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600], fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: Colors.teal)
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete, color: Colors.red)
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
