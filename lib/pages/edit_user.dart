import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/pages/home.dart';
import 'package:green_app/pages/registration_screen.dart';
import 'package:green_app/services/user_database.dart';

import '../models/user_model.dart';

import 'login_screen.dart';

class Edit_user extends StatefulWidget {

 // UserModel user;
  Edit_user({Key? key}) : super(key: key);

  @override
  State<Edit_user> createState() => _Edit_userState();
}

class _Edit_userState extends State<Edit_user> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser;

  final _user_database = UserDatabase();


  // string for displaying the error Message
  String? errorMessage;


  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  TextEditingController? firstNameEditingController;
  TextEditingController? secondNameEditingController;
  TextEditingController? emailEditingController;


  @override
  void initState() {
    super.initState();
  //  _user_database.readData();
  // Future<UserModel?> users = getUserDetails();
   SetUserDetails();

  }
   void SetUserDetails() async{
     loggedInUser = await _user_database.readData();

     setState(() {
      print("Set details");
      print(loggedInUser?.firstName);


      // editing Controller
      firstNameEditingController = new TextEditingController(text: loggedInUser?.firstName);
      secondNameEditingController = new TextEditingController(text: loggedInUser?.secondName);
      emailEditingController = new TextEditingController(text: loggedInUser?.email);

    });

  }






  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController?.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController?.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController?.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));


    //update button
    final UpdateButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.teal,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          onPressed: () {
            onUpdate();
          },
          child: Text(
            "Update",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //update button
    final DeleteButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          onPressed: () {
            onDelete();
          },
          child: Text(
            "Delete",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Update User Profile'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            logout(context);

          },
              icon: Icon(Icons.logout)
          )
        ],

      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 180,
                        child: Image.asset(
                          "assets/images/logo.jpg",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    firstNameField,
                    SizedBox(height: 20),
                    secondNameField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    UpdateButton,
                    SizedBox(height: 15),
                    DeleteButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  onUpdate() async {

    try{
      if(_formKey.currentState!.validate()){
        _formKey.currentState!.save();
        print('Form Submitted');


        await _user_database.updateData(loggedInUser?.uid.toString(),firstNameEditingController?.text.toString(), secondNameEditingController?.text.toString(), emailEditingController?.text.toString() );
      }
    } on Exception catch (error){
      print('Exception: $error');
    } finally {
      // TODO
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          )
      );
    }
  }



  onDelete() async {
    try {
      await _user_database.deleteData(uid: loggedInUser?.uid);
      print('delete');
      print(loggedInUser?.uid);
    } on Exception catch (e) {
      // TODO
    } finally {
      // TODO
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationScreen(),
          )
      );
    }
  }


  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }






}
