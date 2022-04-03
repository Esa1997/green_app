import 'package:flutter/material.dart';
import 'package:green_app/services/delivery_database.dart';
import '../models/flower_item.dart';
import '../models/user_delivery.dart';
import '../models/user_model.dart';

class DeliveryForm extends StatefulWidget {
  static const String routeName= '/deliveryForm';
  String total;

  DeliveryForm({Key? key, required this.total}) : super(key: key);

  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  String? _senderName;
  String? _senderEmail;
  String? _senderAddress;
  String? _senderPhone;
  String? _receiverName;
  String? _receiverAddress;
  String? _receiverPhoneNumber;
  String? _date;
  String? _total;

  TextEditingController? userNameController;
  TextEditingController? senderEmailController;
  TextEditingController? senderAddressController;
  TextEditingController? senderPhoneNumberController;
  TextEditingController? receiverNameController;
  TextEditingController? receiverAddressController;
  TextEditingController? receiverPhoneNumberController;

  var date = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final database = DeliveryDatabase();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserDelivery? loggedInUser;

  @override
  void initState() {
    super.initState();
    getItemDetails();
    getUserData();
  }

  void getItemDetails(){
    setState(() {
      _total = widget.total;
    });
  }

  void getUserData() async{
    loggedInUser = await database.getUserDeliveryDetails();

    setState(() {
      if(loggedInUser != null){
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

  Widget _buildReceiverName() {
    return TextFormField(
      controller: receiverNameController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Receiver Name'
      ),
      keyboardType: TextInputType.name,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Receiver Name is Required';
        }
        return null;
      },
      onSaved: (String? value) {
        _receiverName = value;
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

  Widget _buildReceiverAddress() {
    return TextFormField(
      controller: receiverAddressController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Receiver Address'
      ),
      keyboardType: TextInputType.streetAddress,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Address is Required';
        }
        return null;
      },
      onSaved: (String? value) {
        _receiverAddress = value;
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
        _senderPhone = value;
      },
    );
  }

  Widget _buildReceiverPhoneNumber() {
    return TextFormField(
      controller: receiverPhoneNumberController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Receiver Phone number'
      ),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _receiverPhoneNumber = value;
      },
    );
  }

  Widget _buildDate() {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: TextFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)
            ),
            labelText: 'Date'
        ),
        controller: date,
        enabled: false,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Date is Required';
          }

          return null;
        },
        onSaved: (String? value) {
          _date = value;
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (picked != null && picked != selectedDate) {
      setState(() {
        date.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  onSaved() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try{
      await database.addData(
          _senderName,
          _senderEmail,
          _senderAddress,
          _senderPhone,
          _receiverName,
          _receiverAddress,
          _receiverPhoneNumber,
          _date!,
          _total!);
    } on Exception catch (error){
      print('Exception: $error');
    } finally {
      Navigator.of(context).pop();
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Delivery"),
        centerTitle: true),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              //   Card(
              //   elevation: 5,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20)
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(10),
              //     child: Row(
              //       children: [
              //         Image.network(
              //           _flower!.url,
              //           width: 100,
              //           height: 100,
              //           fit: BoxFit.fitHeight,),
              //         const SizedBox(width: 20),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               _flower!.name,
              //               style: const TextStyle(
              //                   fontSize: 20.0,
              //                   color: Colors.black, fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             const SizedBox(height: 5),
              //             Text(
              //               _flower!.price.toString(),
              //               style: TextStyle(
              //                   fontSize: 14.0,
              //                   color: Colors.grey[600], fontWeight: FontWeight.bold
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
                  const SizedBox(height: 20),
                  _buildSenderName(),
                  const SizedBox(height: 20),
                  _buildSenderEmail(),
                  const SizedBox(height: 20),
                  _buildSenderAddress(),
                  const SizedBox(height: 20),
                  _buildSenderPhoneNumber(),
                  const SizedBox(height: 20),
                  _buildReceiverName(),
                  const SizedBox(height: 20),
                  _buildReceiverAddress(),
                  const SizedBox(height: 20),
                  _buildReceiverPhoneNumber(),
                  const SizedBox(height: 20),
                  _buildDate(),
                  const SizedBox(height: 50),
                  ElevatedButton.icon(
                    onPressed: onSaved,
                    icon: const Icon(Icons.check, size: 30,),
                    label: const Text(
                      'SUBMIT',
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
