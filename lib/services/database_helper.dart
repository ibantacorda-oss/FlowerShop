import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // 1. Singleton Pattern
  DBHelper._init();
  static final DBHelper instance = DBHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flowershop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // 2. Create Tables
  Future _createDB(Database db, int version) async {
    // Flowers Table
    await db.execute('''
      CREATE TABLE flowers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        image TEXT
      )
    ''');

    // Cart Table
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        flowerId INTEGER,
        quantity INTEGER
      )
    ''');

    // NEW: Users Table for Login
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Optional: Pre-fill an admin user so you can log in immediately
    await db.insert('users', {'username': 'admin', 'password': 'password123'});

    // Pre-fill flowers table with sample data
    await db.insert('flowers',
        {'name': 'Red Rose', 'price': 5.99, 'image': 'assets/images/rose.png'});
    await db.insert('flowers', {
      'name': 'Sunflower',
      'price': 3.99,
      'image': 'assets/images/sunflower.png'
    });
    await db.insert('flowers',
        {'name': 'Tulip', 'price': 4.99, 'image': 'assets/images/tulip.png'});

    print('✓ Database initialized with sample data');
  }

  // --- LOGIN LOGIC ---

  // Check if user exists
  Future<bool> loginUser(String username, String password) async {
    final db = await database;
    print('🔍 Attempting login for user: $username');
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      print('✓ Login successful for: $username');
    } else {
      print('✗ Login failed for: $username');
    }
    return maps.isNotEmpty;
  }

  // Register a new user
  Future<int> registerUser(String username, String password) async {
    final db = await database;
    print('📝 Registering new user: $username');
    try {
      final result = await db.insert('users', {
        'username': username,
        'password': password,
      });
      print('✓ User registered successfully: $username (ID: $result)');
      return result;
    } catch (e) {
      print('✗ Registration failed: $e');
      rethrow;
    }
  }

  // --- FLOWER & CART LOGIC ---

  // Get all flowers
  Future<List<Map<String, dynamic>>> getAllFlowers() async {
    final db = await database;
    print('📦 Fetching all flowers from database');
    final flowers = await db.query('flowers');
    print('✓ Retrieved ${flowers.length} flowers');
    for (var flower in flowers) {
      print('   - ${flower['name']}: \$${flower['price']}');
    }
    return flowers;
  }

  Future<int> addToCart(Map<String, dynamic> data) async {
    final db = await database;
    print(
        '🛒 Adding to cart - Flower ID: ${data['flowerId']}, Qty: ${data['quantity']}');
    final id = await db.insert('cart', data);
    print('✓ Added to cart (Cart ID: $id)');
    return id;
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    final db = await database;
    print('📋 Fetching cart items...');
    final items = await db.query('cart');
    print('✓ Cart has ${items.length} items');
    return items;
  }

  Future<int> deleteCart(int id) async {
    final db = await database;
    print('🗑️ Deleting cart item ID: $id');
    final result = await db.delete('cart', where: 'id = ?', whereArgs: [id]);
    print('✓ Deleted $result item(s) from cart');
    return result;
  }
}
