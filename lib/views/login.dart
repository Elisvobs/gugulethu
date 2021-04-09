import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_methods.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/firebase_methods.dart';
import 'package:onlineshop/tools/validators.dart';
import 'package:onlineshop/views/shared/icons.dart';

import 'shared/app_colors.dart';
import 'shared/styles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  AppMethods appMethod = new FirebaseMethods();
  bool _obscureText = true;
  String _email, _password;
  String notReg = "Not Registered? Sign Up Here!";
  String hide = 'hide password';
  String show = 'show password';

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: new AppBar(title: new Text("Login"), centerTitle: true),
      resizeToAvoidBottomPadding: true,
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.only(top: 0.0, bottom: 10.0),
                height: 120.0,
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                constraints: const BoxConstraints(maxHeight: 400.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    new TextFormField(
                      onSaved: (String value) => _email = value,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailVal,
                      style: loginTxt,
                      decoration: new InputDecoration(
                        prefixIcon: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Icon(Icons.email, size: 20.0),
                        ),
                        contentPadding: EdgeInsets.all(15.0),
                        labelText: "Email",
                        labelStyle: loginLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: new BorderSide(color: black),
                        ),
                      ),
                    ),
                    new SizedBox(height: 16.0),
                    new TextFormField(
                      obscureText: _obscureText,
                      onSaved: (String value) => _password = value,
                      keyboardType: TextInputType.visiblePassword,
                      validator: passwordVal,
                      style: loginTxt,
                      decoration: new InputDecoration(
                        prefixIcon: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Icon(Icons.lock, size: 20.0),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() {
                            _obscureText = !_obscureText;
                          }),
                          child: Icon(
                            _obscureText ? invisible : visible,
                            semanticLabel: _obscureText ? hide : show,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(15.0),
                        labelText: "Password",
                        labelStyle: loginLabel,
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
                            margin:
                                new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                            height: 50.0,
                            decoration: new BoxDecoration(
                              color: primaryColor,
                              borderRadius: new BorderRadius.all(
                                new Radius.circular(20.0),
                              ),
                            ),
                            child: new Center(
                              child: new Text("Login", style: loginLabel),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new SizedBox(height: 16.0),
                    new Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                      child: new GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/register'),
                        child: new Text(notReg, style: link),
                      ),
                    ),
                    new SizedBox(height: 16.0),
                    new Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                      child: new GestureDetector(
                        onTap: () => null,
                        child: new Text("Forgot Password?", style: forget),
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
//    try {
//      String response = await appMethod.loginUser(
//          email: email.text.toLowerCase(), password: password.text);
//    } on PlatformException catch(e) {
//      print(e.details);
//      return e.details;
//    }
    String response =
        await appMethod.loginUser(email: _email, password: _password);
    if (response == successful) {
      closeProgressDialog(context);
      Navigator.of(context).pop(true);
      showSnackBar("Login successful", scaffoldKey);
    } else {
      closeProgressDialog(context);
      // showSnackBar(errorMSG, scaffoldKey);
    }
  }
}
