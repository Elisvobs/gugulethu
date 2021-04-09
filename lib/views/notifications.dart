import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';

import '../main.dart';
import 'shared/app_colors.dart';
import 'shared/styles.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  BuildContext context;

  String noOrder = "You have no order request....";

  // TimeAgo timeAgo = new TimeAgo();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var streamBuilder = new StreamBuilder(
      stream: fb.collection(appProducts).snapshots(),
      builder: (context, snapshot) {
        final dataCount = snapshot.data.documents.length;
        if (snapshot.hasData) {
          final firstList = new Flexible(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: dataCount,
              itemBuilder: (context, index) {
                final DocumentSnapshot document =
                    snapshot.data.documents[index];
                List productImage = document[productImages] as List;
                final row = new GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: new SafeArea(
                    top: false,
                    bottom: false,
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                      child: new Row(
                        children: <Widget>[
                          new GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new Material(
                                      color: black,
                                      child: new Container(
                                        padding: const EdgeInsets.all(30.0),
                                        child: new GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: new Hero(
                                            child: new Image.network(
                                              productImage[0],
                                              width: 300.0,
                                              height: 300.0,
                                              alignment: Alignment.center,
                                              fit: BoxFit.contain,
                                            ),
                                            tag: '${document[productTitle]}',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: new Hero(
                              tag: '${document[productTitle]}',
                              child: new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new NetworkImage(productImage[0]),
                                  ),
                                  borderRadius: new BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          new Expanded(
                            child: new Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //TODO get username to display
                                  new Text(''),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  //TODO get the time the order was requested to display
                                  new Text('', style: notify),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                      "Order Amount : \$${document[productPrice]}",
                                      style: itemFav),
                                  const Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                  ),
                                  new Text("No of Items : $dataCount",
                                      style: notify),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                return new Container(
                  margin: new EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 2.0),
                  color: white,
                  child: new Column(
                    children: <Widget>[
                      row,
                      new Container(height: 1.0, color: black.withAlpha(10)),
                    ],
                  ),
                );
              },
            ),
          );
          if (dataCount == null) {
            return new Container(
              constraints: const BoxConstraints(maxHeight: 500.0),
              child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(top: 00.0, bottom: 0.0),
                      height: 150.0,
                      width: 150.0,
                      child: new Image.asset('assets/images/empty.png'),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Text(noOrder, style: noNotify),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return new Column(
              children: [firstList],
            );
          }
        } else if (!snapshot.hasData) {
          return new Container(
            constraints: const BoxConstraints(maxHeight: 500.0),
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.only(top: 00.0, bottom: 0.0),
                    height: 150.0,
                    width: 150.0,
                    child: new Image.asset('assets/images/no_access.png'),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Text("No internet access..", style: noNotify),
                  ),
                ],
              ),
            ),
          );
        } else {
          return new Center(
            child: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
        }
      },
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Order Notifications"),
        centerTitle: false,
      ),
      body: streamBuilder,
    );
  }
}
