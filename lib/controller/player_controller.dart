import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:volei_app/controller/teams_controller.dart';
import 'package:volei_app/database/db.dart';
import 'package:volei_app/model/player.dart';

class PlayerController {
  late Database database;

  insertPlayer(nome, nivel, posicao) async {
    database = await SqliteDatabase().open();
    await database.execute(
        'INSERT INTO Jogador(nome,nivel_habilidade,posicao) VALUES ("$nome", "$nivel", "$posicao")');
  }

  Future<List<Player>> getAllPlayers() async {
    database = await SqliteDatabase().open();

    var list =
        await database.rawQuery('SELECT * FROM Jogador ORDER BY nome ASC');
    return list
        .map((player) => Player(
            id: player['id'] as int,
            name: player['nome'] as String,
            level: player['nivel_habilidade'] as int,
            position: player['posicao'] as String))
        .toList();
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

    List<Player> players = await getAllPlayers();
    final drawnPlayers = <Player>[];

    if (players.length % numberTeams!.length == 0) {
      players.shuffle(random);

      final teams = List.generate(numberTeams!.length, (_) => <Player>[]);

      players.sort((a, b) => b.level.compareTo(a.level));

      for (var player in players) {
        teams.sort((a, b) => a
            .fold<int>(0, (s, player) => s + player.level)
            .compareTo(b.fold<int>(0, (s, player) => s + player.level)));

        for (var team in teams) {
          if (team.length < 4) {
            team.add(player);
            break;
          }
        }
      }

      for (var i = 0; i < teams.length; i++) {
        for (var player in teams[i]) {
          await database.update(
              "Jogador", {"timesId": numberTeams[i]['id'] as int},
              where: 'id = ?', whereArgs: [player.id]);
        }
      }
    } else {
      for (var i = 0; i < numberTeams.length; i++) {
        for (var j = 0; j < 4; j++) {
          var drawnPlayer = players[random.nextInt(players!.length)];
          if (!drawnPlayers.contains(drawnPlayer)) {
            drawnPlayers.add(drawnPlayer);
            database.update('Jogador', {"timesId": i + 1},
                where: 'id = ?', whereArgs: [drawnPlayer.id]);
          } else if (drawnPlayers.length == players.length) {
            return;
          } else {
            j--;
          }
        }
      }
    }
  }
}
