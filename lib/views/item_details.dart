import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/views/shared/icons.dart';

import '../main.dart';
import 'shared/app_colors.dart';
import 'shared/styles.dart';

class ItemDetail extends StatefulWidget {
  String itemName, itemImage, itemSubName;
  String itemDesc, itemRating;
  int itemPrice;
  List itemImages, itemColors, itemSizes;
  bool isInFavorite;

  ItemDetail({
    this.itemName,
    this.itemImage,
    this.itemSubName,
    this.itemDesc,
    this.itemPrice,
    this.itemImages,
    this.itemRating,
    this.itemSizes,
    this.itemColors,
    this.isInFavorite,
    //todo add is in cart
  });

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<String>> _dropDownColors;
  String _selectedColor;

  List<DropdownMenuItem<String>> _dropDownSizes;
  String _selectedSize;

  List<String> sizesAvList = new List();
  List<String> colorsAvList = new List();

  int defaultQuantity = 1;
  int cartCount = 0;
  bool isFavorite;
  bool isInCart = false;
  String productName, itemPrice, productImage;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFavorite = widget.isInFavorite;
      productName = widget.itemName;
      itemPrice = '${widget.itemPrice}';
      productImage = widget.itemImage;
    });
    colorsAvList = new List.from(widget.itemColors);
    sizesAvList = new List.from(widget.itemSizes);

    _dropDownColors = buildAndGetDropDownColor(colorsAvList);
    _selectedColor = _dropDownColors[0].value;

    _dropDownSizes = buildAndGetDropDownSizes(sizesAvList);
    _selectedSize = _dropDownSizes[0].value;
  }

  void changedDropDownColors(String selectedColors) {
    setState(() {
      _selectedColor = selectedColors;
    });
  }

  void changedDropDownSize(String selectedSize) {
    setState(() {
      _selectedSize = selectedSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.itemName),
        centerTitle: false,
        iconTheme: IconThemeData(color: white),
        automaticallyImplyLeading: true,
        actions: [
          new IconButton(
            icon: cart,
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ],
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new ListView(
          children: [
            const Padding(padding: const EdgeInsets.only(top: 12.0)),
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  new GestureDetector(
                    child: new Hero(
                      tag: widget.itemName,
                      child: new Container(
                        height: 128.0,
                        width: 128.0,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(widget.itemImage),
                          ),
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      new PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return new Material(
                            color: black,
                            child: new Container(
                              padding: const EdgeInsets.all(30.0),
                              child: new GestureDetector(
                                child: new Hero(
                                  tag: widget.itemName,
                                  child: new Image.network(
                                    widget.itemImage,
                                    width: 300.0,
                                    height: 300.0,
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Padding(padding: const EdgeInsets.only(left: 18.0)),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new Text(widget.itemName, style: itemTxt),
                        const Padding(padding: const EdgeInsets.only(top: 6.0)),
                        new Text(
                          "\$${widget.itemPrice.toString()}",
                          style: itemTxt,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(left: 10.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 2.0),
                    child: new Row(
                      children: [
                        Text('SIZES AVAILABLE', style: sTxt),
                        new Container(
                          margin: new EdgeInsets.only(left: 60.0),
                          child: new DropdownButton(
                            value: _selectedSize,
                            items: _dropDownSizes,
                            onChanged: changedDropDownSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 2.0),
                    child: new Row(
                      children: <Widget>[
                        Text('COLORS AVAILABLE', style: sTxt),
                        new Container(
                          margin: new EdgeInsets.only(left: 50.0),
                          child: new DropdownButton(
                            value: _selectedColor,
                            items: _dropDownColors,
                            onChanged: changedDropDownColors,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 2.0),
                    child: new Row(
                      children: <Widget>[
                        Text('SET QUANTITY', style: sTxt),
                        new Padding(padding: new EdgeInsets.only(left: 60.0)),
                        new CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: minus,
                          onPressed: () => setState(() {
                            if (defaultQuantity == 1) return;
                            defaultQuantity--;
                          }),
                        ),
                        new Text(defaultQuantity.toString(), style: itemQty),
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
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: new Container(
        height: 50.0,
        decoration: new BoxDecoration(color: primaryColor),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            isFavorite == true
                ? new GestureDetector(
                    child: Container(
                      width: screenSize.width * 0.5,
                      height: 50.0,
                      color: white,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: favorite,
                          ),
                          new Text('REMOVE FAVORITE', style: itemFav),
                        ],
                      ),
                    ),
                    onTap: () {
                      String favNeg = "Removed $productName from favorites";
                      fb
                          .collection('appProducts')
                          // .document(document.documentID)
                          .document()
                          .delete();
                      showSnackBar(favNeg, scaffoldKey);
                      isFavorite = false;
                      setState(() {});
                    },
                  )
                : new GestureDetector(
                    child: Container(
                      width: screenSize.width * 0.5,
                      height: 50.0,
                      color: white,
                      child: Row(
                        children: [
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: addToFav,
                          ),
                          new Text("ADD TO FAVORITES", style: itemFav),
                        ],
                      ),
                    ),
                    onTap: () {
                      String favAdd = 'Added $productName to favorites';
                      bool fav = true;
                      isFavorite = fav;
                      // firestore.collection('favorites').document(userID).setData({
                      //todo update per user
                      fb.collection('favorites').add({
                        'isFavorite': fav,
                        'product': productName,
                        'price': itemPrice,
                        'image': productImage,
                        // 'quantity': defaultQuantity,
                        // 'isFavorite': isFavorite,
                      });
                      // }).then((value) => showSnackBar('Added $productName to favorites', scaffoldKey));
                      showSnackBar(favAdd, scaffoldKey);
                      setState(() {});
                    },
                  ),
            isInCart == true
                ? new GestureDetector(
                    child: new Container(
                      width: screenSize.width * 0.40,
                      height: 50.0,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: removeCart,
                          ),
                          new Text("REMOVE CART", style: itemCart),
                        ],
                      ),
                    ),
                    onTap: () {
                      String cartNeg = "Removed $productName from your cart";
                      fb
                          .collection('appProducts')
                          // .document(document.documentID)
                          .document()
                          .delete();
                      showSnackBar(cartNeg, scaffoldKey);
                      isInCart = false;
                      setState(() {});
                    },
                  )
                : new GestureDetector(
                    onTap: () {
                      String cartAdd = "Added $productName to your cart";
                      bool fav = true;
                      isInCart = fav;
                      // firestore.collection('favorites').document(userID).setData({
                      fb.collection('cart').add({
                        'isFavorite': fav,
                        'product': productName,
                        'price': itemPrice,
                        'image': productImage,
                        'quantity': defaultQuantity,
                        'color': _selectedColor,
                        'size': _selectedSize,
                        // 'isFavorite': isFavorite,
                      });
                      //todo upon successful addition invoke the checkout page
                      showSnackBar(cartAdd, scaffoldKey);
                      setState(() {});
                    },
                    child: new Container(
                      width: screenSize.width * 0.40,
                      height: 50.0,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: addToShop,
                          ),
                          new Text("ADD TO CART", style: itemCart),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
