import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/views/shared/icons.dart';

import '../main.dart';
import 'check_out.dart';
import 'shared/app_colors.dart';
import 'shared/styles.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isInCart, isFavorite;
  int defaultQuantity = 1;
  int cartCount;

  @override
  void initState() {
    super.initState();
  }

  double getTotalPrice() {
    Map objectData = new Map();
    double value = 0.0;
    for (int s = 0; s < objectData.keys.length; s++) {
      //todo replace the Map val with DocumentSnapshot document
      // & next function with num.parse(document[itemQuantity])
      Map val = objectData[objectData.keys.elementAt(s)];
      defaultQuantity = num.parse(val[defaultQuantity].toString());
      //todo replace val[productPrice] with document[productPrice]
      value = value + (double.parse(val[productPrice]) * defaultQuantity);
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
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        } else {
          cartCount = snapshot.data.documents.length;
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
                      String addFav =
                          'Added ${document[productTitle]} to favorites';
                      String minusFav =
                          'Removed ${document[productTitle]} from favorites';
                      String minusCart =
                          'Removed ${document[productTitle]} from cart';
                      List productImage = document[productImages] as List;

                      final buttons = new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new GestureDetector(
                              onTap: () => showRemoveDialog(context, document),
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
                                        child: removeCart,
                                      ),
                                      new Text("REMOVE", style: cartTxt),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new Container(
                            height: 30.0,
                            width: 1.0,
                            color: black,
                            margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                          ),
                          //add to favorites
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: isFavorite == true
                                ? new GestureDetector(
                                    onTap: () {
                                      fb
                                          .collection('appProducts')
                                          // .document(document.documentID)
                                          .document()
                                          .delete();
                                      showSnackBar(minusFav, scaffoldKey);
                                      isFavorite = false;
                                      setState(() {});
                                    },
                                    child: new Container(
                                      width: 140.0,
                                      height: 40.0,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(5.0)),
                                      ),
                                      child: new Center(
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: addToFav,
                                            ),
                                            new Text("REMOVE FAVORITE",
                                                style: cartTxt),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : new GestureDetector(
                                    onTap: () {
                                      bool fav = true;
                                      isFavorite = fav;
                                      // firestore.collection('favorites').document(userID).setData({
                                      fb.collection('favorites').add({
                                        'isFavorite': fav,
                                        'product': document[productTitle],
                                        'price': document[productPrice],
                                        'image': productImage,
                                        // 'quantity': document[quantity],
                                      });
                                      showSnackBar(addFav, scaffoldKey);
                                      setState(() {});
                                    },
                                    child: new Container(
                                      width: 140.0,
                                      height: 40.0,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(5.0)),
                                      ),
                                      child: new Center(
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: addToFav,
                                            ),
                                            new Text("ADD TO FAVORITES",
                                                style: cartTxt),
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
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 8.0, 4.0, 8.0),
                            child: new Row(
                              children: <Widget>[
                                //product image
                                new GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    new PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder:
                                          (BuildContext context, _, __) {
                                        return new Material(
                                          color: black,
                                          child: new Container(
                                            padding: const EdgeInsets.all(24.0),
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
                                  ),
                                  child: new Hero(
                                    tag: '${document[productTitle]}',
                                    child: new Container(
                                      height: 60.0,
                                      width: 60.0,
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image:
                                              new NetworkImage(productImage[0]),
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
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                        ),
                                        new Text("\$${document[productPrice]}",
                                            style: cartPrice),
                                      ],
                                    ),
                                  ),
                                ),
                                new CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: minus,
                                  onPressed: () => setState(() {
                                    if (defaultQuantity == 1) return;
                                    defaultQuantity--;
                                  }),
                                ),
                                new Text(
                                    //TODO replace with '${document[quantity]}' after referencing the cartDB
                                    // "${document[defaultQuantity.toString()]}",
                                    defaultQuantity.toString(),
                                    style: cartQty),
                                new CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: plus,
                                  onPressed: () => setState(() {
                                    defaultQuantity++;
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      return new Container(
                        margin: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 2.0),
                        color: white,
                        child: new Column(
                          children: <Widget>[
                            row,
                            new Container(height: 1.0, color: primaryColor),
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
                    margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                    child: new Row(
                      children: [
                        new Text(
                          "ITEMS (${cartCount == 0 ? '0' : cartCount.toString()})",
                          style: cartItem,
                        ),
                        Spacer(),
                        new Text("${getTotalPrice().toString()}",
                            style: cartItem),
                      ],
                    ),
                  ),
                ),
                new Container(
                  height: 50.0,
                  color: white,
                  child: new Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new GestureDetector(
                      onTap: () => showPaymentDialog(context),
                      child: new Container(
                        width: screenSize.width,
                        margin: new EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 2.0),
                        height: 50.0,
                        decoration: new BoxDecoration(
                          color: primaryColor,
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(5.0),
                          ),
                        ),
                        child: new Center(
                          child:
                              new Text("PROCEED TO PAYMENT", style: whiteTxt),
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
      backgroundColor: white,
      appBar: new AppBar(title: new Text("My Cart"), centerTitle: true),
      body: streamBuilder,
    );
  }

  showRemoveDialog(BuildContext context, DocumentSnapshot document) {
    String minusCart = 'Removed ${document[productTitle]} from your favorites';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${document[productTitle]} from cart?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              fb
                  .collection('appProducts')
                  // .document(document.documentID)
                  .document()
                  .delete();
              showSnackBar(minusCart, scaffoldKey);
              isInCart = false;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Proceed to Payment?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          FlatButton(
            child: Text("Yes"),
            //TODO get the prices and total items from the shop item to checkout
            onPressed: () {
              Navigator.of(context).push(
                new CupertinoPageRoute(
                  builder: (BuildContext context) => new CheckOut(
                    cartTotal: getTotalPrice().toString(),
                    totalItems: cartCount.toString(),
                  ),
                ),
              );
              Navigator.pop(context);
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
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
              child:
                  new Text("You have no item in your cart....", style: noCart),
            ),
          ],
        ),
      ),
    );
  }
}
