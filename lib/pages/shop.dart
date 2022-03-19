import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/flower_item.dart';
import 'package:green_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class Shop extends StatelessWidget {
  static const String routeName= '/shop';
  const Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FlowerItem> items = Provider.of<CartProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 7,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context,index){
                  FlowerItem item = items.elementAt(index);
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.price.toString()),
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red,),
                        onPressed: (){
                          Provider.of<CartProvider>(context, listen: false).removeItem(item);
                          Fluttertoast.showToast(msg: 'Item removed from the cart');
                        },
                      ),
                      leading: Image.network(item.url),
                    ),
                  );
                }),
          ),
          Flexible(
            flex: 3,
              child: Column(
                children: [
                  Text('TOTAL',
                    style: TextStyle(
                      fontSize: 30.0,fontWeight: FontWeight.bold
                    ),),

                  Text(Provider.of<CartProvider>(context).total.toString(),
                    style: Theme.of(context).textTheme.headline5,),
                  SizedBox(height: 15,),
                  ElevatedButton.icon(
                    onPressed: (){},
                    icon: Icon(Icons.shop, size: 20,),
                    label: Text(
                      'CHECKOUT',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
