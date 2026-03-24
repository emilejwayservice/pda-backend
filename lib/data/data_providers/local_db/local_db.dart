import 'dart:io';

import 'package:path/path.dart';
import 'package:pda/data/models/command.dart';
import 'package:pda/data/models/product.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  late Database _database;
  static const String _dbName = "fromital.db";

  static const String _products = "products";
  static const String _commands = "commands";
  static const String _commandDatails = "commands_details";
  static const int _version = 2;



  LocalDB(Database db):_database=db;

  static Future<LocalDB> initialise() async {
    String dbPath = await getDatabasesPath();
    String fullPath = join(dbPath, _dbName);
    Database db =
        await openDatabase(fullPath, version: _version, onCreate: _createDB);
    return LocalDB(db);
  }

  static void _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "${_products}" (
	"id"	INTEGER,
	"name"	TEXT,
	"quantity"	INTEGER,
	"is_sent"	INTEGER,
	"price"	NUMERIC,
	"image_url"	TEXT,
	"image_path"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
    ''');

    await db.execute('''
   CREATE TABLE "${_commands}" (
	"id"	INTEGER,
	"date"	datetime,
	"client_id"	INTEGER,
	"is_sent"	INTEGER,
	"is_done"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
);
    ''');

    await db.execute('''
  CREATE TABLE "${_commandDatails}" (
	"id"	INTEGER,
	"product_id"	INTEGER,
	"command_id"	INTEGER,
	"qty"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
);
    ''');

  }



  Future<void> insertProduct(ProductModel product)async{
    await _database.insert(_products, product.toLocalJson());
  }

  Future<List<ProductModel>> getProducts()async{
    List<Map<String,dynamic>> prodsData=await _database.query(_products);
    List<ProductModel> prods=prodsData.map((e) => ProductModel.fromJson(e)).toList();
    return prods;
  }

  Future<int> getCountProductsNotSent()async{
    var result=await _database.rawQuery("select count(*) from ${_products} where is_sent=0");
    int count=Sqflite.firstIntValue(result)??0;
    return count;
  }


  Future<List<ProductModel>> getProductsNotSent()async{
    List<Map<String,dynamic>> prodsData=await _database.query(_products,where: "is_sent=0",groupBy: "name",columns: ["name","sum(quantity) as quantity"]);
    List<ProductModel> products=prodsData.map((e) => ProductModel.fromJson(e)).toList();
    return products;
  }


  Future<void> insertCommand(CommandModel command)async{
    await _database.insert(_commands, command.toLocalJson());
  }

  Future<List<CommandModel>> getCommands()async{
    List<Map<String,dynamic>> commands=await _database.query(_commands);
    List<CommandModel> commandsM=commands.map((e) => CommandModel.fromMap(e)).toList();
    return commandsM;
  }

  Future<List<CommandModel>> getCommandNotSent()async{
    List<Map<String,dynamic>> commands=await _database.query(_commands,where: "is_sent=0");
    List<CommandModel> commandsM=commands.map((e) => CommandModel.fromMap(e)).toList();
    return commandsM;
  }

  Future<void> updateSentProducts()async{
    await _database.rawUpdate("update $_products set is_sent=1 where is_sent=0");
  }






}
