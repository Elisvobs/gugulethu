import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_tools.dart';

import '../main.dart';
import 'shared/app_colors.dart';
import 'shared/icons.dart';
import 'shared/styles.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  String fullName, email, phone;
  String userid, profileImgUrl;
  bool isLoggedIn;

  // final googleSignIn = new GoogleSignIn();
  FirebaseUser user;
  bool _isSignedIn;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  _getCurrentUser() async {
    user = await auth.currentUser().catchError((error) {
      print(error);
    });

    if (user != null) {
      setState(() {
        // ignore: unnecessary_statements
        _isSignedIn == false ? "Login" : "Logout";
        email = user.email;
        fullName = user.displayName;
        profileImgUrl = user.photoUrl;
        //profileImgUrl = googleSignIn.currentUser.photoUrl;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("Profile Settings"),
        centerTitle: false,
      ),
      body: new Container(
        constraints: const BoxConstraints(maxHeight: 500.0),
        child: Column(
          children: [
            new Container(
              margin: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
              child: DecoratedBox(
                child: _buildAvatar(),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                  color: primaryColor,
                ),
              ),
            ),
            new Divider(height: 10.0),
            _buildListItem('Change Name', Icons.person, () {}),
            _buildListItem('Change Number', Icons.phone_iphone, () {}),
            _buildListItem(
              'Delivery Address',
              Icons.home,
              () => Navigator.of(context).pushNamed('/address'),
            ),
            _buildListItem(
              'Order History',
              Icons.history,
              () => Navigator.of(context).pushNamed('/his'),
            ),
            _buildListItem(
              'About Us',
              Icons.help,
              () => Navigator.of(context).pushNamed('/about'),
            ),
            new InkWell(
              child: new Container(
                height: 50.0,
                color: white,
                margin: new EdgeInsets.only(top: 20.0),
                child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Container(
                    width: screenSize.width,
                    margin: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
                    height: 60.0,
                    decoration: new BoxDecoration(
                      color: blue,
                      borderRadius: new BorderRadius.all(
                        new Radius.circular(5.0),
                      ),
                    ),
                    child: new Center(
                      child: new Text(_isSignedIn == true ? "LOGIN" : "LOGOUT",
                          style: whiteTxt),
                    ),
                  ),
                ),
              ),
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, IconData iconData, VoidCallback action) {
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 35.0,
              height: 35.0,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: new BoxDecoration(
                color: blue,
                borderRadius: new BorderRadius.circular(5.0),
              ),
              alignment: Alignment.center,
              child: new Icon(iconData, color: white, size: 20.0),
            ),
            new Text(title, style: profile),
            new Expanded(child: new Container()),
            new IconButton(icon: goTo, onPressed: null)
          ],
        ),
      ),
      onTap: action,
    );
  }

  Widget _buildAvatar() {
    return new Container(
      margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: new Row(
        children: <Widget>[
          new GestureDetector(
            //onTap: isLoggedIn == true ? setProfilePicture : null,
            child: new Container(
              width: 70.0,
              height: 70.0,
              margin: new EdgeInsets.only(left: 10.0),
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
                    color: black,
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
              new Text(fullName != null ? fullName : "Your Name",
                  style: avatar),
              new Text(email != null ? email : "Your Email", style: avatarTxt),
              new Text(phone != null ? phone : "Your Number", style: avatarTxt),
            ],
          ),
        ],
      ),
    );
  }

  Future _signOut() async {
    await auth.signOut();
    // googleSignIn.signOut();
    showSnackBar('User logged out', scaffoldKey);
    setState(() {
      _isSignedIn = false;
      fullName = null;
      email = null;
      phone = null;
      profileImgUrl = null;
    });
  }
}
