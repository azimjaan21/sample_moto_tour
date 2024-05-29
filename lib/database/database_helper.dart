import 'package:sample_moto_tour/models/ride.module.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'rides_database.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rides(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startStreet TEXT,
        finalStreet TEXT,
        waitTime INTEGER,
        status TEXT,
        startTime TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE rides ADD COLUMN startTime TEXT');
    }
  }

  Future<void> insertRide(Ride ride) async {
    final db = await database;
    await db.insert(
      'rides',
      ride.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ride>> getCurrentRides() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rides',
      where: 'status = ?',
      whereArgs: ['waiting'],
    );
    return List.generate(maps.length, (i) {
      return Ride.fromMap(maps[i]);
    });
  }

  Future<List<Ride>> getExpiredRides() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rides',
      where: 'status = ?',
      whereArgs: ['arrived'],
    );
    return List.generate(maps.length, (i) {
      return Ride.fromMap(maps[i]);
    });
  }

  Future<void> updateRide(Ride ride) async {
    final db = await database;
    await db.update(
      'rides',
      ride.toMap(),
      where: 'id = ?',
      whereArgs: [ride.id],
    );
  }

  Future<void> deleteRide(int id) async {
    final db = await database;
    await db.delete(
      'rides',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
