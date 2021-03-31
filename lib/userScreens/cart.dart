import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/main.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_tools.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  BuildContext context;
  var refreshMenuKey = GlobalKey<RefreshIndicatorState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isInCart;
  bool isFavorite;

  @override
  void initState() {
    super.initState();
  }

  double getTotalProductPrice() {
    Map objectData = new Map();
    double value = 0.0;
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      int quantity = num.parse(val['itemQuantity'].toString());
      value = value + (double.parse(val[productPrice]) * quantity);
    }
    return value.roundToDouble();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;

    var streamBuilder = new StreamBuilder(
      stream: fb.collection('appProducts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Center(
            child: new CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        } else {
          final int cartCount = snapshot.data.documents.length;
          if (cartCount == 0) {
            return emptyCart();
          } else {
            return new Column(
              children: [
                new Flexible(
                  child: new ListView.builder(
                    itemCount: cartCount,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot document =
                          snapshot.data.documents[index];
                      List productImage = document[productImages] as List;

                      final buttons = new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //remove favorites
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new GestureDetector(
                              onTap: () {
                                //TODO remove item from the cart collection
                                showSnackBar(
                                    "Removed ${document[productTitle]} from your cart",
                                    scaffoldKey);
                                isInCart = false;
                                setState(() {});
                              },
                              child: new Container(
                                width: 100.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0),
                                  ),
                                ),
                                child: new Center(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: new Icon(
                                          Icons.remove_shopping_cart,
                                          size: 18.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      new Text(
                                        "REMOVE",
                                        style: new TextStyle(
                                          color: Colors.blue,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new Container(
                            height: 30.0,
                            width: 1.0,
                            color: Colors.black12,
                            margin:
                                const EdgeInsets.only(left: 4.0, right: 4.0),
                          ),
                          //add to favorites
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new GestureDetector(
                              onTap: () {
                                //TODO add to favorites collection
                                bool fav = true;
                                isFavorite = fav;
                                // firestore.collection('favorites').document(userID).setData({
                                // fb.collection('favorites').add({
                                //   'isFavorite': fav,
                                //   'product': productName,
                                //   'price': itemPrice,
                                //   'image': productImage,
                                //   // 'quantity': defaultQuantity,
                                //   // 'isFavorite': isFavorite,
                                // });
                                showSnackBar(
                                    'Added ${document[productTitle]} to favorites',
                                    scaffoldKey);
                                setState(() {});
                              },
                              child: new Container(
                                width: 140.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(5.0))),
                                child: new Center(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: new Icon(
                                          Icons.favorite_border,
                                          size: 18.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      new Text(
                                        "ADD TO FAVORITES",
                                        style: new TextStyle(
                                          color: Colors.blue,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );

                      final row = new GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: new SafeArea(
                          top: false,
                          bottom: false,
                          child: new Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, top: 8.0, bottom: 8.0, right: 4.0),
                            child: new Row(
                              children: <Widget>[
                                //product image
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      new PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder:
                                            (BuildContext context, _, __) {
                                          return new Material(
                                            color: Colors.black38,
                                            child: new Container(
                                              padding:
                                                  const EdgeInsets.all(24.0),
                                              child: new GestureDetector(
                                                onTap: () =>
                                                    Navigator.pop(context),
                                                child: new Hero(
                                                  child: new Image.network(
                                                    productImage[0],
                                                    width: 300.0,
                                                    height: 300.0,
                                                    alignment: Alignment.center,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  tag:
                                                      '${document[productTitle]}',
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
                                          image: new NetworkImage(
                                            productImage[0],
                                          ),
                                        ),
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                                new Expanded(
                                  child: new Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text("${document[productTitle]}"),
                                        const Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0)),
                                        new Text(
                                          "\$${document[productPrice]}",
                                          style: const TextStyle(
                                            color: const Color(0xFF8E8E93),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
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
                                    color: Colors.blue,
                                    semanticLabel: 'Subtract',
                                  ),
                                  onPressed: () {
                                    //TODO replace with function reduce quantity by 1
                                  },
                                ),
                                new Text(
                                  "1",
                                  //TODO replace with '${document[quantity]}' after referencing the cartDB
                                  style: const TextStyle(
                                    color: const Color(0xFF8E8E93),
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                new CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: new Icon(
                                    CupertinoIcons.plus_circled,
                                    color: Colors.blue,
                                    semanticLabel: 'Add',
                                  ),
                                  onPressed: () {
                                    //TODO add the function to increment quantity by 1
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      return new Container(
                        margin: new EdgeInsets.only(
                            left: 4.0, right: 4.0, bottom: 2.0),
                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[
                            // buttons,
                            // new Container(height: 1.0, color: Colors.blue),
                            // row,
                            row,
                            new Container(height: 1.0, color: Colors.blue),
                            buttons,
                          ],
                        ),
                      );
                    },
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Container(
                    margin:
                        new EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(
                          "ITEMS (${cartCount == 0 ? '0' : cartCount.toString()})",
                          style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        new Text(
                          //TODO replace with  a function  to add item totals when firebase values are changed to ints or doubles

                          "TOTAL ",
                          style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Container(
                  height: 50.0,
                  color: Colors.white,
                  child: new Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   new CupertinoPageRoute(
                        //     builder: (BuildContext context) => new OrderSummary(
                        //       cartTotal: getTotalProductPrice().toString(),
                        //       totalItems: getDataSize().toString(),
                        //     ),
                        //   ),
                        // );
                      },
                      child: new Container(
                        width: screenSize.width,
                        margin: new EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 2.0),
                        height: 50.0,
                        decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(5.0))),
                        child: new Center(
                          child: new Text(
                            "PROCEED TO PAYMENT",
                            style: new TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }
      },
    );

    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "My Cart",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: streamBuilder,
    );
  }

  Widget emptyCart() {
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
              child: new Image.asset('assets/images/cart_empty.png'),
            ),
            new Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Text(
                "You have no item in your cart....",
                style: new TextStyle(fontSize: 14.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
