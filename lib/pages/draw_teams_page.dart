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

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time $teamId',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            future = TeamsController().generateTeams();
          });
        },
        label: Text('Sortear times'),
      ),
    );
  }
}
