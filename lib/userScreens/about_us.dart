import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String aboutUs =
      "Gugulethu is an e-commerce platform offering a variety of products at your doorstep. Let us simplify shopping for you.";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("About Us"),
        centerTitle: false,
      ),
      body: new Container(
        constraints: const BoxConstraints(maxHeight: 500.0),
        margin: new EdgeInsets.all(5.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
        ),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                height: 50.0,
                child:
                    new Image.asset("assets/images/girlies_text_colored.png"),
              ),
              new SizedBox(
                height: 50.0,
                child: new Image.asset("assets/images/girlies_logo.png"),
              ),
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text(
                  "Version 0.0.1",
                  style: new TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text(
                  "Gugulethu for your shopping convenience...",
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black26,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  aboutUs,
                  style: new TextStyle(
                      fontSize: 15.0,
                      // color: MyApp.appColors,
                      fontStyle: FontStyle.normal,
                      wordSpacing: 2.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
