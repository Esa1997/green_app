import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/pages/flower_grid.dart';
import 'package:green_app/services/flower%20_item_database.dart';
import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  static const String routeName = '/add_item';
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final database = FlowerItemDatabase();
  File? _pickedImage;

  String? _name;
  double? _price;
  String? _description;
  String? _url;

  Future pickImage() async {
    try {
      //select image from gallery
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      //display selected image
      final imageTemporary = File(image.path);
      setState(() {
        this._pickedImage = imageTemporary;
      });
    } on PlatformException catch (e) {
      // TODO
      print('Failed to pick image: $e');
    }
  }

  onSaved() async {
    //validate all fields including image and submit form
    if(_pickedImage == null){
      Fluttertoast.showToast(msg: 'Select an Image from Gallery');
    }
    else{
      try{
        if(_formKey.currentState!.validate()){
          _formKey.currentState!.save();

          //upload selected image to firebase storage and download it's url
          final ref = FirebaseStorage.instance.ref()
              .child('flowerImages')
              .child(_name! + '.jpg');

          await ref.putFile(_pickedImage!);

          _url = await ref.getDownloadURL();

          final User? user = FirebaseAuth.instance.currentUser;
          String? user_id = user?.uid;
          await database.addData(user_id!, _name!, _price!, _description!, _url!);

          //navigate to home page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlowerGrid(),
              )
          );
        }
      } on Exception catch (error){
        print('Exception: $error');
      }

    }
  }


  //build add flower item page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add New Flower'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      _pickedImage != null ? Stack( //display selected image
                        children: [
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Image.file(
                                _pickedImage!,
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 4,
                              child: ClipOval(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  color: Colors.teal,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onTap: pickImage,
                                  ),
                                ),
                              )
                          ),
                        ],
                      ): CircleAvatar( //display when image is not selected
                        radius: 80,
                        child: InkWell(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 55,
                            color: Colors.white,
                          ),
                          onTap: pickImage,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding( //name input field
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)
                              ),
                              labelText: 'Name'
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Please Enter Flower Name';
                            }
                            return null;
                          },
                          onSaved: (String? value){
                            setState(() {
                              if(value != null) _name = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding( //price input field
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)
                              ),
                              labelText: 'Price'
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Please Enter Price of Flower';
                            }
                            return null;
                          },
                          onSaved: (String? value){
                            setState(() {
                              if(value != null) _price = double.parse(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding( //description input field
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)
                              ),
                              labelText: 'Description'
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Please Enter Description';
                            }
                            return null;
                          },
                          onSaved: (String? value){
                            setState(() {
                              if(value != null) _description = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),

                      SizedBox(height: 20),
                      ElevatedButton.icon( //add item button
                        onPressed: onSaved,
                        icon: Icon(Icons.playlist_add, size: 30,),
                        label: Text(
                          'ADD ITEM',
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
        )
    );
  }

}
