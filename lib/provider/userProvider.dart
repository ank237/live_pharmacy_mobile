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

  Future<void> verifyUser(String docID) async {
    toggleIsLoading();
    await _db.collection('users').doc(docID).update({
      'isVerified': true,
    });
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> rejectUser(String docID) async {
    toggleIsLoading();
    await _db.collection('users').doc(docID).delete();
    toggleIsLoading();
    notifyListeners();
  }

  Future<int> getTotalOrderDelivered() async {
    int ans = 0;
    var res = await _db.collection('users').doc(loggedInUser.docID).collection('deliveries').get();
    for (var d in res.docs) {
      if (d['delivered'] == true) {
        ans += 1;
      }
    }
    return ans;
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
        loggedInUser.isVerified = d['isVerified'];
        return true;
      }
    }
    return false;
  }

  Future<void> registerNewUser() async {
    toggleIsLoading();
    loggedInUser = newUser;
    bool result = await checkUser();
    print(result);
    if (result == false) {
      var res = await _db.collection('users').add({
        'name': newUser.name,
        'phone': newUser.phone,
        'role': newUser.role,
        'isVerified': newUser.isVerified,
      });
      loggedInUser.docID = res.id;
    }
    toggleIsLoading();
    notifyListeners();
  }
}
