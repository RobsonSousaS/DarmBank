import 'package:flutter/material.dart';
import 'dart:io';

class UserModel {
  final File? pickedImage;

  UserModel({
    this.pickedImage,
  });
}

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel();

  UserModel get user => _user;

  void updatePickedImage(File? image) {
    _user = UserModel(pickedImage: image);
    notifyListeners();
  }
}
