import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/flower_item.dart';

class FlowerItemDatabase{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference = _firestore.collection('FlowerDetails');
  static final User? user = FirebaseAuth.instance.currentUser;

  Future addData(String name, double price, String description, String url) async {
    String? user_id = user?.uid.toString();
    final documentReference = _collectionReference.doc(user_id);

    //map flower details into a Map
    Map<String, dynamic> data = {
      'id': user_id,
      'name': name,
      'description': description,
      'url': url,
      'price': price
    };

    //add flower item to inventory()database
    documentReference.set(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Item Added.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future readData() async {
    List<FlowerItem> itemList = [];
    //retrieve flower items from inventory (database)
    try {
      await _collectionReference.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final flower = FlowerItem(
              id: doc["id"],
              name: doc["name"],
              description: doc["description"],
              price: doc["price"],
              url: doc["url"]
          );
          itemList.add(flower);
        });
      });
      print(itemList);
      return itemList;
    } on Exception catch (e) {
      // TODO
      print(e.toString());
      return null;
    }
  }

  Future updateData(String id, String name, double price, String description, String url) async {
    final documentReference = _collectionReference.doc(id);

    //map flower details into a Map
    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'price': price
    };

    //update selected flower item in inventory(database)
    return await documentReference.update(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Item Updated.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future deleteData({required String id}) async {
    final documentReference = _collectionReference.doc(id);

    //delete selected flower item from inventory(database)
    return await documentReference.delete()
        .whenComplete(() => Fluttertoast.showToast(msg: 'Item Deleted.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }
}