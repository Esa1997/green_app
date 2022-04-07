import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_app/models/delivery_item.dart';
import 'package:green_app/pages/delivery_history.dart';

import '../services/delivery_database.dart';

class EditDelivery extends StatefulWidget {
  static const String routeName= '/editDelivery';
  DeliveryItem item;

  EditDelivery({Key? key, required this.item}) : super(key: key);

  @override
  _EditDeliveryState createState() => _EditDeliveryState();
}

class _EditDeliveryState extends State<EditDelivery> {
  String? _senderName;
  String? _receiverName;
  String? _receiverAddress;
  String? _receiverPhoneNumber;
  String? _date;

  var date = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final database = DeliveryDatabase();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getItemDetails();
  }

  void getItemDetails(){
    setState(() {
      _senderName = widget.item.senderName;
      _receiverName = widget.item.receiverName;
      _receiverAddress = widget.item.receiverAddress;
      _receiverPhoneNumber = widget.item.receiverPhone;
      _date = widget.item.date;
      date.text = widget.item.date;
    });
  }

  Widget _buildSenderName() {
    return TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Sender Name'
      ),
      controller: TextEditingController(text: '$_senderName'),
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

  Widget _buildReceiverName() {
    return TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Receiver Name'
      ),
      controller: TextEditingController(text: '$_receiverName'),
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

  Widget _buildReceiverAddress() {
    return TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Receiver Address'
      ),
      controller: TextEditingController(text: '$_receiverAddress'),
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

  Widget _buildReceiverPhoneNumber() {
    return TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          ),
          labelText: 'Receiver Phone number'
      ),
      controller: TextEditingController(text: '$_receiverPhoneNumber'),
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

  //date picker
  // /[4]"showDatePicker function - material library - Dart API", Api.flutter.dev, 2022. [Online]. Available: https://api.flutter.dev/flutter/material/showDatePicker.html. [Accessed: 07- Apr- 2022]
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
      await database.updateData(widget.item.id, _senderName!, _receiverName!, _receiverAddress!, _receiverPhoneNumber!, _date!);
    } on Exception catch (error){
      print('Exception: $error');
    } finally {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryHistory(),
          )
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 20),
                _buildSenderName(),
                const SizedBox(height: 20),
                _buildReceiverName(),
                const SizedBox(height: 20),
                _buildReceiverPhoneNumber(),
                const SizedBox(height: 20),
                _buildReceiverAddress(),
                const SizedBox(height: 20),
                _buildDate(),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  onPressed: onSaved,
                  icon: const Icon(Icons.check, size: 30,),
                  label: const Text(
                    'UPDATE',
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
    );
  }
}
