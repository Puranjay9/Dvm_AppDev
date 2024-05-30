import 'package:dvmapp/pokemon_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Description extends StatefulWidget {
  final index;
  final url;
  const Description({super.key , required this.index , required this.url});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {

  late Future _pokemonDescription;

  Future pokemonDescription() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('pokemon_description${widget.index}');

    if (cachedData != null) {
      return json.decode(cachedData);
    } else {
      Pokemon pokemon = Pokemon(widget.url);
      final pokemonData = await pokemon.getDescription(widget.index);
      if (pokemonData != null) {
        await prefs.setString('pokemon_description${widget.index}', json.encode(pokemonData));
      }
      return pokemonData;
    }
  }

  @override
  void initState() {
    _pokemonDescription = pokemonDescription();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Description oldWidget) {
    if(oldWidget.url != widget.url){
      _pokemonDescription = pokemonDescription();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _pokemonDescription,
        builder: (context , snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: Text('Loading...'));
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData) {
        return const Center(child: Text('No data found'));
      }else{
        String description = snapshot.data!.toString();
        return Text(description);
      }
      });
  }
}
