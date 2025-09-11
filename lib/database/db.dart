import 'dart:async';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase {
  late String path;
  late Database database;

  Future<String> getPathDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = "$databasePath/volei.db";

    return path;
  }

  Future<Database> open() async {
    path = await getPathDatabase();
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Times(id INTEGER PRIMARY KEY);');
      await db.execute(
          'CREATE TABLE Jogador(id INTEGER PRIMARY KEY, nome TEXT, nivel_habilidade INTEGER, posicao TEXT, timesId INTEGER, FOREIGN KEY (timesId) REFERENCES Times(id));');
    });

    return database;
  }

  delete() async {
    path = await getPathDatabase();
    await deleteDatabase(path);
  }

  deleteTeams() async {
    database = await open();
    database.delete('Times');
  }
  // Future<Database> createTeams() async {
  //   path = await getPathDatabase();
  //   Database database = await openDatabase(path, version: 1,
  //       onCreate: (Database db, int version) async {
  //     await db.execute('DROP TABLE IF EXISTS Times');
  //     await db.execute('CREATE TABLE Times(id INTEGER PRIMARY KEY);');
  //   });

  //   return database;
  // }
}
