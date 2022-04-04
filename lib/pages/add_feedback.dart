import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/pages/feedback_grid.dart';
import 'package:green_app/pages/flower_grid.dart';
import 'package:green_app/services/review_database.dart';
import 'package:image_picker/image_picker.dart';

import '../models/flower_item.dart';

class AddFeedback extends StatefulWidget {
  //static const String routeName = '/add_feedback';
  String item_id;

  AddFeedback({Key? key, required this.item_id}) : super(key: key);
  @override
  _AddFeedbackState createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  final _formKey = GlobalKey<FormState>();
  final database = FeedbackDatabase();
  File? _pickedImage;
  double rating = 0;

  String? _name;
  String? _description;
  String? _url;
  double? _rating;

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //
  //     final imageTemporary = File(image.path);
  //     setState(() {
  //       this._pickedImage = imageTemporary;
  //     });
  //   } on PlatformException catch (e) {
  //     // TODO
  //     print('Failed to pick image: $e');
  //   }
  // }
  File? image;

  //Camera roll

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


  onSaved() async {
    String id = widget.item_id;

    if(_pickedImage == null){
      Fluttertoast.showToast(msg: 'Select an Image from Camera roll');
    }
    else{
      try{
        if(_formKey.currentState!.validate()){
          _formKey.currentState!.save();
          print('Form Submitted');

          final ref = FirebaseStorage.instance.ref()
              .child('flowerImages')
              .child(_name! + '.jpg');
          await ref.putFile(_pickedImage!);

          _url = await ref.getDownloadURL();
          print('Image URL: $_url');

          await database.addData(id, _name!, _description!, _url!,_rating!);
        }
      } on Exception catch (error){
        print('Exception: $error');
      } finally {
        // TODO
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackGrid(item_id: widget.item_id),
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
          title: Text('Add Feedback'),
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
                              labelText: 'Nickname'
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Please Enter the Name';
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
                              labelText: 'Feedback'
                          ),
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
                      Padding(padding:const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Rating: $rating',
                              style: TextStyle(fontSize: 40,),
                            ),
                            SizedBox(height: 20),
                            RatingBar.builder(
                                minRating: 1,
                                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber,),
                                onRatingUpdate: (rating) => setState(() {

                                  this.rating = rating;
                                  if(rating != null) _rating = rating;

                                })),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: onSaved,
                        icon: Icon(Icons.playlist_add, size: 30,),
                        label: Text(
                          'ADD FEEDBACK',
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
