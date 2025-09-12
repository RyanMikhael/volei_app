import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volei_app/controller/player_controller.dart';
import 'package:volei_app/pages/home_page.dart';

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({super.key});

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  int? selectedLevel = 1;
  String? selectedPosition;

  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  List<int> levels = [1, 2, 3, 4, 5];

  final List<String> positions = [
    "Sem posição",
    "Frente",
    "Trás",
    "Todas as posições",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Nome do Jogador',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty || value.length == 1) {
                    return 'Por favor insira o nome do Jogador(O nome deve possuir duas letras ou mais)';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownMenu(
                  keyboardType: TextInputType.number,
                  initialSelection: levels[0],
                  width: MediaQuery.of(context).size.width,
                  label: const Text('Nivel de habilidade'),
                  onSelected: (int? value) {
                    setState(() {
                      selectedLevel = value;
                    });
                  },
                  dropdownMenuEntries: levels
                      .map(
                        (level) => DropdownMenuEntry(
                            value: level, label: 'Nivel $level'),
                      )
                      .toList()),
              const SizedBox(
                height: 30,
              ),
              DropdownMenu(
                  initialSelection: positions[0],
                  width: MediaQuery.of(context).size.width,
                  controller: positionController,
                  label: const Text('Posição do jogador'),
                  onSelected: (String? value) {
                    setState(() {
                      selectedPosition = value;
                    });
                  },
                  dropdownMenuEntries: positions
                      .map(
                        (position) =>
                            DropdownMenuEntry(value: position, label: position),
                      )
                      .toList()),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await PlayerController().insertPlayer(nameController.text,
                        selectedLevel, positionController.text);
                    Get.offAll(HomePage());
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Adicionar jogador',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
