import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    user_name TEXT,
    restaurant_name TEXT,
    rating TEXT,
    review TEXT,
    image TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('restaurant.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      if (kDebugMode) {
        print('...creating a table...');
      }
      await createTables(database);
    });
  }

  static Future<int> createItem(String userName, String restaurantName,
      String rating, String? review, String image) async {
    final db = await SQLHelper.db();

    final data = {
      'user_name': userName,
      'restaurant_name': restaurantName,
      'rating': rating,
      'review': review,
      'image': image,
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: 'id= ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String userName, String restaurantName,
      String rating, String? review, String image) async {
    final db = await SQLHelper.db();

    final data = {
      'user_name': userName,
      'restaurant_name': restaurantName,
      'rating': rating,
      'review': review,
      'image': image,
      'createdAt': DateTime.now().toString(),
    };

    final result =
        await db.update('items', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong: $err');
    }
  }
}
