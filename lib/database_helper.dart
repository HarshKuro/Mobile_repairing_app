import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'customer.dart';
import 'message.dart';

class DatabaseHelper {
  // Singleton instance of the database helper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database information
  static const _databaseName = 'app_data.db';
  static const _databaseVersion = 1;

  // Table names
  static const _customerTable = 'customers';
  static const _messageTable = 'messages';

  // Column names
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPhone = 'phone';
  static const columnCustomerId = 'customerId';
  static const columnMessage = 'message';
  static const columnTimestamp = 'timestamp';
  static const columnIsSent = 'isSent';

  // Private constructor to prevent external instantiation
  DatabaseHelper._privateConstructor();

  // Internal database instance
  static Database? _database;

  // Get the database instance, initializing it if necessary
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the database tables
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
        FOREIGN KEY ($columnCustomerId) REFERENCES $_customerTable ($columnId)
      )
      ''');
  }

  // Insert a new customer into the database
  Future<int> insertCustomer(Customer customer) async {
    Database db = await instance.database;
    return await db.insert(_customerTable, customer.toMap());
  }

  // Fetch all customers from the database
  Future<List<Customer>> queryAllCustomers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> customerMap = await db.query(_customerTable);
    return customerMap.map((e) => Customer.fromMap(e)).toList();
  }

  // Update an existing customer in the database
  Future<int> updateCustomer(Customer customer) async {
    Database db = await instance.database;
    return await db.update(_customerTable, customer.toMap(),
        where: '$columnId = ?', whereArgs: [customer.id]);
  }

  // Delete a customer from the database
  Future<int> deleteCustomer(int id) async {
    Database db = await instance.database;
    return await db.delete(_customerTable,
        where: '$columnId = ?', whereArgs: [id]);
  }

  // Insert a new message into the database
  Future<int> insertMessage(Message message) async {
    Database db = await instance.database;
    return await db.insert(_messageTable, message.toMap());
  }

  // Fetch messages for a specific customer from the database
  Future<List<Message>> getMessagesForCustomer(int customerId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> messageMaps = await db.query(
      _messageTable,
      where: '$columnCustomerId = ?',
      whereArgs: [customerId],
    );
    return messageMaps.map((map) => Message.fromMap(map)).toList();
  }
}