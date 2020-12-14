import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_pharmacy/models/notesModel.dart';

class NotesProvider extends ChangeNotifier {
  List<NotesModel> notesList = [];
  bool isLoading = false;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  void toggleIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> fetchNotes() async {
    toggleIsLoading();
    notesList.clear();
    var res = await _db.collection('notes').get();
    for (var d in res.docs) {
      notesList.add(NotesModel(
        note: d['note'],
        docId: d.id,
        date: d['date'].toDate(),
        reminder: d['reminder'].toDate(),
      ));
    }
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> addNote(String note) async {
    toggleIsLoading();
    await _db.collection('notes').add({
      'note': note,
      'date': DateTime.now(),
      'reminder': DateTime.now().add(
        Duration(days: 365),
      ),
    });
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> deleteNote(String noteID) async {
    toggleIsLoading();
    await _db.collection('notes').doc(noteID).delete();
    toggleIsLoading();
    notifyListeners();
  }

  Future<void> setReminder(String noteID, DateTime reminder) async {
    toggleIsLoading();
    await _db.collection('notes').doc(noteID).update({
      'reminder': reminder,
    });
    toggleIsLoading();
    notifyListeners();
  }
}
