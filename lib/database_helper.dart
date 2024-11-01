import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'customer.dart';
import 'message.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static const _databaseName = 'app_data.db';
  static const _databaseVersion = 1;
  static const _customerTable = 'customers';
  static const _messageTable = 'messages';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPhone = 'phone';
  static const columnCustomerId = 'customerId';
  static const columnMessage = 'message';
  static const columnTimestamp = 'timestamp';
  static const columnIsSent = 'isSent';
  static const columnCreatedAt = 'createdAt';
  static const columnUpdatedAt = 'updatedAt';

  Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_customerTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnPhone TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $_messageTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCustomerId INTEGER NOT NULL,
        $columnMessage TEXT NOT NULL,
        $columnTimestamp TEXT NOT NULL,
        $columnIsSent INTEGER NOT NULL,
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT,
        FOREIGN KEY ($columnCustomerId) REFERENCES $_customerTable ($columnId)
      )
      ''');
  }

  Future<int> insertCustomer(Customer customer) async {
    Database db = await instance.database;
    return await db.insert(_customerTable, customer.toMap());
  }

  Future<List<Customer>> queryAllCustomers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> customerMap = await db.query(_customerTable);
    return customerMap.map((e) => Customer.fromMap(e)).toList();
  }

  Future<int> updateCustomer(Customer customer) async {
    Database db = await instance.database;
    return await db.update(_customerTable, customer.toMap(),
        where: '$columnId = ?', whereArgs: [customer.id]);
  }

 Future<int> deleteCustomer(int id) async {
  Database db = await instance.database;
  return await db.delete(
    _customerTable,
    where: '$columnId = ?',
    whereArgs: [id],
  );
}

  Future<int> insertMessage(Message message) async {
    Database db = await instance.database;
    return await db.insert(_messageTable, message.toMap());
  }

  Future<List<Message>> getMessagesForCustomer(int customerId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> messageMaps = await db.query(
      _messageTable,
      where: '$columnCustomerId = ?',
      whereArgs: [customerId],
    );
    return messageMaps.map((map) => Message.fromMap(map)).toList();
  }

  Future<int> updateMessage(Message message) async {
    Database db = await instance.database;
    return await db.update(_messageTable, message.toMap(),
        where: '$columnId = ?', whereArgs: [message.id]);
  }

  Future<int> deleteMessage(int id) async {
    Database db = await instance.database;
    return await db
        .delete(_messageTable, where: '$columnId = ?', whereArgs: [id]);
  }
}