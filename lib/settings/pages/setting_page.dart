import 'package:flutter/material.dart';
import 'package:rd_loca_news/main.dart';
import 'package:rd_loca_news/settings/widgets/markdownViewer.dart';
import 'package:rd_loca_news/shared/colors.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPages extends StatefulWidget {
  const SettingPages({super.key});

  @override
  State<SettingPages> createState() => Variables();
}

class Variables extends State<SettingPages> {
  bool isDarkMode = false;
  SharedPreference preference = SharedPreference();
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    isDarkMode = preference.darkMode;
    _selectedColor = preference.defaultColor; // Inicializar _selectedColor
  }

  static const List<String> colorNames = [
    'Rojo',
    'Verde',
    'Azul',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
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
                  ),
                  ListTile(
                    leading: const Icon(Icons
                        .history_rounded), // Icono más adecuado para el historial
                    title: const Text('Historial de cambios'),
                    subtitle: const Text(
                        'Consulta las versiones anteriores de la app y los cambios realizados.'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MarkdownViewer(
                                  fileRoute: 'assets/mdFiles/CHANGELOG.md')));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                        Icons.article_rounded), // Icono para documentos
                    title: const Text('Términos y condiciones'),
                    subtitle: const Text(
                        'Lee los términos y condiciones de uso de la app.'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MarkdownViewer(
                                  fileRoute:
                                      'assets/mdFiles/TERMS_AND_CONDITIONS.md')));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons
                        .privacy_tip_rounded), // Icono para políticas de privacidad
                    title: const Text('Política de privacidad'),
                    subtitle: const Text(
                        'Infórmate sobre cómo manejamos tus datos personales.'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MarkdownViewer(
                                  fileRoute:
                                      'assets/mdFiles/PRIVACY_POLICY.md')));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.code_rounded),
                    title: const Text('Repositorio en GitHub'),
                    subtitle: const Text('Visita el repositorio del proyecto'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      _launchUrl(
                          'https://github.com/neryad/rd_loca_news'); // Reemplaza con tu URL de GitHub
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_border_rounded),
                    title: const Text('Apoya el proyecto'),
                    subtitle: const Text(
                        'Deja una donación para contribuir al proyecto, las mismas son opcionales'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      _launchUrl(
                          'https://paypal.me/neryad?country.x=DO&locale.x=en_US'); // Reemplaza con tu URL de donación
                    },
                  ),
                ],
              ),
            ),
            //  const Spacer(),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Hecho con 💙 & Flutter by Nery',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
