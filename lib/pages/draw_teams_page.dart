import 'package:flutter/material.dart';
import 'package:volei_app/controller/teams_controller.dart';

class DrawTeamsPage extends StatefulWidget {
  const DrawTeamsPage({super.key});

  @override
  State<DrawTeamsPage> createState() => _DrawTeamsPageState();
}

class _DrawTeamsPageState extends State<DrawTeamsPage> {
  Future<List<Map<int, List<String>>>> future =
      TeamsController().getTeamsWithPlayers();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(
                    child: Text('Falha ao carregar os dados!'),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Não há times registrados'),
                  );
                } else {
                  final teams = snapshot.data;
                  return ListView.builder(
                      itemCount: teams!.length,
                      itemBuilder: (context, index) {
                        final element = teams[index];
                        final teamId = element.keys.first;
                        final players = element.values.first;

                        return Container(
                          margin: EdgeInsets.only(bottom: 25),
                          color: Colors.blue,
                          child: Center(
                            child: Column(
                              children: [
                                Text('Time $teamId'),
                                const SizedBox(
                                  height: 4,
                                ),
                                if (players.isNotEmpty)
                                  ...players.map((nome) => Text("• $nome"))
                                else
                                  const Text("Nenhum jogador",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic))
                              ],
                            ),
                          ),
                        );
                      });
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            future = TeamsController().generateTeams();
          });
        },
        child: Text('Sortear times'),
      ),
    );
  }
}
