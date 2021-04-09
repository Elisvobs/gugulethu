import 'package:flutter/material.dart';
import 'package:onlineshop/views/shared/app_colors.dart';
import 'package:onlineshop/views/shared/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'progress_dialog.dart';

showSnackBar(String message, final scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(
    new SnackBar(
      backgroundColor: red,
      content: new Text(message, style: whiteTxt),
    ),
  );
}

//progress dialog handling
displayProgressDialog(BuildContext context) => Navigator.of(context).push(
      new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => new ProgressDialog(),
      ),
    );

closeProgressDialog(BuildContext context) => Navigator.of(context).pop();

//local data handling mechanisms
writeDataLocally({String key, String value}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.setString(key, value);
}

writeBoolDataLocally({String key, bool value}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.setBool(key, value);
}

getDataLocally({String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  return localData.get(key);
}

getStringDataLocally({String key, String value}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  return localData.getString(key);
}

getBoolDataLocally({String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  return localData.getBool(key) == null ? false : localData.getBool(key);
}

clearDataLocally() async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  localData.clear();
}

//dropdown menu items for quantity and size
List<DropdownMenuItem<String>> buildAndGetDropDownColor(List quantity) {
  List<DropdownMenuItem<String>> items = new List();
  for (String quantity in quantity) {
    items.add(new DropdownMenuItem(value: quantity, child: new Text(quantity)));
  }
  return items;
}

List<DropdownMenuItem<String>> buildAndGetDropDownSizes(List size) {
  List<DropdownMenuItem<String>> items = new List();
  for (String size in size) {
    items.add(new DropdownMenuItem(value: size, child: new Text(size)));
  }
  return items;
}
