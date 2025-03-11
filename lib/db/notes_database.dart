import 'package:note/model/noteModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = "INTERGER PRIMARY KEY AUTOINCREMENT";
    final textType = "TEXT NOT NULL";
    final boolType = "BOOLEAN NOT NULL";
    final integerType = "INTERGER NOT NULL";

    await db.execute('''
      CREATE TABLE $tableNotes(
      ${NoteField.id} $idType,
      ${NoteField.isImportant} $boolType,
      ${NoteField.number} $integerType,
      ${NoteField.title} $textType,
      ${NoteField.description} $textType,
      ${NoteField.time} $textType,
      )
''');
  }

  Future<Notemodel> createNote(Notemodel note) async {
    final db = await instance.database;
    // final json = note.toJson();
    // final column =
    //     '${NoteField.title},${NoteField.description},${NoteField.time}';
    // final values =
    //     '${NoteField.title},${NoteField.description},${NoteField.time}';
    // final id =
    //     await db.rawInsert('INSERT INTO table_name ($column) VALUES ($values)');
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Notemodel> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableNotes,
        columns: NoteField.values,
        where: '${NoteField.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Notemodel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Notemodel>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteField.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Notemodel.fromJson(json)).toList();
  }

  Future<int> update(Notemodel note) async {
    final db = await instance.database;

    return db.update(tableNotes, note.toJson(),
        where: '${NoteField.id} =?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NoteField.id}=?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
