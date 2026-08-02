import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbHelper {
  static final LocalDbHelper instance = LocalDbHelper._init();
  static Database? _database;

  LocalDbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('valora.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
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
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabla para guardar estimaciones salariales
    await db.execute('''
      CREATE TABLE local_estimations (
        profile_id TEXT PRIMARY KEY,
        estimation_json TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabla para guardar job matches
    await db.execute('''
      CREATE TABLE local_job_matches (
        profile_id TEXT PRIMARY KEY,
        matches_json TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabla para perfiles (para guardar la ruta de la foto localmente, etc)
    await db.execute('''
      CREATE TABLE local_profiles (
        profile_id TEXT PRIMARY KEY,
        local_photo_path TEXT,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  /// Guarda una estimación salarial en la base de datos local
  Future<void> saveSalaryEstimation(String profileId, String jsonStr) async {
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

  /// Recupera la última estimación salarial guardada
  Future<String?> getSalaryEstimation(String profileId) async {
    final db = await instance.database;
    final maps = await db.query(
      'local_estimations',
      columns: ['estimation_json'],
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    if (maps.isNotEmpty) {
      return maps.first['estimation_json'] as String;
    }
    return null;
  }

  /// Limpia la estimación cuando se actualiza el perfil
  Future<void> clearSalaryEstimation(String profileId) async {
    final db = await instance.database;
    await db.delete(
      'local_estimations',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
  }

  /// Guarda los resultados de compatibilidad laboral en la base de datos local
  Future<void> saveJobMatches(String profileId, String jsonStr) async {
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

  /// Recupera los resultados de compatibilidad laboral guardados
  Future<String?> getJobMatches(String profileId) async {
    final db = await instance.database;
    final maps = await db.query(
      'local_job_matches',
      columns: ['matches_json'],
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    if (maps.isNotEmpty) {
      return maps.first['matches_json'] as String;
    }
    return null;
  }

  /// Limpia el caché de compatibilidad laboral cuando se actualiza el perfil
  Future<void> clearJobMatches(String profileId) async {
    final db = await instance.database;
    await db.delete(
      'local_job_matches',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
  }

  /// Guarda la ruta de la foto de perfil localmente
  Future<void> saveLocalProfilePhoto(String profileId, String path) async {
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
    final db = await instance.database;
    final maps = await db.query(
      'local_profiles',
      columns: ['local_photo_path'],
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    if (maps.isNotEmpty) {
      return maps.first['local_photo_path'] as String?;
    }
    return null;
  }
}
