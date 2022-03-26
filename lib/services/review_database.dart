import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/feedback_item.dart';


class FeedbackDatabase{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference = _firestore.collection('Feedback');

  Future addData(String name, String description, String url) async {
    DateTime now = new DateTime.now();
    final documentReference = _collectionReference.doc(now.toString());

    Map<String, dynamic> data = {
      'id': now.toString(),
      'name': name,
      'description': description,
      'url': url,

    };

    documentReference.set(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Feedback Added.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future readData() async {
    List<FeedbackItem> itemList = [];
    try {
      await _collectionReference.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final feedback = FeedbackItem(
              id: doc["id"],
              name: doc["name"],
              description: doc["description"],
              url: doc["url"]
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





  Future updateData(String id, String name, String description, String url) async {
    final documentReference = _collectionReference.doc(id);

    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
    };

    return await documentReference.update(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'Feedback Updated.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future deleteData({required String id}) async {
    final documentReference = _collectionReference.doc(id);

    return await documentReference.delete()
        .whenComplete(() => Fluttertoast.showToast(msg: 'Feedback Deleted.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }
}