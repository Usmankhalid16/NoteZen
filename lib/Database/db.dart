import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Screens/Sticky Notes/sticky_notes_page.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, 'sticky_notes.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE sticky_notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            text TEXT,
            color INTEGER
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getStickyNotes() async {
    await initializeDatabase();
    return await _database.query('sticky_notes');
  }

  Future<void> insertStickyNote(StickyNote note) async {
    await initializeDatabase();
    await _database.insert('sticky_notes', note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateStickyNote(Map<String, dynamic> note) async {
    await initializeDatabase();
    await _database.update(
      'sticky_notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
  }

  Future<void> deleteStickyNote(int id) async {
    await initializeDatabase();
    await _database.delete(
      'sticky_notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
