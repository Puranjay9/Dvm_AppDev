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
  String? _tappedTypeNav;
  String _searchQuery = '';

  void _onTypeSelected(String type) {
    setState(() {
      if (_tappedTypeNav == type) {
        _selectedType = 'default';
        _tappedTypeNav = null;
      } else {
        _selectedType = type.toLowerCase();
        _tappedTypeNav = type;
      }
    });
  }

  void _onSearch() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  String fetchingUrl() {
    switch (_selectedType) {
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
    return SafeArea(
      child: Scaffold(
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
                        fontWeight: FontWeight.w100,
                        fontFamily: 'Milord Book',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13 , bottom: 20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            width: 1.7, color: Colors.white),
                      ),
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                          color: Colors.white, fontSize: 20),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) {
                      _onSearch();
                    },
                  ),
                ),
                Expanded(
                  child: PokemonList(
                    fetchUrl: fetchUrl,
                    searchQuery: _searchQuery,
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
                  TypeNav(
                    name: 'GRASS',
                    isTapped: _tappedTypeNav == 'GRASS',
                    onTap: _onTypeSelected,
                  ),
                  TypeNav(
                    name: 'ICE',
                    isTapped: _tappedTypeNav == 'ICE',
                    onTap: _onTypeSelected,
                  ),
                  TypeNav(
                    name: 'FIRE',
                    isTapped: _tappedTypeNav == 'FIRE',
                    onTap: _onTypeSelected,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
