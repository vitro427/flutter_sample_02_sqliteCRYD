import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_sample_02_sqlite/db/contact.dart';

final String TableName = 'Contacts';

class DBHelper{
  var _db;

  Future<Database> get database async{
    if( _db != null) return _db;
    _db = openDatabase(
      join(await getDatabasesPath(), 'contacts.db'),
      version: 1,
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE contacts(id TEXT PRIMARY KEY, name TEXT, phone TEXT, editTime TEXT)",
        );
      }
    );
    return _db;
  }

  Future<List<Contact>> Contacts() async{
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('Contacts');
    return List.generate(maps.length, (i){
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        editTime: maps[i]['editTime'],
      );
    });
  }

  Future<List<Contact>> ContactsId(String id) async{
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('Contacts', where: 'id = ?', whereArgs: [id]);


    return List.generate(maps.length, (i){
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        editTime: maps[i]['editTime'],
      );
    });
  }

  Future<void> insertContact(Contact contact) async{
    final db = await database;
    await db.insert(
        TableName,
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateContact(Contact contact) async{
    final db = await database;
    await db.update(
      TableName,
      contact.toMap(),
      where : "id = ?",
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(String id) async{
    final db = await database;
    await db.delete(
      TableName,
      where : "id = ?",
      whereArgs: [id],
    );
  }


}