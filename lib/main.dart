import 'package:dvmapp/pokemonList.dart';
import 'package:dvmapp/splash.dart';
import 'package:dvmapp/type_nav.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedType = 'default';
  final TextEditingController _searchController = TextEditingController();

  void _onTypeSelected(String type) {
    setState(() {
      _selectedType = type.toLowerCase();
    });
  }

  String fetchingUrl() {
    switch(_selectedType) {
      case 'grass':
        return 'https://pokeapi.co/api/v2/type/12/';
      case 'ice':
        return 'https://pokeapi.co/api/v2/type/15/';
      case 'fire':
        return 'https://pokeapi.co/api/v2/type/10/';
      case 'default':
        return 'https://pokeapi.co/api/v2/pokemon/?offset=0&limit=1302';
      default:
        return 'https://pokeapi.co/api/v2/pokemon/?offset=0&limit=1302';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String fetchUrl = fetchingUrl();
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 110,
                child: Center(
                  child: Text(
                    'Pokedex',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(width: 1.7, color: Colors.white),
                      ),
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.white, fontSize: 20),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: PokemonList(
                  fetchUrl: fetchUrl,
                  searchController: _searchController,
                ),
              ),
            ],
          ),
          Positioned(
            top: 200,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypeNav(name: 'GRASS', onTypeSelected: _onTypeSelected),
                TypeNav(name: 'ICE', onTypeSelected: _onTypeSelected),
                TypeNav(name: 'FIRE', onTypeSelected: _onTypeSelected),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
