import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/flower_item.dart';

class FlowerItemDatabase{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference = _firestore.collection('FlowerDetails');

  Future addData(String name, double price, String description, String url) async {
    DateTime now = new DateTime.now();
    final documentReference = _collectionReference.doc(now.toString());

    Map<String, dynamic> data = {
      'id': now.toString(),
      'name': name,
      'description': description,
      'url': url,
      'price': price
    };

    documentReference.set(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Item Added.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future readData() async {
    List<FlowerItem> itemList = [];
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

    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'price': price
    };

    return await documentReference.update(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Item Updated.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future deleteData({required String id}) async {
    final documentReference = _collectionReference.doc(id);

    return await documentReference.delete()
        .whenComplete(() => Fluttertoast.showToast(msg: 'Item Deleted.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }
}