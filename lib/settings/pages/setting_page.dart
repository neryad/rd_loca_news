import 'package:flutter/material.dart';
import 'package:rd_loca_news/main.dart';
import 'package:rd_loca_news/shared/colors.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';

//??9. Convertir esto a stateFull
class SettingPages extends StatefulWidget {
  const SettingPages({super.key});

  @override
  State<SettingPages> createState() => variables();
}

class variables extends State<SettingPages> {
  //??10. Crear varibles para darke mode y preferecias

  bool isDarkMode = false;
  SharedPreference preference = SharedPreference();
  //??13. Crear widhes y sus funcionalidades
  late Color _selectedColor;

  //??14. habcer override del init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDarkMode = preference.darkMode;
    _selectedColor = preference.defaultColor; // Inicializar _selectedColor
  }

  static const List<String> colorNames = ['Rojo', 'Verde', 'Azul'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              value: preference.darkMode,
              title: const Text('Modo oscuro'),
              onChanged: (value) {
                setState(() {
                  isDarkMode = !isDarkMode;
                  preference.darkMode = isDarkMode;
                  MainApp.stateSet(context);
                });
              },
              secondary: Icon(isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
            ),
            Column(
              children: List<Widget>.generate(colors.length, (index) {
                return RadioListTile<Color>(
                  title: Text(colorNames[index]),
                  value: colors[index],
                  groupValue: _selectedColor,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedColor = value;
                        preference.defaultColor = _selectedColor;
                        MainApp.stateSet(context);
                      });
                    }
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
