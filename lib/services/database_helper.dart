import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  Future<Database> get db async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final p = await getDatabasesPath();
    return openDatabase(
      join(p, 'webkam.db'),
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            marketKey TEXT NOT NULL,
            name TEXT NOT NULL,
            size TEXT NOT NULL,
            price REAL NOT NULL,
            wholesalePrice REAL,
            imagePath TEXT NOT NULL,
            imageSignature TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(Product p) async {
    final d = await db;
    return d.insert('products', p.toMap());
  }

  Future<List<Product>> byMarket(String key) async {
    final d = await db;
    final r = await d.query('products', where: 'marketKey = ?', whereArgs: [key]);
    return r.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Product>> all() async {
    final d = await db;
    final r = await d.query('products');
    return r.map((e) => Product.fromMap(e)).toList();
  }

  Future<Product?> matchSignature(String sig, {int tolerance = 8}) async {
    final d = await db;
    final r = await d.query('products');
    int best = tolerance + 1;
    Product? bestP;
    for (final row in r) {
      final s = row['imageSignature'] as String;
      final diff = _hamming(s, sig);
      if (diff < best) {
        best = diff;
        bestP = Product.fromMap(row);
      }
    }
    return bestP;
  }

  int _hamming(String a, String b) {
    if (a.length != b.length) return 999;
    int d = 0;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) d++;
    }
    return d;
  }
}