import 'package:dvmapp/api_data.dart';
import 'package:dvmapp/box.dart';
import 'package:dvmapp/type_nav.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future _futureData;
  TextEditingController _searchController = TextEditingController();
  List _allPokemons = [];
  List _filteredPokemons = [];

  Future fetchData() async {
    api_Data apiData = api_Data();
    var data = await apiData.getData();
    if (data == null) {
      return null;
    } else {
      return data['results'];
    }
  }

  void _filterPokemons(){
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredPokemons = _allPokemons.where((pokemon){
          final name = pokemon['name'].toLowerCase();
          return name.contains(query);
        }).toList();
      });
  }

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
    _futureData.then((data){
      setState(() {
        _allPokemons = data;
        _filteredPokemons = data;
      });
    });
    _searchController.addListener(_filterPokemons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            return Stack(
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
          style: const TextStyle(color:  Colors.white),
          ),
          ),
          ),
          Expanded(
          child: ListView.builder(
          itemCount: _filteredPokemons.length,
          itemBuilder: (context, index) {
          var pokemon = _filteredPokemons[index];
          var url = pokemon['url'];
          return Box(
          index: index,
          url: url,
          );
          },
          )
          ),
          ],
          ),
                const Positioned(
                    top: 200,
                    left: 0,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TypeNav(
                            name : 'GRASS'
                        ),
                        TypeNav(
                            name : 'ICE'
                        ),
                        TypeNav(
                            name : 'FIRE'
                        ),
                      ],
                    )
                )
              ],
            );
          }
        },
      ),
    );
  }
}
