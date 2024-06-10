import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tugas_uasppb/JsonModels/users.dart';
import 'package:tugas_uasppb/models/Product.dart';
import 'package:tugas_uasppb/models/Cart.dart';

class DatabaseHelper {
  static const _databaseName = "shop_app.db";
  static const _databaseVersion = 1;

  static const tableCart = 'cart';
  static const tableUsers = 'users';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        title TEXT,
        description TEXT,
        images TEXT,
        price REAL,
        quantity INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableUsers (
        usrId INTEGER PRIMARY KEY AUTOINCREMENT,
        usrName TEXT UNIQUE,
        usrPassword TEXT
      )
    ''');
  }

  // Cart operations
  Future<int> insertCartItem(Cart cart) async {
    Database db = await database;
    var res = await db.rawQuery("SELECT * FROM $tableCart WHERE productId = ?", [cart.product.id]);
    if (res.isNotEmpty) {
      return await db.update(
        tableCart,
        {'quantity': cart.quantity},
        where: "productId = ?",
        whereArgs: [cart.product.id],
      );
    } else {
      return await db.insert(tableCart, {
        'productId': cart.product.id,
        'title': cart.product.title,
        'description': cart.product.description,
        'images': cart.product.images.join(','),
        'price': cart.product.price,
        'quantity': cart.quantity,
      });
    }
  }

  Future<int> deleteCartItem(int productId) async {
    Database db = await database;
    return await db.delete(tableCart, where: 'productId = ?', whereArgs: [productId]);
  }

  Future<List<Cart>> getCartItems() async {
    Database db = await database;
    var res = await db.query(tableCart);
    List<Cart> list = res.isNotEmpty
        ? res.map((c) {
            List<String> images = (c['images'] as String).split(',');
            return Cart(
              product: Product(
                id: c['productId'] as int,
                title: c['title'] as String,
                description: c['description'] as String,
                images: images,
                price: c['price'] as double,
              ),
              quantity: c['quantity'] as int,
            );
          }).toList()
        : [];
    return list;
  }

  Future<void> clearCart() async {
    Database db = await database;
    await db.delete(tableCart);
  }

  // User authentication operations
  Future<bool> login(Users user) async {
    Database db = await database;
    var result = await db.rawQuery(
        "SELECT * FROM $tableUsers WHERE usrName = ? AND usrPassword = ?", [user.usrName, user.usrPassword]);
    return result.isNotEmpty;
  }

  Future<int> signup(Users user) async {
    Database db = await database;
    return db.insert(tableUsers, user.toMap());
  }

  void updateCartItem(Cart demoCart) {}
}
