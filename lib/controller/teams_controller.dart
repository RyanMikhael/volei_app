import 'package:sqflite/sqflite.dart';
import 'package:volei_app/controller/player_controller.dart';
import 'package:volei_app/database/db.dart';

class TeamsController {
  late Database database;

  Future<List<Map<int, List<String>>>> generateTeams() async {
    database = await SqliteDatabase().open();
    final result = await database.query('Times', limit: 1);
    if (result.isNotEmpty) {
      await SqliteDatabase().deleteTeams();
    }
    List<Map<String, Object?>>? listPlayers =
        await PlayerController().getAllPlayers();
    int numberPlayers = listPlayers!.length;
    int numberTeams = numberPlayers ~/ 4;
    int rest = numberPlayers % 4;

    if (rest == 0) {
      for (var i = 1; i <= numberTeams; i++) {
        await database.insert('Times', {'id': i});
      }
    } else {
      for (var i = 1; i <= numberTeams + 1; i++) {
        await database.insert('Times', {'id': i});
      }
    }

    await PlayerController().insertPlayerOnTeam();
    var list = await getTeamsWithPlayers();
    return list;
  }

  Future<List<Map<String, Object?>>?> getAllTeams() async {
    database = await SqliteDatabase().open();
    var list = await database.query('Times');
    return list;
  }

  Future<List<Map<int, List<String>>>> getTeamsWithPlayers() async {
    database = await SqliteDatabase().open();

    final result = await database.rawQuery('''
    SELECT t.id AS times_id,
           j.id AS jogador_id, j.nome AS jogador_nome
    FROM Times t
    LEFT JOIN Jogador j ON j.timesId = t.id
  ''');

    final list = await transformAsList(result);

    return list;
  }

  Future<List<Map<int, List<String>>>> transformAsList(
      List<Map<String, Object?>>? dados) async {
    final mapaTemp = <int, List<String>>{};

    for (var row in dados!) {
      final int teamId = row['times_id'] as int;
      final playerName = row['jogador_nome'] as String?;

      mapaTemp.putIfAbsent(teamId, () => []);

      if (playerName != null) {
        mapaTemp[teamId]!.add(playerName);
      }
    }

    final resultado = mapaTemp.entries.map((e) => {e.key: e.value}).toList();

    return resultado;
  }
}
