import 'dart:convert';
import 'package:http/http.dart' as http;

class api_Data{

  final String fetchUrl;
  api_Data(this.fetchUrl);


  Future getData() async{

    final  url = Uri.parse(fetchUrl);
    http.Response response = await http.get(url);

    String data = response.body;
    return jsonDecode(data);
  }
}