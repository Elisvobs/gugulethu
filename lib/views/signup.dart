import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_methods.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/firebase_methods.dart';
import 'package:onlineshop/tools/validators.dart';

import 'shared/app_colors.dart';
import 'shared/icons.dart';
import 'shared/styles.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  BuildContext context;
  AppMethods appMethod = new FirebaseMethods();
  bool _obscureText = true;
  String _name, _phone, _email, _pass;
  String hide = 'hide password';
  String show = 'show password';

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: new AppBar(title: new Text("Sign Up"), centerTitle: true),
      body: Form(
        autovalidate: true,
        key: _formKey,
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                height: 120.0,
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: new EdgeInsets.only(top: 10.0, bottom: 0.0),
                        height: 100.0,
                        width: 100.0,
                        child: new Image.asset('assets/images/logo.png'),
                      ),
                    ],
                  ),
                ),
                decoration: new BoxDecoration(
                  color: primaryColor,
                  borderRadius: new BorderRadius.only(
                    bottomLeft: new Radius.circular(20.0),
                    bottomRight: new Radius.circular(20.0),
                  ),
                ),
              ),
              new Container(
                margin: new EdgeInsets.only(left: 7.5, right: 7.5),
                decoration: new BoxDecoration(
                  color: white,
                  borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(20.0),
                    topRight: new Radius.circular(20.0),
                  ),
                ),
                constraints: const BoxConstraints(maxHeight: 420.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new TextFormField(
                      onSaved: (String value) => _name = value,
                      keyboardType: TextInputType.name,
                      validator: nameVal,
                      style: registerTxt,
                      decoration: new InputDecoration(
                        prefixIcon: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Icon(Icons.person, size: 20.0),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: "Full Name",
                        labelStyle: regLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: new BorderSide(color: black),
                        ),
                      ),
                    ),
                    new SizedBox(height: 16.0),
                    new TextFormField(
                      onSaved: (String value) => _phone = value,
                      keyboardType: TextInputType.phone,
                      validator: mobileVal,
                      style: registerTxt,
                      decoration: new InputDecoration(
                        prefixIcon: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Icon(Icons.phone_iphone, size: 20.0),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: "Mobile Number",
                        labelStyle: regLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: new BorderSide(color: black),
                        ),
                      ),
                    ),
                    new SizedBox(height: 16.0),
                    new TextFormField(
                      onSaved: (String value) => _email = value,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailVal,
                      style: registerTxt,
                      decoration: new InputDecoration(
                        prefixIcon: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Icon(Icons.email, size: 20.0),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: "Email",
                        labelStyle: regLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: new BorderSide(color: black),
                        ),
                      ),
                    ),
                    new SizedBox(height: 16.0),
                    new TextFormField(
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) => setState(() => _pass = value),
                      validator: passwordVal,
                      onSaved: (String value) => _pass = value,
                      style: registerTxt,
                      decoration: new InputDecoration(
                        prefixIcon: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Icon(Icons.lock, size: 20.0),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscureText = !_obscureText),
                          child: Icon(
                            _obscureText ? invisible : visible,
                            semanticLabel: _obscureText ? hide : show,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: "Password",
                        labelStyle: regLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: new BorderSide(color: black),
                        ),
                      ),
                    ),
                    new SizedBox(height: 16.0),
                    new InkWell(
                      onTap: _submitForm,
                      child: new Container(
                        height: 60.0,
                        margin: new EdgeInsets.only(top: 5.0),
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Container(
                            width: screenSize.width,
                            margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 2.5),
                            height: 50.0,
                            decoration: new BoxDecoration(
                              color: primaryColor,
                              borderRadius: new BorderRadius.all(
                                new Radius.circular(20.0),
                              ),
                            ),
                            child: new Center(
                              child: new Text("Sign Up", style: regBtn),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    displayProgressDialog(context);

    String response = await appMethod.createUserAccount(
      fullName: _name,
      phone: _phone,
      email: _email,
      password: _pass,
      address: deliveryAddress,
      location: deliveryLocation,
      city: deliveryCity,
    );
    if (response == successful) {
      closeProgressDialog(context);
      Navigator.of(context).pop();
      Navigator.of(context).pop(true);
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }
  }
}
