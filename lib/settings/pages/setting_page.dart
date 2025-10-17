import 'package:flutter/material.dart';
import 'package:rd_loca_news/about/about_page.dart';
import 'package:rd_loca_news/main.dart';
import 'package:rd_loca_news/shared/colors.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';

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
    _selectedColor = preference.defaultColor;
  }

  static const List<String> colorNames = [
    'Rojo',
    'Verde',
    'Azul',
  ];

  static const List<IconData> colorIcons = [
    Icons.palette,
    Icons.palette,
    Icons.palette,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Sección de Apariencia
                _buildSectionHeader('Apariencia', Icons.brush_outlined),
                const SizedBox(height: 8),

                // Card para Modo Oscuro
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: SwitchListTile(
                    value: preference.darkMode,
                    title: const Text(
                      'Modo oscuro',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      isDarkMode ? 'Activado' : 'Desactivado',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = !isDarkMode;
                        preference.darkMode = isDarkMode;
                        MainApp.stateSet(context);
                      });
                    },
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: _selectedColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sección de Color de Tema
                _buildSectionHeader(
                    'Color del tema', Icons.color_lens_outlined),
                const SizedBox(height: 8),

                // Card para Colores
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: List<Widget>.generate(colors.length, (index) {
                      final isFirst = index == 0;
                      final isLast = index == colors.length - 1;

                      return Column(
                        children: [
                          RadioListTile<Color>(
                            title: Row(
                              children: [
                                // Círculo de color
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: colors[index],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors[index].withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  colorNames[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            value: colors[index],
                            groupValue: _selectedColor,
                            activeColor: colors[index],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedColor = value;
                                  preference.defaultColor = _selectedColor;
                                  MainApp.stateSet(context);
                                });
                              }
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          if (!isLast)
                            Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.1),
                            ),
                        ],
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                // Sección de Información
                _buildSectionHeader('Información', Icons.info_outline),
                const SizedBox(height: 8),

                // Card para Acerca de
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: _selectedColor,
                        size: 24,
                      ),
                    ),
                    title: const Text(
                      'Acerca de',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text(
                      'Información de la app y desarrollador',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutPage(),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Información adicional
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedColor.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: _selectedColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Los cambios se aplicarán inmediatamente',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer mejorado
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hecho con ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Icon(
                  Icons.favorite,
                  color: _selectedColor,
                  size: 16,
                ),
                Text(
                  ' & Flutter por Nery',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: _selectedColor,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
