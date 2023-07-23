import 'package:my_pantry/product.dart';
import 'package:my_pantry/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DbService{
  static final DbService _instance = DbService._internal();
  factory DbService() {
    return _instance;
  }
  DbService._internal();

  Future<Database> initDatabase() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'inventory.db');

    return openDatabase(
      path,
      onCreate: (db, version) async{
        await db.execute(
          "CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, description TEXT, quantity INTEGER)",
        );
        await db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY, transactionDate TEXT, productId INTEGER, qty INTEGER, transactionType TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertProduct(Product product) async{
    final Database db = await initDatabase();
    await db.insert(
      'products',
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Update product quantity
  Future<void> updateProductQuantity(int productId, int qty) async{
    final Database db = await initDatabase();
    await db.rawUpdate(
      "UPDATE products SET quantity = quantity + ? WHERE id = ?",
      [qty, productId]
    );
  }

  Future<void> insertTransaction(InventoryTransaction transaction) async{
    final Database db = await initDatabase();
    await db.insert(
      'transactions',
      transaction.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getProducts() async{
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        quantity: maps[i]['quantity'],
      );
    });
  }

  Future<List<InventoryTransaction>> getTransactions() async{
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return InventoryTransaction(
        id: maps[i]['id'],
        transactionDate: maps[i]['transactionDate'],
        productId: maps[i]['productId'],
        qty: maps[i]['qty'],
        transactionType: maps[i]['transactionType'],
      );
    });
  }

}