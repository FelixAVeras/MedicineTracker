import 'package:path/path.dart';
import 'package:pilldotrack/models/Medicine.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal(); // Singleton
  static Database? _database; // La instancia de la base de datos

  // Constructor interno para el patrón Singleton
  DatabaseService._internal();

  // Factory constructor para devolver la única instancia del servicio
  factory DatabaseService() {
    return _instance;
  }

  // Obtiene la instancia de la base de datos.
  // Si no está inicializada, la inicializa primero.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa y abre la base de datos.
  // Crea la tabla 'medicines' si no existe.
  Future<Database> _initDatabase() async {
    // Obtiene la ruta al directorio de documentos de la aplicación.
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'medication_reminders.db'); // Nombre de tu archivo de base de datos

    return await openDatabase(
      path,
      version: 1, // Versión de la base de datos (importante para migraciones futuras)
      onCreate: (db, version) async {
        // Ejecuta el comando SQL para crear la tabla 'medicines'
        await db.execute('''
          CREATE TABLE medicines(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            dose TEXT NOT NULL,
            frequency TEXT NOT NULL,
            alias TEXT NOT NULL,
            isPermanent INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Aquí manejarías las migraciones de la base de datos si cambias la estructura en el futuro
        // Por ejemplo:
        // if (oldVersion < 2) {
        //   db.execute("ALTER TABLE medicines ADD COLUMN newColumn TEXT;");
        // }
      },
    );
  }

  // --- Operaciones CRUD (Crear, Leer, Actualizar, Borrar) ---

  // Inserta un nuevo medicamento en la base de datos.
  Future<int> insertMedicine(Medicine medicine) async {
    final db = await database; // Obtiene la instancia de la base de datos
    return await db.insert(
      'medicines', // Nombre de la tabla
      medicine.toMap(), // Datos del medicamento como Map
      conflictAlgorithm: ConflictAlgorithm.replace, // Reemplaza si hay conflicto de ID
    );
  }

  // Obtiene todos los medicamentos de la base de datos.
  Future<List<Medicine>> getMedicines() async {
    final db = await database;
    // Consulta todos los registros en la tabla 'medicines'
    final List<Map<String, dynamic>> maps = await db.query('medicines');

    // Convierte la lista de Maps (resultados de la consulta) a una lista de objetos Medicine.
    return List.generate(maps.length, (i) {
      return Medicine.fromMap(maps[i]);
    });
  }

  // Obtiene un medicamento por su ID.
  Future<Medicine?> getMedicineById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      where: 'id = ?', // Cláusula WHERE para filtrar por ID
      whereArgs: [id], // Argumentos para la cláusula WHERE
    );

    if (maps.isNotEmpty) {
      return Medicine.fromMap(maps.first);
    }
    return null;
  }


  // Actualiza un medicamento existente en la base de datos.
  Future<int> updateMedicine(Medicine medicine) async {
    final db = await database;
    return await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?', // Cláusula WHERE para especificar qué registro actualizar
      whereArgs: [medicine.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Elimina un medicamento de la base de datos por su ID.
  Future<int> deleteMedicine(int id) async {
    final db = await database;
    return await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cierra la base de datos (útil al salir de la aplicación o en pruebas).
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null; // Reinicia la instancia para que se vuelva a abrir si es necesario
  }
}