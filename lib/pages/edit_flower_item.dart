import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/flower_item.dart';
import 'package:green_app/pages/flower_grid.dart';
import 'package:image_picker/image_picker.dart';

import '../services/flower _item_database.dart';

class EditItem extends StatefulWidget {
  static const String routeName = '/edit_item';
  FlowerItem item;

  EditItem({Key? key, required this.item}) : super(key: key);
  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  final database = FlowerItemDatabase();
  File? _pickedImage;

  String? _id;
  String? _name;
  double? _price;
  String? _description;
  String? _url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemDetails();
  }

  //initial form fields using the selected flower items details
  void getItemDetails(){
    setState(() {
      _id = widget.item.id;
      _name = widget.item.name;
      _price = widget.item.price;
      _description = widget.item.description;
      _url = widget.item.url;
    });
  }

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

  //implement update function when update button is pressed
  onUpdate() async {
    //validate all fields including image and submit form
    if(_pickedImage == null && _url == null){
      Fluttertoast.showToast(msg: 'Select an Image from Gallery');
    }
    else{
      try{
        if(_formKey.currentState!.validate()){
          _formKey.currentState!.save();
          print('Form Submitted');

          //upload selected image to firebase storage and download it's url
          if(_pickedImage != null){
            final ref = FirebaseStorage.instance.ref()
                .child('flowerImages')
                .child(_name! + '.jpg');
            await ref.putFile(_pickedImage!);

            _url = await ref.getDownloadURL();
            print('Image URL: $_url');
          }

          await database.updateData(_id!, _name!, _price!, _description!, _url!);

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

  //implement delete function when delete button is pressed
  onDelete() async {
    try {
      await database.deleteData(id: _id!);
    } on Exception catch (e) {
      // TODO
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

  //build edit flower item page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Update Flower'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      _pickedImage != null ? Stack( // display selected image
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
                      ): Stack(
                        children: [
                          ClipOval( //display when image not selected
                            child: Material(
                              color: Colors.transparent,
                              child: Image.network(_url!, width: 140, height: 140,)
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
                      SizedBox(height: 10),
                      Padding( // name input field
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)
                              ),
                              labelText: 'Name',
                              helperText: 'Name',
                          ),
                          controller: TextEditingController(text: '$_name'),
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
                      Padding( // price input field
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)
                              ),
                              labelText: 'Price',
                              helperText: 'Price'
                          ),
                          controller: TextEditingController(text: '$_price'),
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
                      Padding( // description input field
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)
                              ),
                              labelText: 'Description',
                              helperText: 'Description'
                          ),
                          controller: TextEditingController(text: '$_description'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon( //delete flower item button
                            onPressed: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                  return AlertDialog( //Alert dialog box
                                    title: Text("Alert"),
                                    content: Text("Are you sure you want to delete this Item?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed:  () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Delete"),
                                        onPressed:  () {
                                          onDelete();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.delete, size: 25,),
                            label: Text(
                              'DELETE ITEM',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                          ),
                          SizedBox(width: 40,),
                          ElevatedButton.icon( //update flower item button
                            onPressed: onUpdate,
                            icon: Icon(Icons.edit, size: 25,),
                            label: Text(
                              'UPDATE ITEM',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                          )
                        ],
                      ),

                    ],
                  ))
            ],
          ),
        )
    );
  }



}
