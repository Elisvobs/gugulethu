import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'app_data.dart';
import 'app_methods.dart';
import 'app_tools.dart';

class FirebaseMethods implements AppMethods {
  Firestore firestore = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<String> createUserAccount(
      {String fullName, String phone, String email, String password}) async {
    FirebaseUser user;

    try {
      user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (user != null) {
        await firestore.collection(userData).document(user.uid).setData({
          userID: user.uid,
          accountName: fullName,
          userEmail: email,
          userPassword: password,
          phoneNumber: phone
        });

        writeDataLocally(key: userID, value: user.uid);
        writeDataLocally(key: accountName, value: fullName);
        writeDataLocally(key: phoneNumber, value: phone);
        writeDataLocally(key: userEmail, value: email);
        writeDataLocally(key: userPassword, value: password);
      }
    } on PlatformException catch (e) {
      print(e.details);
      return errorMSG(e.details);
    }

    return user == null ? errorMSG("Error") : successfulMSG();
  }

  @override
  Future<String> loginUser({String email, String password}) async {
    FirebaseUser user;
    try {
      user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (user != null) {
        DocumentSnapshot userInfo = await getUserInfo(user.uid);
        await writeDataLocally(key: userID, value: userInfo[userID]);
        await writeDataLocally(key: accountName, value: userInfo[accountName]);
        await writeDataLocally(key: userEmail, value: userInfo[userEmail]);
        await writeDataLocally(key: phoneNumber, value: userInfo[phoneNumber]);
        await writeDataLocally(key: photoUrl, value: userInfo[photoUrl]);
        await writeBoolDataLocally(key: loggedIn, value: true);

        print(userInfo[userEmail]);
      }
    } on PlatformException catch (e) {
      print(e.details);
      return errorMSG(e.details);
    }

//   showSnackBar(message, scaffoldKey);
    return user == null ? errorMSG("Error") : successfulMSG();
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }

  Future<String> successfulMSG() async {
    return successful;
  }

  Future<String> errorMSG(String e) async {
    return e;
  }

  @override
  Future<bool> logOutUser() async {
    await auth.signOut();
    await clearDataLocally();

    return complete();
  }

  @override
  Future<DocumentSnapshot> getUserInfo(String userId) async {
    return await firestore.collection(userData).document(userId).get();
  }

  @override
  Future<String> addNewProduct({Map newProduct}) async {
    String documentId;
    try {
      await firestore
          .collection(appProducts)
          .add(newProduct)
          .then((documentRef) {
        documentId = documentRef.documentID;
      });
    } on PlatformException catch (e) {
      print(e.details);
    }
    return documentId;
  }

  @override
  Future<List<String>> setProductImages(
      {List<File> imageList, String docID}) async {
    List<String> imagesUrl = new List();

    try {
      for (int s = 0; s < imageList.length; s++) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child(appProducts)
            .child(docID)
            .child(docID + "$s.jpg");
        StorageUploadTask uploadTask = storageReference.putFile(imageList[s]);

        String downloadUrl;
        await uploadTask.onComplete.then((val) {
          val.ref.getDownloadURL().then((val) {
            print(val);
            downloadUrl = val;
          });
        });

        imagesUrl.add(downloadUrl.toString());
      }
    } on PlatformException catch (e) {
      imagesUrl.add(error);
      print(e.details);
    }
    return imagesUrl;
  }

  @override
  Future<bool> updateProductImages({String docID, List<String> data}) async {
    bool msg;
    await firestore
        .collection(appProducts)
        .document(docID)
        .updateData({productImages: data}).whenComplete(() {
      msg = true;
    });
    return msg;
  }
}
