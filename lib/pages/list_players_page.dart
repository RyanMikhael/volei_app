import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volei_app/controller/player_controller.dart';
import 'package:volei_app/pages/add_player_page.dart';

class ListPlayersPage extends StatefulWidget {
  const ListPlayersPage({super.key});

  @override
  State<ListPlayersPage> createState() => _ListPlayersPageState();
}

class _ListPlayersPageState extends State<ListPlayersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: PlayerController().getAllPlayers(),
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
                child: Text('Não há jogadores registrados'),
              );
            } else {
              final players = snapshot.data;

              return ListView.builder(
                  itemCount: players!.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      background: Container(
                        alignment: Alignment(0.9, 0),
                        color: Colors.red,
                        child: Icon(Icons.delete),
                      ),
                      key: ValueKey(players[index]),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await PlayerController()
                            .deletePlayer(players[index].id);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(players[index].name),
                          subtitle: Text(players[index].position),
                          trailing: Text('Nivel ${players[index].level}'),
                        ),
                      ),
                    );
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(AddPlayerPage()),
        child: Icon(Icons.add),
      ),
    );
  }
}
