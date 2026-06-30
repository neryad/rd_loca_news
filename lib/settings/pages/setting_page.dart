// import 'package:flutter/material.dart';
// import 'package:rd_loca_news/about/about_page.dart';
// import 'package:rd_loca_news/main.dart';
// import 'package:rd_loca_news/shared/colors.dart';
// import 'package:rd_loca_news/shared/shared_preference.dart';

// class SettingPages extends StatefulWidget {
//   const SettingPages({super.key});

//   @override
//   State<SettingPages> createState() => Variables();
// }

// class Variables extends State<SettingPages> {
//   bool isDarkMode = false;
//   SharedPreference preference = SharedPreference();
//   late Color _selectedColor;

//   @override
//   void initState() {
//     super.initState();
//     isDarkMode = preference.darkMode;
//     _selectedColor = preference.defaultColor;
//   }

//   static const List<String> colorNames = [
//     'Rojo',
//     'Verde',
//     'Azul',
//   ];

//   static const List<IconData> colorIcons = [
//     Icons.palette,
//     Icons.palette,
//     Icons.palette,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ajustes'),
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 // Sección de Apariencia
//                 _buildSectionHeader('Apariencia', Icons.brush_outlined),
//                 const SizedBox(height: 8),

//                 // Card para Modo Oscuro
//                 Card(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: BorderSide(
//                       color: Theme.of(context).dividerColor.withOpacity(0.2),
//                     ),
//                   ),
//                   child: SwitchListTile(
//                     value: preference.darkMode,
//                     title: const Text(
//                       'Modo oscuro',
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     subtitle: Text(
//                       isDarkMode ? 'Activado' : 'Desactivado',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         isDarkMode = !isDarkMode;
//                         preference.darkMode = isDarkMode;
//                         MainApp.stateSet(context);
//                       });
//                     },
//                     secondary: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: _selectedColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         isDarkMode ? Icons.dark_mode : Icons.light_mode,
//                         color: _selectedColor,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Sección de Color de Tema
//                 _buildSectionHeader(
//                     'Color del tema', Icons.color_lens_outlined),
//                 const SizedBox(height: 8),

//                 // Card para Colores
//                 Card(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: BorderSide(
//                       color: Theme.of(context).dividerColor.withOpacity(0.2),
//                     ),
//                   ),
//                   child: Column(
//                     children: List<Widget>.generate(colors.length, (index) {
//                       final isFirst = index == 0;
//                       final isLast = index == colors.length - 1;

//                       return Column(
//                         children: [
//                           RadioListTile<Color>(
//                             title: Row(
//                               children: [
//                                 // Círculo de color
//                                 Container(
//                                   width: 24,
//                                   height: 24,
//                                   decoration: BoxDecoration(
//                                     color: colors[index],
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: Colors.white,
//                                       width: 2,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: colors[index].withOpacity(0.3),
//                                         blurRadius: 4,
//                                         offset: const Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   colorNames[index],
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             value: colors[index],
//                             groupValue: _selectedColor,
//                             activeColor: colors[index],
//                             onChanged: (value) {
//                               if (value != null) {
//                                 setState(() {
//                                   _selectedColor = value;
//                                   preference.defaultColor = _selectedColor;
//                                   MainApp.stateSet(context);
//                                 });
//                               }
//                             },
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                           ),
//                           if (!isLast)
//                             Divider(
//                               height: 1,
//                               indent: 16,
//                               endIndent: 16,
//                               color: Theme.of(context)
//                                   .dividerColor
//                                   .withOpacity(0.1),
//                             ),
//                         ],
//                       );
//                     }),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Sección de Información
//                 _buildSectionHeader('Información', Icons.info_outline),
//                 const SizedBox(height: 8),

//                 // Card para Acerca de
//                 Card(
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: BorderSide(
//                       color: Theme.of(context).dividerColor.withOpacity(0.2),
//                     ),
//                   ),
//                   child: ListTile(
//                     leading: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: _selectedColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.info_outline,
//                         color: _selectedColor,
//                         size: 24,
//                       ),
//                     ),
//                     title: const Text(
//                       'Acerca de',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     subtitle: const Text(
//                       'Información de la app y desarrollador',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     trailing: Icon(
//                       Icons.arrow_forward_ios,
//                       size: 16,
//                       color: Colors.grey[600],
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AboutPage(),
//                         ),
//                       );
//                     },
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 // Información adicional
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: _selectedColor.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: _selectedColor.withOpacity(0.1),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.info_outline,
//                         color: _selectedColor,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           'Los cambios se aplicarán inmediatamente',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Footer mejorado
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//             decoration: BoxDecoration(
//               border: Border(
//                 top: BorderSide(
//                   color: Theme.of(context).dividerColor.withOpacity(0.1),
//                 ),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Hecho con ',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Icon(
//                   Icons.favorite,
//                   color: _selectedColor,
//                   size: 16,
//                 ),
//                 Text(
//                   ' & Flutter por Nery',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 4, bottom: 4),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 20,
//             color: _selectedColor,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[800],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:rd_loca_news/about/about_page.dart';

import 'package:rd_loca_news/main.dart';
import 'package:rd_loca_news/settings/widgets/markdowmViewer.dart';

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
    _selectedColor = preference.defaultColor;
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
                      final isLast = index == colors.length - 1;

                      return Column(
                        children: [
                          RadioListTile<Color>(
                            title: Row(
                              children: [
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

                // Sección de Legal
                _buildSectionHeader(
                    'Legal y Privacidad', Icons.shield_outlined),
                const SizedBox(height: 8),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        context,
                        icon: Icons.article_rounded,
                        title: 'Términos y condiciones',
                        subtitle: 'Lee los términos de uso de la app',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MarkdownViewer(
                                fileRoute:
                                    'assets/mdFiles/TERMS_AND_CONDITIONS.md',
                              ),
                            ),
                          );
                        },
                      ),
                      _buildDivider(context),
                      _buildListTile(
                        context,
                        icon: Icons.privacy_tip_rounded,
                        title: 'Política de privacidad',
                        subtitle: 'Cómo manejamos tus datos',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MarkdownViewer(
                                fileRoute: 'assets/mdFiles/PRIVACY_POLICY.md',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sección de Soporte
                _buildSectionHeader(
                    'Soporte y Comunidad', Icons.support_outlined),
                const SizedBox(height: 8),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        context,
                        icon: Icons.code_rounded,
                        title: 'Repositorio en GitHub',
                        subtitle: 'Visita el código del proyecto',
                        onTap: () => _launchUrl(
                            'https://github.com/neryad/rd_loca_news'),
                      ),
                      _buildDivider(context),
                      _buildListTile(
                        context,
                        icon: Icons.favorite_border_rounded,
                        title: 'Apoya el proyecto',
                        subtitle: 'Donación opcional en PayPal',
                        onTap: () => _launchUrl(
                            'https://paypal.me/neryad?country.x=DO&locale.x=en_US'),
                      ),
                      _buildDivider(context),
                      _buildListTile(
                        context,
                        icon: Icons.history_rounded,
                        title: 'Historial de cambios',
                        subtitle: 'Versiones y actualizaciones',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MarkdownViewer(
                                fileRoute: 'assets/mdFiles/CHANGELOG.md',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sección de Información
                _buildSectionHeader('Información', Icons.info_outline),
                const SizedBox(height: 8),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: _buildListTile(
                    context,
                    icon: Icons.info_outline,
                    title: 'Acerca de',
                    subtitle: 'Información de la app y desarrollador',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutPage(),
                        ),
                      );
                    },
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

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _selectedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: _selectedColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[600],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).dividerColor.withOpacity(0.1),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Error al abrir URL
    }
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
