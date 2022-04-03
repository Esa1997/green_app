import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/feedback_item.dart';
import 'package:green_app/pages/edit_feedback.dart';

import 'package:provider/provider.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackItem feed;

  const FeedbackCard({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bool itemStatus = !Provider.of<CartProvider>(context).isItemAdded(flower);
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Expanded(
                    child: Image.network(
                      feed.url,
                      width: 250,
                      height: 250,
                      fit: BoxFit.fitHeight,)
                ),
                Text(
                  feed.name,
                  style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black, fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  feed.description,
                  style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black, fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  feed.rating.toString(),
                  style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black, fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5,),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditFeedbackItem(item: feed),
                                  )
                              );
                            },
                            icon: Icon(Icons.edit, color: Colors.teal,size: 30,)
                        ),

                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),



    );
  }
}
