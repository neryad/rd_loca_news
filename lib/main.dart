import 'package:flutter/material.dart';
import 'package:rd_loca_news/homePage/page/home_page.dart';
import 'package:rd_loca_news/shared/colors.dart';
import 'package:rd_loca_news/shared/shared_preference.dart';

//??7. Declaracion de prefers
final prefs = SharedPreference();
void main() async {
  //??3. Agreara esto para asegurar que las intacias deWidgetsBinding  este inicializada
  WidgetsFlutterBinding.ensureInitialized();
  //??7. poner async y inicalizar prefers
  await prefs.initPrefes();
  runApp(const MainApp());
}

//??1. Convertir de stales a Stateful
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  //??1. Funcion para setear de forma general el estado
  static void stateSet(BuildContext context) {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Color _selectedColor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_selectedColor = prefs.appColor;
  }

  @override
  Widget build(BuildContext context) {
    //??8. dejar preparada la validacion si es modo oscuro o claro
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: prefs.defaultColor,
              brightness: prefs.darkMode ? Brightness.dark : Brightness.light)),
      home: HomePage(),
    );
  }
}
