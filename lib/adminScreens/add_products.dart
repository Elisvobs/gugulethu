import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_methods.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/firebase_methods.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  List<DropdownMenuItem> dropDownCategories;
  String selectedCategory;
  List<String> categoryList = new List();

  List<DropdownMenuItem> dropDownColors;
  String selectedColor;
  List<String> colorList = new List();

  List<DropdownMenuItem> dropDownSizes;
  String selectedSize;
  List<String> sizeList = new List();

  TextEditingController productTitle = new TextEditingController();
  TextEditingController productPrice = new TextEditingController();
  TextEditingController productDescription = new TextEditingController();

  Map<int, File> imagesMap = new Map();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    categoryList = new List.from(localCategories);
    dropDownCategories = buildAndGetDropDownItems(categoryList);
    selectedCategory = dropDownCategories[0].value;

    colorList = new List.from(localColors);
    dropDownColors = buildAndGetDropDownItems(colorList);
    selectedColor = dropDownColors[0].value;

    sizeList = new List.from(localSizes);
    dropDownSizes = buildAndGetDropDownItems(sizeList);
    selectedSize = dropDownSizes[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("Add Products"),
        centerTitle: false,
//        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new RaisedButton.icon(
              color: Colors.green,
              shape: new RoundedRectangleBorder(
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(15.0))),
              onPressed: () => pickImage(),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: new Text(
                "Add Images",
                style: new TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: new SingleChildScrollView(
          child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            height: 10.0,
          ),
          multiImagePickerList(
              imageList: imageList,
              removeNewImage: (index) {
                return removeImage(index);
              }),
          new SizedBox(
            height: 10.0,
          ),
          productTextField(
              textTitle: "Product Title",
              textHint: "Enter Product Title",
              controller: productTitle),
          new SizedBox(
            height: 10.0,
          ),
          productTextField(
              textTitle: "Product Price",
              textHint: "Enter Product Price",
              controller: productPrice),
          new SizedBox(
            height: 10.0,
          ),
          productTextField(
              textTitle: "Product Description",
              textHint: "Enter Product Description",
              controller: productDescription,
              maxLines: 4,
              height: 160.0),
          new SizedBox(
            height: 10.0,
          ),
          productDropDown(
            textTitle: "Product Category",
            selectedItem: selectedCategory,
            dropDownItems: dropDownCategories,
            changedDropDownItems: changedDropDownCategory,
          ),
          new SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              productDropDown(
                textTitle: "Color",
                selectedItem: selectedColor,
                dropDownItems: dropDownColors,
                changedDropDownItems: changedDropDownColor,
              ),
              productDropDown(
                textTitle: "Size",
                selectedItem: selectedSize,
                dropDownItems: dropDownSizes,
                changedDropDownItems: changedDropDownSize,
              ),
            ],
          ),
          new SizedBox(
            height: 20.0,
          ),
          appButton(
            btnText: "Add Product",
            onBtnClicked: () => addNewProducts(),
            btnPadding: 20.0,
            btnColor: Theme.of(context).primaryColor,
          ),
        ],
      )),
    );
  }

  List<File> imageList;

  pickImage() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      List<File> imageFile = new List();
      imageFile.add(file);

      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
      } else {
        for (int s = 5; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
      setState(() {});
    }
  }

  removeImage(int index) async {
    imageList.removeAt(index);
    setState(() {});
  }

  AppMethods appMethod = new FirebaseMethods();

  addNewProducts() async {
    if (imageList == null || imageList.isEmpty) {
      showSnackBar("Please add Product Images!!!", scaffoldKey);
      return;
    }

    if (productTitle.text == "") {
      showSnackBar("Product Title cannot be empty!!!", scaffoldKey);
      return;
    }

    if (productPrice.text == "") {
      showSnackBar("Product Price cannot be empty!!!", scaffoldKey);
      return;
    }

    if (productDescription.text == "") {
      showSnackBar("Product Description cannot be empty!!!", scaffoldKey);
      return;
    }

    if (selectedCategory == "Select Product Category") {
      showSnackBar("Please select a category!!!", scaffoldKey);
      return;
    }

    if (selectedColor == "Select a color") {
      showSnackBar("Please select a color!!!", scaffoldKey);
      return;
    }

    if (selectedSize == "Select a size") {
      showSnackBar("Please select a size!!!", scaffoldKey);
      return;
    }

    displayProgressDialog(context);

    Map newProduct = {
      productTitle: productTitle.text,
      productPrice: productPrice.text,
      productDescription: productDescription.text,
      productCategory: selectedCategory,
      productColor: selectedColor,
      productSize: selectedSize,
    };

    String productID = await appMethod.addNewProduct(newProduct: newProduct);

    List<String> imagesUrl = await appMethod.setProductImages(
        docID: productID, imageList: imageList);

    if (imagesUrl.contains(error)) {
      closeProgressDialog(context);
      showSnackBar("Image Upload Error, Contact Developer", scaffoldKey);
      return;
    }
    bool result =
        await appMethod.updateProductImages(docID: productID, data: imagesUrl);

    if (result != null && result == true) {
      closeProgressDialog(context);
      resetEverything();
      showSnackBar("Product successfully added!", scaffoldKey);
    } else {
      closeProgressDialog(context);
      showSnackBar("An Error Occured, Contact Developer", scaffoldKey);
    }
  }

  void resetEverything() {
    imageList.clear();
    productTitle.clear();
    productPrice.clear();
    productDescription.clear();
    selectedCategory = "Select Product Category";
    selectedColor = "Select a color";
    selectedSize = "Select a size";
    setState(() {});
  }

  void changedDropDownCategory(String selected) {
    setState(() {
      selectedCategory = selected;
      // print(selectedCategory);
    });
  }

  void changedDropDownColor(String selected) {
    setState(() {
      selectedColor = selected;
      // print(selectedColor);
    });
  }

  void changedDropDownSize(String selected) {
    setState(() {
      selectedSize = selected;
      // print(selectedSize);
    });
  }
}
