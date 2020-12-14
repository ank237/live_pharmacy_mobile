import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/models/userModel.dart';

class UserProvider extends ChangeNotifier {
  String selectedRole = '';
  FirebaseFirestore _db = FirebaseFirestore.instance;
  UserModel newUser = UserModel(name: '', phone: '', role: '', isVerified: false, docID: '');
  bool isSaving = false;
  UserModel loggedInUser = UserModel(name: '', phone: '', role: '', isVerified: false, docID: '');

  void toggleIsLoading() {
    isSaving = !isSaving;
    notifyListeners();
  }

  Future<void> getCurrentUser(String num) async {
    var res = await _db.collection('users').get();
    for (var d in res.docs) {
      if (num == d['phone']) {
        loggedInUser = UserModel(
          name: d['name'],
          phone: d['phone'],
          isVerified: d['isVerified'],
          docID: d.id,
          role: d['role'],
        );
      }
    }
    notifyListeners();
  }

  Future<bool> checkUser() async {
    var res = await _db.collection('users').get();
    for (var d in res.docs) {
      if (newUser.phone == d['phone']) {
        return true;
      }
    }
    return false;
  }

  Future<void> registerNewUser() async {
    toggleIsLoading();
    bool result = await checkUser();
    print(result);
    loggedInUser = newUser;
    if (result == false) {
      await _db.collection('users').add({
        'name': newUser.name,
        'phone': newUser.phone,
        'role': newUser.role,
        'isVerified': newUser.isVerified,
      });
    }
    toggleIsLoading();
    notifyListeners();
  }
}
