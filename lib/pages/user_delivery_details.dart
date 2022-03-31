import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/services/delivery_database.dart';
import '../models/user_delivery.dart';

class UserDeliveryDetails extends StatefulWidget {
  static const String routeName= '/userDeliveryDetails';

  UserDeliveryDetails({Key? key}) : super(key: key);

  @override
  _UserDeliveryDetailsState createState() => _UserDeliveryDetailsState();
}

class _UserDeliveryDetailsState extends State<UserDeliveryDetails> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final database = DeliveryDatabase();
  UserDelivery? loggedInUser;
  String? _id;
  String? _senderName;
  String? _senderEmail;
  String? _senderAddress;
  String? _senderPhoneNumber;

  TextEditingController? userNameController;
  TextEditingController? senderEmailController;
  TextEditingController? senderAddressController;
  TextEditingController? senderPhoneNumberController;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async{
    loggedInUser = await database.getUserDeliveryDetails();

    setState(() {
      if(loggedInUser != null){
        _id = loggedInUser?.id;
        userNameController = TextEditingController(text: loggedInUser?.senderName);
        senderEmailController = TextEditingController(text: loggedInUser?.senderEmail);
        senderAddressController = TextEditingController(text: loggedInUser?.senderAddress);
        senderPhoneNumberController = TextEditingController(text: loggedInUser?.senderPhone);
      }
    });

  }

  Widget _buildSenderName() {
    return TextFormField(
      controller: userNameController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Sender Name'
      ),
      keyboardType: TextInputType.name,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Sender Name is Required';
        }
        return null;
      },
      onSaved: (String? value) {
        _senderName = value;
      },
    );
  }

  Widget _buildSenderEmail() {
    return TextFormField(
      controller: senderEmailController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Sender Email'
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Email is Required';
        }
        if (!RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String? value) {
        _senderEmail = value;
      },
    );
  }

  Widget _buildSenderAddress() {
    return TextFormField(
      controller: senderAddressController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Sender Address'
      ),
      keyboardType: TextInputType.streetAddress,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Address is Required';
        }
        return null;
      },
      onSaved: (String? value) {
        _senderAddress = value;
      },
    );
  }

  Widget _buildSenderPhoneNumber() {
    return TextFormField(
      controller: senderPhoneNumberController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Sender Phone number'
      ),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _senderPhoneNumber = value;
      },
    );
  }

  onSaved() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try{
      await database.addDeliveryDetailsData(
          _id,
          _senderName,
          _senderEmail,
          _senderAddress,
          _senderPhoneNumber);
    } on Exception catch (error){
      print('Exception: $error');
    } finally {
      Navigator.of(context).pop();
    }
  }

  onDelete() async {
    try{
      await database.deleteDeliveryData(id: _id);
    } on Exception catch (error){
      print('Exception: $error');
    } finally {
      Fluttertoast.showToast(msg: 'Deleted Successfully');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Delivery Details"),
            centerTitle: true),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  _buildSenderName(),
                  const SizedBox(height: 20),
                  _buildSenderEmail(),
                  const SizedBox(height: 20),
                  _buildSenderAddress(),
                  const SizedBox(height: 20),
                  _buildSenderPhoneNumber(),
                  const SizedBox(height: 50),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.teal,
                    child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width,
                        onPressed: onSaved,
                        child: const Text(
                          "Update",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.redAccent,
                    child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width,
                        onPressed: onDelete,
                        child: const Text(
                          "Delete",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
