// lib/providers/note_provider.dart
import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../database/db_helper.dart';

class NoteProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Note> _notes = [];
  bool _loading = false;

  List<Note> get notes => _notes;
  bool get loading => _loading;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _loading = true;
    notifyListeners();

    _notes = await _db.getAllNotes();

    _loading = false;
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _db.createNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _db.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _db.deleteNote(id);
    await loadNotes();
  }
}
