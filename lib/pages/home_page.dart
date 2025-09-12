import 'package:flutter/material.dart';
import 'package:volei_app/pages/draw_teams_page.dart';
import 'package:volei_app/pages/list_players_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> tabs = [const ListPlayersPage(), const DrawTeamsPage()];

  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Jogadores',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups), label: 'Sortear times')
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
