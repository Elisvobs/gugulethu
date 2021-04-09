import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/validators.dart';

import '../main.dart';
import 'shared/app_colors.dart';
import 'shared/styles.dart';

class Address extends StatefulWidget {
  final bool fromPayment;

  Address({this.fromPayment});

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  FirebaseUser _user;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  BuildContext context;
  String _city, _location, _address;

  @override
  void initState() {
    super.initState();
    //todo access and initialise stored address data info
    // if (_user != null && firestore.collection('userData') != null) {
    // _city = null;
    // }
    // if (widget.food != null) {
    //   _name = widget.food.name;
    // }
  }

  var progress = new CircularProgressIndicator(
    backgroundColor: black,
//    color: Colors.white,
//    containerColor: Theme.of(context).primaryColor,
//    borderRadius: 5.0,
//    text: new Text('Saving Details....'),
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: new AppBar(
        title: new Text("Delivery Address"),
        centerTitle: false,
      ),
      resizeToAvoidBottomPadding: false,
      body: Form(
        autovalidate: true,
        key: _formKey,
        child: new SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: 32.0),
                new TextFormField(
                  initialValue: _city,
                  onSaved: (String value) => _city = value,
                  keyboardType: TextInputType.name,
                  validator: cityVal,
                  style: addTxt,
                  decoration: new InputDecoration(
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(Icons.location_on, size: 20.0),
                    ),
                    contentPadding: EdgeInsets.all(5.0),
                    labelText: "City",
                    labelStyle: addLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: new BorderSide(color: black),
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                new TextFormField(
                  initialValue: _address,
                  onSaved: (String value) => _address = value,
                  keyboardType: TextInputType.streetAddress,
                  validator: addressVal,
                  style: addTxt,
                  decoration: new InputDecoration(
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(Icons.home, size: 20.0),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: "Address",
                    labelStyle: addLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: new BorderSide(color: black),
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                new TextFormField(
                  initialValue: _location,
                  onSaved: (String value) => _location = value,
                  keyboardType: TextInputType.streetAddress,
                  validator: locationVal,
                  style: addTxt,
                  decoration: new InputDecoration(
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(Icons.assignment, size: 20.0),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: "Location",
                    labelStyle: addLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: new BorderSide(color: black),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                new InkWell(
                  onTap: _submitForm,
                  child: new Container(
                    height: 60.0,
                    color: white,
                    margin: new EdgeInsets.only(top: 20.0),
                    child: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Container(
                        width: screenSize.width,
                        margin: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
                        height: 60.0,
                        decoration: new BoxDecoration(
                          color: primaryColor,
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(20.0),
                          ),
                        ),
                        child: new Center(
                          child: new Text("Save", style: addBtn),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    showDialog(context: context, child: progress);

    //TODO add a condition to display the address if its been added before

    await fb.collection(userData).document(_user.uid).updateData(
      {
        deliveryAddress: _address,
        deliveryLocation: _location,
        deliveryCity: _city,
      },
    );
    Navigator.of(context).pop();
    showSnackBar("Address Info Updated", scaffoldKey);
  }
}
