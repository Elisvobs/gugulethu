import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_methods.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/firebase_methods.dart';

import 'signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  AppMethods appMethod = new FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Login",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: true,
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
              height: 120.0,
              child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                        height: 100.0,
                        width: 100.0,
                        child:
                            new Image.asset('assets/images/girlies_logo.png')),

                  ],
                ),
              ),
              decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: new BorderRadius.only(
                      bottomLeft: new Radius.circular(20.0),
                      bottomRight: new Radius.circular(20.0),),),
            ),
            new Container(
              margin: new EdgeInsets.only(left: 7.5, right: 7.5),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: new Radius.circular(20.0),
                      topRight: new Radius.circular(20.0),),),
              constraints: const BoxConstraints(maxHeight: 400.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    height: 60.0,
                    margin: new EdgeInsets.only(top: 5.0),
                    child: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Container(
                        width: screenSize.width,
                        margin: new EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 5.0,),
                        height: 60.0,
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(20.0),),),
                        child: new TextFormField(
                          controller: email,
//                          textType: TextInputType.email,
                          style: new TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18.0),
                          decoration: new InputDecoration(
                            prefixIcon: new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Icon(
                                Icons.email,
                                size: 20.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(15.0),
                            labelText: "Email",
                            labelStyle: new TextStyle(
                                fontSize: 20.0, color: Colors.black54,),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: new BorderSide(color: Colors.black54),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 15.0
                  ),
                  new Container(
                    height: 60.0,
                    margin: new EdgeInsets.only(top: 5.0),
                    child: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Container(
                        width: screenSize.width,
                        margin: new EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 5.0,),
                        height: 60.0,
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(20.0),),),
                        child: new TextFormField(
                          controller: password,
                          obscureText: true,
                          style: new TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18.0,),
                          decoration: new InputDecoration(
                            prefixIcon: new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Icon(
                                Icons.lock,
                                size: 20.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(15.0),
                            labelText: "Password",
                            labelStyle: new TextStyle(
                                fontSize: 20.0, color: Colors.black54,),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide:
                                    new BorderSide(color: Colors.black54),),
                          ),
                        ),
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 15.0
                  ),
                  new InkWell(
                    onTap: verifyLogin,
                    child: new Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(top: 5.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            bottom: 5.0,
                          ),
                          height: 50.0,
                          decoration: new BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0),),),
                          child: new Center(
                              child: new Text(
                            "Login",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),),
                        ),
                      ),
                    ),
                  ),
//                  appButton(
//                    btnText: "Login",
//                    onBtnClicked: verifyLogin,
//                    btnPadding: 15.0,
//                    btnColor: Colors.white,
//                  ),
                  new SizedBox(
                    height: 15.0
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 20.0,
                    ),
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (BuildContext context) => new SignUp(),),
                        );
                      },
                      child: new Text(
                        "Not Registered? Sign Up Here!",
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 15.0
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 20.0,),
                    child: new GestureDetector(
                      onTap: () {
//                        Navigator.of(context).push(new CupertinoPageRoute(
//                            builder: (BuildContext context) => new SignUp()));
                      },
                      child: new Text(
                        "Forgot Password?",
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.yellow,
                          fontWeight: FontWeight.w500,
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
    );
  }

  verifyLogin() async {
    if (email.text == "") {
      showSnackBar("Email cannot be empty!", scaffoldKey);
      return;
    }

    if (password.text == "") {
      showSnackBar("Password cannot be empty!", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
//    try {
//      String response = await appMethod.loginUser(
//          email: email.text.toLowerCase(), password: password.text);
//    } on PlatformException catch(e) {
//      print(e.details);
//      return e.details;
//    }
    String response = await appMethod.loginUser(
        email: email.text.toLowerCase(), password: password.text);
    if (response == successful) {
      closeProgressDialog(context);
      Navigator.of(context).pop(true);
      showSnackBar("Login successful", scaffoldKey);
    } else {
      closeProgressDialog(context);
//      showSnackBar(errorMSG, scaffoldKey);
    }
  }
}
