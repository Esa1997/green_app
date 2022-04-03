
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDatabase{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference = _firestore.collection('orders');


  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;


  Future addOrder(double total) async {
    DateTime now = new DateTime.now();
    final documentReference = _collectionReference.doc(now.toString());

    Map<String, dynamic> data = {
      'id': user?.uid,
      'total': total
    };

    documentReference.set(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Order Placed Successfully!!.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }
}