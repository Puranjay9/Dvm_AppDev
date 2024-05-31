import 'dart:convert';

import 'package:dvmapp/api_data.dart';
import 'package:dvmapp/box.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonList extends StatefulWidget {
  final String fetchUrl;
  final TextEditingController searchController;

  const PokemonList({Key? key, required this.fetchUrl, required this.searchController}) : super(key: key);

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late Future _futureData;
  List _allPokemons = [];
  List _filteredPokemons = [];

  Future<List<dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(widget.fetchUrl);

    if (cachedData != null) {
      return json.decode(cachedData);
    } else {
      api_Data apiData = api_Data(widget.fetchUrl);
      final data = await apiData.getData();
      if (data != null) {
        if (widget.fetchUrl == 'https://pokeapi.co/api/v2/pokemon/') {
          await prefs.setString(widget.fetchUrl, json.encode(data['results']));
          return (data['results'] as List<dynamic>);
        } else if (data.containsKey('pokemon')) {
          await prefs.setString(widget.fetchUrl, jsonEncode(data['pokemon']));
          return (data['pokemon'] as List<dynamic>).map((entry) {
            final pokemon = entry['pokemon'];
            if (pokemon != null && pokemon['name'] != null && pokemon['url'] != null) {
              return {'name': pokemon['name'], 'url': pokemon['url']};
            } else {
              return null;
            }
          }).where((pokemon) => pokemon != null).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    }
  }





  void _filterPokemons() {
    final query = widget.searchController.text.toLowerCase();
    setState(() {
      _filteredPokemons = _allPokemons.where((pokemon) {
        final name = pokemon['name'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
    _futureData.then((data) {
      setState(() {
        _allPokemons = data;
        _filteredPokemons = List.from(_allPokemons);
      });
    });
    widget.searchController.addListener(_filterPokemons);
  }


  @override
  void dispose() {
    widget.searchController.removeListener(_filterPokemons);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PokemonList oldWidget) {
    if (oldWidget.fetchUrl != widget.fetchUrl) {
      _futureData = fetchData();
      _futureData.then((data) {
        setState(() {
          _allPokemons = data;
          _filteredPokemons = data;
        });
      });
      widget.searchController.addListener(_filterPokemons);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(child: Text('No data found'));
        } else {
          return ListView.builder(
            itemCount: _filteredPokemons.length,
            itemBuilder: (context, index) {
              var pokemon = _filteredPokemons[index];
              var url = pokemon['url'];
              var name = pokemon['name'];
              return Box(
                index: index,
                url: url,
                name: name,
              );
            },
          );
        }
      },
    );
  }
}
