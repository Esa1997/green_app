import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_model.dart';

class UserDatabase{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _collectionReference = _firestore.collection('users');


  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;


  readData() async {
    final _auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;



    UserModel? loggedInUser;
    await _collectionReference.get().then((QuerySnapshot querySnapshot) {

      querySnapshot.docs.forEach((doc) {

        if(doc["uid"] == user?.uid ){
          loggedInUser = UserModel(uid: user?.uid,firstName:doc["firstName"] ,secondName:doc["secondName"] ,email:doc["email"] );
        }
        else{

        }

        //itemList.add(flower);
      });
    });
    print("From database");
    print(loggedInUser?.firstName);
    return loggedInUser;

  }


  Future updateData(String? uid, String? firstname, String? secondname, String? email) async {
    final documentReference = _collectionReference.doc(uid);

    Map<String, dynamic> data = {
      'uid': uid.toString(),
      'firstName': firstname.toString(),
      'secondName': secondname.toString(),
      'email': email.toString(),

    };

    return await documentReference.update(data)
        .whenComplete(() => Fluttertoast.showToast(msg: 'User Updated.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }


  Future deleteData({required String? uid}) async {
    final documentReference = _collectionReference.doc(uid);

    return await documentReference.delete()
        .whenComplete(() => Fluttertoast.showToast(msg: 'User Deleted.'))
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }


}