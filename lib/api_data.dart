import 'dart:convert';
import 'package:http/http.dart' as http;

class api_Data{

  var url = Uri.https('pokeapi.co', '/api/v2/pokemon/', {'offset': '0', 'limit': '1302'});
  Future getData() async{
    http.Response response = await http.get(url);

    String data = response.body;
    return jsonDecode(data);
  }

}