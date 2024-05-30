import 'dart:convert';
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

    String responseData = response.body;
    var data = jsonDecode(responseData);
    return data;
  }

  Future getDescription(int index) async{
    final String url = 'https://pokeapi.co/api/v2/pokemon-species/$index/';
    Uri desUri = Uri.parse(url);
    http.Response response = await http.get(desUri);

    String responseData = response.body;
    var data =jsonDecode(responseData);
    var description = data['flavor_text_entries'][0]['flavor_text'];
    return description;
    // flavor_text_entries[0].flavor_text
  }

}