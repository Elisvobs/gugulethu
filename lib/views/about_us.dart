import 'package:flutter/material.dart';

import 'shared/app_colors.dart';
import 'shared/styles.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String aboutUs =
      "Gugulethu is an e-commerce platform offering a variety of products at your doorstep. Let us simplify shopping for you.";
  String motto = "Gugulethu for your shopping convenience...";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("About Us"), centerTitle: false),
      body: new Container(
        constraints: const BoxConstraints(maxHeight: 500.0),
        margin: new EdgeInsets.all(5.0),
        decoration: new BoxDecoration(
          color: white,
          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
        ),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                height: 50.0,
                child: new Image.asset("assets/images/girlies_text_color.png"),
              ),
              new SizedBox(
                height: 50.0,
                child: new Image.asset("assets/images/logo.png"),
              ),
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text("Version 0.0.1", style: version),
              ),
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text(motto, style: about),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(aboutUs, style: abt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
