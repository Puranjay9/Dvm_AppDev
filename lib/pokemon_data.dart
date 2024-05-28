import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pokemon{

  String url ;
  Pokemon(this.url);

  // final int Id;
  // final String name;
  // final String imageUrl;
  // final String description;


  Future getData() async{
    Uri pokemonUri = Uri.parse(url);
    http.Response response = await http.get(pokemonUri);

    String response_data = response.body;
    var data = jsonDecode(response_data);
    return data;
  }

}