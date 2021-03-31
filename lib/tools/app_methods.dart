import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppMethods {
  Future<String> loginUser({String email, String password});

  Future<String> createUserAccount(
      {String fullName, String phone, String email, String password});

  Future<bool> logOutUser();

  Future<DocumentSnapshot> getUserInfo(String userId);

  Future<String> addNewProduct({Map newProduct});

  Future<List<String>> setProductImages({List<File> imageList, String docID});

  Future<bool> updateProductImages({String docID, List<String> data});
}
