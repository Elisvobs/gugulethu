import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/main.dart';
import 'package:onlineshop/tools/app_data.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    context = context;
    final Size screenSize = MediaQuery.of(context).size;
    var streamBuilder = new StreamBuilder(
      stream: fb.collection(appProducts).snapshots(),
      builder: (context, snapshot) {
        final historyCount = snapshot.data.documents.length;
        if (snapshot.hasData) {
          final firstList = new SizedBox(
            height: screenSize.height - 169,
            child: new ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: historyCount,
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
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                      child: new Row(
                        children: <Widget>[
                          new GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new Material(
                                      color: Colors.black38,
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
                                            tag: "${document[productTitle]}",
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: new Hero(
                              tag: "${document[productTitle]}",
                              child: new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new NetworkImage(productImage[0])),
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
                                  new Text('${document[productTitle]}'),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    "\$${document[productPrice]}",
                                    style: const TextStyle(
                                      color: const Color(0xFF8E8E93),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: new Icon(
                              CupertinoIcons.minus_circled,
                              color: Theme.of(context).primaryColor,
                              semanticLabel: 'Substract',
                            ),
                            onPressed: () {},
                          ),
                          new Text(
                            '1',
                            style: const TextStyle(
                              color: const Color(0xFF8E8E93),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          new CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: new Icon(
                              CupertinoIcons.plus_circled,
                              color: Theme.of(context).primaryColor,
                              semanticLabel: 'Add',
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                return new Container(
                  margin:
                      new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      row,
                      new Container(
                          height: 1.0, color: Colors.black12.withAlpha(10)),
                    ],
                  ),
                );
              },
            ),
          );

          if (historyCount == null) {
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
                      child: new Text(
                        "You have no order history...",
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return firstList;
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Order History"),
        centerTitle: false,
      ),
      body: streamBuilder,
    );
  }
}
