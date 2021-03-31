import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/main.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/userScreens/cart.dart';

class ItemDetail extends StatefulWidget {
  String itemName, itemImage, itemSubName;
  // String itemDesc, itemPrice, itemRating;
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
  });

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<DropdownMenuItem<String>> _dropDownColors;
  String _selectedColor;

  List<DropdownMenuItem<String>> _dropDownSizes;
  String _selectedSize;

  List<String> sizesAvList = new List();
  List<String> colorsAvList = new List();

  int defaultQuantity = 1;
  bool isFavorite;
  bool isInCart = false;
  String productName, itemPrice, productImage;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFavorite = widget.isInFavorite;
      productName = widget.itemName;
      itemPrice = widget.itemPrice as String;
      productImage = widget.itemImage;
    });
    colorsAvList = new List.from(widget.itemColors);
    sizesAvList = new List.from(widget.itemSizes);

    _dropDownColors = buildAndGetDropDownQuantity(colorsAvList);
    _selectedColor = _dropDownColors[0].value;

    _dropDownSizes = buildAndGetDropDownSizes(sizesAvList);
    _selectedSize = _dropDownSizes[0].value;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownQuantity(List quantity) {
    List<DropdownMenuItem<String>> items = new List();
    for (String quantity in quantity) {
      items.add(
          new DropdownMenuItem(value: quantity, child: new Text(quantity)));
    }
    return items;
  }

  void changedDropDownColors(String selectedColors) {
    setState(() {
      _selectedColor = selectedColors;
    });
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownSizes(List size) {
    List<DropdownMenuItem<String>> items = new List();
    for (String size in size) {
      items.add(new DropdownMenuItem(value: size, child: new Text(size)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownKitchen(List size) {
    List<DropdownMenuItem<String>> items = new List();
    for (String size in size) {
      items.add(new DropdownMenuItem(value: size, child: new Text(size)));
    }
    return items;
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
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        actions: [
          new IconButton(
            icon: new Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.of(context).push(
              new CupertinoPageRoute(
                builder: (BuildContext context) => new Cart(),
              ),
            ),
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
                      );
                    },
                  ),
                  const Padding(padding: const EdgeInsets.only(left: 18.0)),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new Text(
                          widget.itemName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: const EdgeInsets.only(top: 6.0)),
                        new Text(
                          "\$" + widget.itemPrice.toString(),
                          style: const TextStyle(
                            color: const Color(0xFF8E8E93),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                          ),
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
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 0.0, bottom: 2.0),
                    child: new Row(
                      children: [
                        const Text(
                          'SIZES AVAILABLE',
                          style: const TextStyle(
                            color: const Color(0xFF646464),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
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
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 2.0),
                    child: new Row(
                      children: <Widget>[
                        const Text(
                          'COLORS AVAILABLE',
                          style: const TextStyle(
                            color: const Color(0xFF646464),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
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
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 5.0, bottom: 2.0),
                    child: new Row(
                      children: <Widget>[
                        const Text(
                          'SET QUANTITY',
                          style: const TextStyle(
                            color: const Color(0xFF646464),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(left: 60.0)),
                        new CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: new Icon(
                            CupertinoIcons.minus_circled,
                            color: Colors.black,
                            semanticLabel: 'Substract',
                          ),
                          onPressed: () => setState(() {
                            if (defaultQuantity == 1) return;
                            defaultQuantity--;
                          }),
                        ),
                        new Text(
                          defaultQuantity.toString(),
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
                            color: Colors.black,
                            semanticLabel: 'Add',
                          ),
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
        decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            isFavorite == true
                ? new GestureDetector(
                    child: Container(
                      width: screenSize.width * 0.5,
                      height: 50.0,
                      color: Colors.white,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                          new Text(
                            'REMOVE FAVORITE',
                            style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      showSnackBar(
                          "Removed $productName from favorites", scaffoldKey);
                      isFavorite = false;
                      setState(() {});
                    },
                  )
                : new GestureDetector(
                    child: Container(
                      width: screenSize.width * 0.5,
                      height: 50.0,
                      color: Colors.white,
                      child: Row(
                        children: [
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new Icon(Icons.favorite_border,
                                color: Colors.blue, size: 20.0),
                          ),
                          new Text(
                            "ADD TO FAVORITES",
                            // textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      bool fav = true;
                      isFavorite = fav;
                      // firestore.collection('favorites').document(userID).setData({
                      fb.collection('favorites').add({
                        'isFavorite': fav,
                        'product': productName,
                        'price': itemPrice,
                        'image': productImage,
                        // 'quantity': defaultQuantity,
                        // 'isFavorite': isFavorite,
                      });
                      showSnackBar(
                          'Added $productName to favorites', scaffoldKey);
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
                            child: new Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                          new Text(
                            "REMOVE CART",
                            style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      // widget.fbConn.removeFromCart(widget.index);
                      // TODO add firebase item deletion
                      showSnackBar(
                          "Removed $productName from your cart", scaffoldKey);
                      isInCart = false;
                      setState(() {});
                    },
                  )
                : new GestureDetector(
                    onTap: () {
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
                      showSnackBar(
                          " Added $productName to your cart", scaffoldKey);
                      setState(() {});
                    },
                    child: new Container(
                      width: screenSize.width * 0.40,
                      height: 50.0,
                      //color: Colors.white,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                          new Text(
                            "ADD TO CART",
                            style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
