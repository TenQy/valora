import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbHelper {
  static final LocalDbHelper instance = LocalDbHelper._init();
  static Database? _database;

  LocalDbHelper._init();

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite no está soportado nativamente en la web');
    }
    if (_database != null) return _database!;
    _database = await _initDB('valora.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE local_job_matches (
          profile_id TEXT PRIMARY KEY,
          matches_json TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE local_growth_paths (
          profile_id TEXT PRIMARY KEY,
          path_json TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE local_estimations (
        profile_id TEXT PRIMARY KEY,
        estimation_json TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE local_job_matches (
        profile_id TEXT PRIMARY KEY,
        matches_json TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE local_growth_paths (
        profile_id TEXT PRIMARY KEY,
        path_json TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE local_profiles (
        profile_id TEXT PRIMARY KEY,
        local_photo_path TEXT,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> saveSalaryEstimation(String profileId, String jsonStr) async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.insert(
      'local_estimations',
      {
        'profile_id': profileId,
        'estimation_json': jsonStr,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSalaryEstimation(String profileId) async {
    if (kIsWeb) return null;
    final db = await instance.database;
    final maps = await db.query(
      'local_estimations',
      columns: ['estimation_json'],
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    if (maps.isNotEmpty) return maps.first['estimation_json'] as String;
    return null;
  }

  Future<void> clearSalaryEstimation(String profileId) async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.delete('local_estimations', where: 'profile_id = ?', whereArgs: [profileId]);
  }

  Future<void> saveJobMatches(String profileId, String jsonStr) async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.insert(
      'local_job_matches',
      {
        'profile_id': profileId,
        'matches_json': jsonStr,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getJobMatches(String profileId) async {
    if (kIsWeb) return null;
    final db = await instance.database;
    final maps = await db.query(
      'local_job_matches',
      columns: ['matches_json'],
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    if (maps.isNotEmpty) return maps.first['matches_json'] as String;
    return null;
  }

  Future<void> clearJobMatches(String profileId) async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.delete('local_job_matches', where: 'profile_id = ?', whereArgs: [profileId]);
  }

  Future<void> saveLocalProfilePhoto(String profileId, String path) async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.insert(
      'local_profiles',
      {
        'profile_id': profileId,
        'local_photo_path': path,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getLocalProfilePhoto(String profileId) async {
    if (kIsWeb) return null;
    final db = await instance.database;
    final maps = await db.query(
      'local_profiles',
      columns: ['local_photo_path'],
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    if (maps.isNotEmpty) return maps.first['local_photo_path'] as String?;
    return null;
  }

  Future<void> saveGrowthPath(String profileId, String pathJson) async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.insert(
      'local_growth_paths',
      {
        'profile_id': profileId,
        'path_json': pathJson,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getGrowthPath(String profileId) async {
    if (kIsWeb) return null;
    final db = await instance.database;
    final maps = await db.query(
      'local_growth_paths',
      columns: ['path_json'],
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    if (maps.isNotEmpty) return maps.first['path_json'] as String;
    return null;
  }

  Future<DateTime?> getGrowthPathCreatedAt(String profileId) async {
    if (kIsWeb) return null;
    final db = await instance.database;
    final maps = await db.query(
      'local_growth_paths',
      columns: ['created_at'],
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    if (maps.isNotEmpty) return DateTime.tryParse(maps.first['created_at'] as String);
    return null;
  }

  Future<void> clearGrowthPath(String profileId) async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.delete('local_growth_paths', where: 'profile_id = ?', whereArgs: [profileId]);
  }
}
