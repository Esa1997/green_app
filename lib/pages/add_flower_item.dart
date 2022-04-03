import 'dart:io';

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
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

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
    if(_pickedImage == null){
      Fluttertoast.showToast(msg: 'Select an Image from Gallery');
    }
    else{
      try{
        if(_formKey.currentState!.validate()){
          _formKey.currentState!.save();

          final ref = FirebaseStorage.instance.ref()
              .child('flowerImages')
              .child(_name! + '.jpg');

          await ref.putFile(_pickedImage!);

          _url = await ref.getDownloadURL();
          await database.addData(_name!, _price!, _description!, _url!);
        }
      } on Exception catch (error){
        print('Exception: $error');
      } finally {
        // TODO
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlowerGrid(),
            )
        );
      }
    }
  }

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
                      _pickedImage != null ? Stack(
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
                      ): CircleAvatar(
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
                      Padding(
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
                      Padding(
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
                      Padding(
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
                      ElevatedButton.icon(
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

  Widget FlowerImage(){
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent ,
              child: Ink.image(
                image: NetworkImage('https://media.istockphoto.com/vectors/picture-icon-vector-id931643150?k=20&m=931643150&s=170667a&w=0&h=e2cJ0QZTdfNcQ_f2V6ll_aWfLGJiHMyy5IBwmcPHgyU='),
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(onTap: (){},),
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
      ),
    );
  }
}
