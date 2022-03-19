import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/flower_item.dart';

import '../models/delivery_item.dart';

class DeliveryDatabase{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference = _firestore.collection('DeliveryDetails');

  Future addData(String senderName, String senderEmail, String receiverName,  String receiverAddress, String receiverPhone, String date, FlowerItem flower) async {
    DateTime now = DateTime.now();
    final documentReference = _collectionReference.doc(now.toString());

    Map<String, dynamic> data = {
      'id': now.toString(),
      'senderName': senderName,
      'senderEmail': senderEmail,
      'receiverName': receiverName,
      'receiverAddress': receiverAddress,
      'receiverPhone': receiverPhone,
      'date': date,
      'flower_url': flower.url,
      'flower_name': flower.name,
      'flower_price': flower.price
    };

    documentReference.set(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Success'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future readData() async {
    List<DeliveryItem> itemList = [];
    try {
      await _collectionReference.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final flower = DeliveryItem(
              id: doc["id"],
              senderName: doc["senderName"],
              senderEmail: doc["senderEmail"],
              receiverName: doc["receiverName"],
              receiverPhone: doc["receiverPhone"],
              receiverAddress: doc["receiverAddress"],
              date: doc["date"],
              flowerUrl: doc["flower_url"],
              flowerName: doc["flower_name"],
              flowerPrice: doc["flower_price"],
          );
          itemList.add(flower);
        });
      });
      return itemList;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateData(String id, String senderName, String senderEmail, String receiverName,  String receiverAddress, String receiverPhone, String date) async {
    final documentReference = _collectionReference.doc(id);

    Map<String, dynamic> data = {
      'id': id,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'receiverName': receiverName,
      'receiverAddress': receiverAddress,
      'receiverPhone': receiverPhone,
      'date': date,
    };

    return await documentReference.update(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Item Updated.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  // Future deleteData({required String id}) async {
  //   final documentReference = _collectionReference.doc(id);
  //
  //   return await documentReference.delete()
  //       .whenComplete(() => Fluttertoast.showToast(msg: 'Item Deleted.'))
  //       .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  // }
}