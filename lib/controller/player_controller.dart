import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:volei_app/controller/teams_controller.dart';
import 'package:volei_app/database/db.dart';

class PlayerController {
  late Database database;

  insertPlayer(nome, nivel, posicao) async {
    database = await SqliteDatabase().open();
    await database.execute(
        'INSERT INTO Jogador(nome,nivel_habilidade,posicao) VALUES ("$nome", "$nivel", "$posicao")');
  }

  Future<List<Map<String, Object?>>?> getAllPlayers() async {
    database = await SqliteDatabase().open();

    var list =
        await database.rawQuery('SELECT * FROM Jogador ORDER BY nome ASC');
    return list;
  }

  deletePlayer(id) async {
    database = await SqliteDatabase().open();

    await database.delete('Jogador', where: 'id = $id');
  }

  // countLowLevelPlayer() async {
  //   database = await SqliteDatabase().open();

  //   var list = await database
  //       .rawQuery('SELECT COUNT(*) as total FROM Jogador WHERE nivel <= ?'[2]);
  //   return Sqflite.firstIntValue(list) ?? 0;
  // }

  insertPlayerOnTeam() async {
    database = await SqliteDatabase().open();
    final random = Random();
    List<Map<String, Object?>>? numberTeams =
        await TeamsController().getAllTeams();

    List<Map<String, Object?>>? players = await getAllPlayers();

    // var lowLevelPlayers = await countLowLevelPlayer();

    final sorteados = <int>{};

    for (var i = 0; i < numberTeams!.length; i++) {
      for (var j = 0; j < 4; j++) {
        var drawnPlayer = random.nextInt(players!.length);
        if (!sorteados.contains(drawnPlayer)) {
          sorteados.add(drawnPlayer);
          database.update('Jogador', {"timesId": i + 1},
              where: 'id = ?', whereArgs: [players[drawnPlayer]['id']]);
        } else if (sorteados.length == players.length) {
          return;
        } else {
          j--;
        }
      }
    }
  }
}
