import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/feedback_item.dart';


class FeedbackDatabase{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference = _firestore.collection('Feedback');

  Future addData(String item_id, String name, String description, String url, double rating) async {
    DateTime now = new DateTime.now();
    final documentReference = _firestore.collection(item_id).doc(now.toString());

    Map<String, dynamic> data = {
      'id': now.toString(),
      'name': name,
      'description': description,
      'url': url,
      'rating':rating,

    };

    documentReference.set(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Feedback Submitted Successfully.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future readData(String item_id) async {
    List<FeedbackItem> itemList = [];
    try {
      await _firestore.collection(item_id).get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final feedback = FeedbackItem(
              id: doc["id"],
              name: doc["name"],
              description: doc["description"],
              url: doc["url"],
              rating:doc["rating"]
          );
          itemList.add(feedback);
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





  Future updateData(String item_id, String id, String name, String description, String url, double rating) async {
    final documentReference = _firestore.collection(item_id).doc(id);

    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'rating':rating,
    };

    return await documentReference.update(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Feedback Updated.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future deleteData({required String item_id, required String id}) async {
    final documentReference = _firestore.collection(item_id).doc(id);

    return await documentReference.delete()
        .whenComplete(() => Fluttertoast.showToast(msg: 'Feedback Deleted.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }
}