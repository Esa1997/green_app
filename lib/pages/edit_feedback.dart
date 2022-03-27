import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/pages/feedback_grid.dart';
import 'package:image_picker/image_picker.dart';

import '../models/feedback_item.dart';
import '../services/flower _item_database.dart';
import '../services/review_database.dart';

class EditFeedbackItem extends StatefulWidget {
 // static const String routeName = '/edit_item';
  FeedbackItem item;

  EditFeedbackItem({Key? key, required this.item}) : super(key: key);
  @override
  _EditFeedbackItemState createState() => _EditFeedbackItemState();
}

class _EditFeedbackItemState extends State<EditFeedbackItem> {
  final _formKey = GlobalKey<FormState>();
  final database = FeedbackDatabase();
  File? _pickedImage;

  String? _id;
  String? _name;
  String? _description;
  String? _url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemDetails();
  }

  void getItemDetails(){
    setState(() {
      _id = widget.item.id;
      _name = widget.item.name;
      _description = widget.item.description;
      _url = widget.item.url;
    });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
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

  onUpdate() async {
    if(_pickedImage == null && _url == null){
      Fluttertoast.showToast(msg: 'Select an Image from Camera roll');
    }
    else{
      try{
        if(_formKey.currentState!.validate()){
          _formKey.currentState!.save();
          print('Form Submitted');

          if(_pickedImage != null){
            final ref = FirebaseStorage.instance.ref()
                .child('flowerImages')
                .child(_name! + '.jpg');
            await ref.putFile(_pickedImage!);

            _url = await ref.getDownloadURL();
            print('Image URL: $_url');
          }

          await database.updateData(_id!, _name!, _description!, _url!);
        }
      } on Exception catch (error){
        print('Exception: $error');
      } finally {
        // TODO
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackGrid(),
            )
        );
      }
    }
  }

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
            builder: (context) => FeedbackGrid(),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Update Feedback'),
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
                      ): Stack(
                        children: [
                          ClipOval(
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
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)
                            ),
                            labelText: 'Nickname',
                            helperText: 'Name',
                          ),
                          controller: TextEditingController(text: '$_name'),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Please Enter Name';
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
                              labelText: 'Feedback',
                              helperText: 'Feedback'
                          ),
                          controller: TextEditingController(text: '$_description'),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Please Enter Feedback';
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
                          ElevatedButton.icon(
                            onPressed: onDelete,
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
                          ElevatedButton.icon(
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
