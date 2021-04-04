import 'package:capsianfood/model/CartItems.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class sqlite_helper{
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }
  initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'RMS.db');
    var db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    return db;
  }
  _onCreate(Database db, int version) async {
    // await db.execute("CREATE TABLE Cart("
    //      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    //      "order_id  INTEGER,"
    //      "customer_id  INTEGER,"
    //      "gross_total  INTEGER,"
    //      "order_type  TEXT,"
    //      "Items TEXT,"
    //       "Topping  TEXT,"
    //     ")");

    await db.execute("CREATE TABLE Cart("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "productId INTEGER,"
        "productName TEXT,"
        "quantity INTEGER,"
        "price DOUBLE,"
        "totalPrice DOUBLE,"
        "sizeId INTEGER,"
        "sizeName TEXT,"
        "isDeal INTEGER,"
        "dealId INTEGER,"
        "storeId INTEGER,"
        "topping TEXT"
        ")");


  }
  //Cart
 Future<int> create_cart(CartItems cartItems) async {
  var dbClient = await db;
   var result = await dbClient.insert("Cart", cartItems.toJson());
   return result;
 }
  updateCart(CartItems cartItems) async {
    final dbClient = await db;
    var response = await dbClient.update("Cart", cartItems.toJson(),
        where: "id = ?", whereArgs: [cartItems.id]);
    return response;
  }
  Future<List> getcart() async {
    var dbClient= await db;
    var result = await dbClient.rawQuery('SELECT * FROM Cart');
    return result.toList();
  }
  Future<List<CartItems>> getcart1() async {
    var dbClient= await db;
    var result = await dbClient.rawQuery('SELECT * FROM Cart');
    List<CartItems> cartlist =[];
    cartlist.clear();
    for(int i=0;i<result.length;i++){
      cartlist.add(CartItems(id: result[i]['id'],sizeName: result[i]['sizeName'],productId: result[i]['productId'],productName: result[i]['productName'],
      price: result[i]['price'],quantity: result[i]['quantity'],sizeId: result[i]['sizeId'],topping: result[i]['topping'],
          isDeal: result[i]['isDeal'],dealId: result[i]['dealId'],totalPrice: result[i]['totalPrice'],storeId: result[i]["storeId"]));
    }
    return cartlist;
  }
  Future<int> deletecart() async {
    var dbClient= await db;
    return await dbClient.rawDelete('DELETE FROM Cart');
  }
  Future<int> deleteProductsById(int id) async {

    var dbClient= await db;

    return await dbClient.delete("Cart",where: "id = ?",whereArgs: [id]);

  }
  Future<List> checkAlreadyExists(int productId) async {

    var dbClient= await db;

    var result = await dbClient.query("Cart",where: 'productId = ?',whereArgs: [productId]);

    return result.toList();

  }
  Future<List> checkIfAlreadyExists(int id) async {

    var dbClient= await db;

    var result = await dbClient.query("Cart",where: 'id = ?',whereArgs: [id]);

    return result.toList();

  }
  Future<List> gettotal() async {
    var dbClient= await db;
    var result = await dbClient.rawQuery('SELECT SUM(totalPrice) FROM Cart');
    return result;
  }
  Future<int> getcount() async {
    var dbClient= await db;
    var result = await dbClient.rawQuery('SELECT * FROM Cart');
    return result.toList().length;
  }



}
