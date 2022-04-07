import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/delivery_item.dart';
import '../models/user_delivery.dart';

// [6]"Cloud Firestore | FlutterFire", Firebase.flutter.dev, 2022. [Online]. Available: https://firebase.flutter.dev/docs/firestore/usage/. [Accessed: 07- Apr- 2022]
class DeliveryDatabase{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference = _firestore.collection('DeliveryDetails');
  static final _collectionDeliveryReference = _firestore.collection('UserDeliveryDetails');
  User? user = FirebaseAuth.instance.currentUser;

  Future addData(String? senderName, String? senderEmail,  String? senderAddress, String? senderPhone, String? receiverName,  String? receiverAddress, String? receiverPhone, String date, String total) async {
    DateTime now = DateTime.now();
    final documentReference = _collectionReference.doc(now.toString());

    Map<String, dynamic> data = {
      'id': now.toString(),
      'senderId': user?.uid,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderAddress': senderAddress,
      'senderPhone': senderPhone,
      'receiverName': receiverName,
      'receiverAddress': receiverAddress,
      'receiverPhone': receiverPhone,
      'date': date,
      'total': total,
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
          if(doc["senderId"] == user?.uid){
            final flower = DeliveryItem(
              id: doc["id"],
              senderId: doc["senderId"],
              senderName: doc["senderName"],
              senderEmail: doc["senderEmail"],
              receiverName: doc["receiverName"],
              receiverPhone: doc["receiverPhone"],
              receiverAddress: doc["receiverAddress"],
              date: doc["date"],
              total: doc["total"],
            );
            itemList.add(flower);
          }
        });
      });
      return itemList;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future addDeliveryDetailsData(String? id, String? senderName, String? senderEmail, String? senderAddress, String? senderPhone) async {
    FirebaseFirestore.instance
        .collection('UserDeliveryDetails')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final documentReference = _collectionDeliveryReference.doc(id);

        Map<String, dynamic> data = {
          'senderId': user?.uid,
          'senderName': senderName,
          'senderEmail': senderEmail,
          'senderPhone': senderPhone,
          'senderAddress': senderAddress,
        };

        documentReference.update(data)
            .whenComplete(() => Fluttertoast.showToast(msg: 'Delivery details updated.'))
            .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
      }else{
        DateTime now = DateTime.now();
        final documentReference = _collectionDeliveryReference.doc(now.toString());

        Map<String, dynamic> data = {
          'id': now.toString(),
          'senderId': user?.uid,
          'senderName': senderName,
          'senderEmail': senderEmail,
          'senderPhone': senderPhone,
          'senderAddress': senderAddress,
        };

        documentReference.set(data)
            .whenComplete(() => Fluttertoast.showToast(msg: 'Success'))
            .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
      }
    });
  }

  getUserDeliveryDetails() async {
    UserDelivery? deliveryUser;

    await _collectionDeliveryReference.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc["senderId"] == user?.uid ){
          deliveryUser = UserDelivery(
              id: doc["id"],
              senderId: doc["senderId"],
              senderName:doc["senderName"],
              senderEmail:doc["senderEmail"],
              senderPhone:doc['senderPhone'],
              senderAddress:doc['senderAddress']);
        }
      });
    });
    return deliveryUser;

  }

  Future updateData(String id, String senderName, String receiverName,  String receiverAddress, String receiverPhone, String date) async {
    final documentReference = _collectionReference.doc(id);

    Map<String, dynamic> data = {
      'id': id,
      'senderName': senderName,
      'receiverName': receiverName,
      'receiverAddress': receiverAddress,
      'receiverPhone': receiverPhone,
      'date': date,
    };

    return await documentReference.update(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Delivery details updated.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future deleteDeliveryData({required String? id}) async {
    final documentReference = _collectionDeliveryReference.doc(id);

    return await documentReference.delete()
        .whenComplete(() => Fluttertoast.showToast(msg: 'Details Deleted.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future deleteData({required String id}) async {
    final documentReference = _collectionReference.doc(id);

    return await documentReference.delete()
        .whenComplete(() => Fluttertoast.showToast(msg: 'Order canceled.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }
}