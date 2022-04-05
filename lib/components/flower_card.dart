import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/flower_item.dart';
import 'package:green_app/pages/edit_flower_item.dart';
import 'package:green_app/pages/feedback_grid.dart';
import 'package:green_app/pages/shop.dart';
import 'package:green_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class FlowerCard extends StatelessWidget {
  final FlowerItem flower;
  User? user = FirebaseAuth.instance.currentUser;

  FlowerCard({Key? key, required this.flower}) : super(key: key);

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
                      flower.url,
                      width: 250,
                      height: 250,
                      fit: BoxFit.fitHeight,)
                ),
                Text(
                  flower.name,
                  style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black, fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  flower.price.toString(),
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600], fontWeight: FontWeight.bold
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              //check whether the user whose trying edit item is the one who added the item
                              if(user?.uid == flower.id){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditItem(item: flower),
                                    )
                                );
                              } else{
                                Fluttertoast.showToast(msg: "You Don't Have Permission to Edit this Item!");
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.teal,size: 30,)
                        ),
                        IconButton(
                            onPressed:(){
                              //add item to cart
                              Provider.of<CartProvider>(context,listen: false).addItem(flower);
                              Fluttertoast.showToast(msg: 'Item added to cart');
                              Navigator.of(context).pushNamed(Shop.routeName);

                            } ,

                            icon: Icon(Icons.add_shopping_cart, color: Colors.teal,size: 30,)
                        ),
                        IconButton(
                            onPressed: () {
                              //navigate to the selected flower items feedback list
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeedbackGrid(item_id: flower.id)
                                ),
                              );
                            },
                            icon: Icon(Icons.comment, color: Colors.teal,size: 30,)
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
