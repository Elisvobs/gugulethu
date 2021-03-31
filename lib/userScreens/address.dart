import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_tools.dart';

class Address extends StatefulWidget {
  final bool fromPayment;

  Address({this.fromPayment});

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  TextEditingController _descController = new TextEditingController();
  TextEditingController _stateController = new TextEditingController();
  TextEditingController _homeController = new TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  String _btnText;
  FirebaseUser user;
  FirebaseAuth _auth;
  bool _isSignedIn;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
//    _getUserInfo();
  }

//  Future _getUserInfo() async {
//    final cartRef = FirebaseDatabase.instance
//        .reference()
//        .child(AppData.userDB)
//        .child(AppData.currentUserID);
//
//    _userSubscription = await cartRef.once().then((snapshot) {
//      if (snapshot.value == null) {
//        fbConn = null;
//        setState(() {});
//        return;
//      }
//      Map valFav = snapshot.value;
//      fbConn = new FbConn(valFav);
//      _stateController.text = fbConn.getState();
//      _homeController.text = fbConn.getHomeAddress();
//      _descController.text = fbConn.getHomeDescription();
//      userid = fbConn.getUserID();
//      setState(() {});
//    });
//
//    _userSubscription = cartRef.onValue.listen((event) {
//      if (event.snapshot.value == null) {
//        fbConn = null;
//        setState(() {});
//        return;
//      }
//
//      if (widget.fromPayment == true) {
//        Navigator.of(context).pop();
//        return;
//      }
//
//      Map valFav = event.snapshot.value;
//      fbConn = new FbConn(valFav);
//      _stateController.text = fbConn.getState();
//      _homeController.text = fbConn.getHomeAddress();
//      _descController.text = fbConn.getHomeDescription();
//      userid = fbConn.getUserID();
//      setState(() {});
//    });
//  }

  var progress = new CircularProgressIndicator(
    backgroundColor: Colors.black12,
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
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Delivery Address",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      resizeToAvoidBottomPadding: false,
      body: new SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: new Container(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 10.0),
              ),
              new Container(
                height: 50.0,
                margin: new EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 12.0,
                  bottom: 5.0,
                ),
                child: new TextFormField(
                  controller: _stateController,
                  style: new TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                  decoration: new InputDecoration(
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(
                        Icons.location_on,
                        size: 20.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(5.0),
                    labelText: "City",
                    labelStyle: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: new BorderSide(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              new Container(
                height: 50.0,
                margin: new EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: new TextFormField(
                  controller: _homeController,
                  style: new TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                  decoration: new InputDecoration(
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(
                        Icons.home,
                        size: 20.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: "Address",
                    labelStyle: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: new BorderSide(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              new Container(
                height: 50.0,
                margin: new EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: new TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: new TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                  decoration: new InputDecoration(
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(
                        Icons.assignment,
                        size: 20.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: "Location Description",
                    labelStyle: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: new BorderSide(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              new InkWell(
                onTap: _saveProfile,
                child: new Container(
                  height: 60.0,
                  color: Colors.white,
                  margin: new EdgeInsets.only(top: 20.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Container(
                      width: screenSize.width,
                      margin: new EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        bottom: 2.0,
                      ),
                      height: 60.0,
                      decoration: new BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: new BorderRadius.all(
                          new Radius.circular(20.0),
                        ),
                      ),
                      child: new Center(
                        child: new Text(
                          "Save",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String title, IconData iconData, VoidCallback action) {
    final textStyle = new TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
    );

    return new InkWell(
      onTap: action,
      child: new Padding(
        padding: const EdgeInsets.only(
            left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 35.0,
              height: 35.0,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: new BorderRadius.circular(5.0),
              ),
              alignment: Alignment.center,
              child: new Icon(
                iconData,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            new Text(title, style: textStyle),
            new Expanded(child: new Container()),
            new IconButton(
              icon: new Icon(Icons.chevron_right, color: Colors.black26),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final mainTextStyle = new TextStyle(
      fontFamily: 'Timeburner',
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
    );
    final subTextStyle = new TextStyle(
      fontFamily: 'Timeburner',
      fontSize: 16.0,
      color: Colors.white70,
      fontWeight: FontWeight.w500,
    );

    return new Container(
      margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: new Row(
        children: <Widget>[
          new GestureDetector(
            //onTap: isLoggedIn == true ? setProfilePicture : null,
            child: new Container(
              width: 70.0,
              height: 70.0,
              margin: EdgeInsets.only(left: 10.0),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: profileImgUrl != null
                      ? new NetworkImage(profileImgUrl)
                      : new NetworkImage("http://i.imgur.com/QSev0hg.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
          ),
          new Padding(padding: const EdgeInsets.only(right: 20.0)),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                fullName != null ? fullName : fullName = "Your Name",
                style: mainTextStyle,
              ),
              new Text(
                email != null ? email : email = "Your Email",
                style: subTextStyle,
              ),
              new Text(
                phone != null ? phone : phone = "Your Number",
                style: subTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _saveProfile() async {
    if (_stateController.text == "") {
      showSnackBar("City cannot be empty", scaffoldKey);
      return;
    }

    if (_homeController.text == "") {
      showSnackBar("Home Address cannot be empty", scaffoldKey);
      return;
    }

    if (_descController.text == "") {
      showSnackBar("Description cannot be empty", scaffoldKey);
      return;
    }

    showDialog(
      context: context,
      child: progress,
    );

    //TODO add a condition to display the address if its been added before
    Map<String, dynamic> userMap = new Map();
    // userMap[AppData.state] = _stateController.text;
    // userMap[AppData.homeAddress] = _homeController.text;
    // userMap[AppData.homeDescription] = _descController.text;
    // await userRef.child(userid).update(userMap);
    Firestore firestore = Firestore.instance;
    FirebaseUser user;
    await firestore.collection(userData).document(user.uid).updateData({
      "address": _homeController.text,
      "location": _descController.text,
      "city": _stateController.text,
    });
    Navigator.of(context).pop();
    showSnackBar("Profile Updated", scaffoldKey);
  }
}
