import 'package:dvmapp/pokemon_data.dart';
import 'package:flutter/material.dart';

class Box extends StatefulWidget {
  final index;
  final url;

  const Box({super.key,
             required this.index,
             required this.url,
  });


  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  bool _isWidgetVisible = false;
  late Future _pokemon_Data;

  void WidgetVisibility() {
    setState(() {
      _isWidgetVisible = !_isWidgetVisible;
    });
  }

  Future pokemon_details() async{
      Pokemon pokemon = Pokemon(widget.url);
      final pokemon_data = await pokemon.getData();
      return pokemon_data;
    //   final String pokemon_name =  pokemon_data['species']['name'];
  }

  @override
  void initState() {
    _pokemon_Data = pokemon_details();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Box oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.url != widget.url){
      _pokemon_Data = pokemon_details();
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(future: _pokemon_Data,
          builder: (context , snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            }else{
              var data = snapshot.data!;
              var name = data['species']['name'];
              var index = data['id'].toString();
              var imgUrl = data['sprites']['other']['official-artwork']['front_default'];
               return Stack(
                 children: [
               Column(
               children: [
               Container(
               margin: const EdgeInsets.only(left: 30, right: 10, top: 20),
            padding: const EdgeInsets.only(left: 65, top: 40 , right: 0),
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: const BoxDecoration(
            image: DecorationImage(
            image: AssetImage('assets/img/page.png'),
            fit: BoxFit.fill,
            ),
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            '#$index' ,
            style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            ),
            ),
            Text(
            name.toUpperCase(),
            style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            ),
            ),
            Row(
            children: [
            GestureDetector(
            onTap: WidgetVisibility,
            child: Image.asset('assets/img/des.png',
            width: 35,

            ),
            ),
            ],
            ),
            ],
            ),
            ),


            Visibility(
            visible: _isWidgetVisible,
            child: Container(
            margin: const EdgeInsets.only(left: 30, right: 10),
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: const BoxDecoration(
            image: DecorationImage(
            image: AssetImage('assets/img/page.png'),
            fit: BoxFit.fill,
            ),
            ),
            child: const Text(''),
            ),
            ),



            Container(
            margin: const EdgeInsets.only(left: 30, right: 10),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
            image: DecorationImage(
            image: AssetImage('assets/img/tear.png'),
            fit: BoxFit.fill,
            ),
            ),
            child: const Text(''),
            ),
            ],
            ),
                   
            Positioned(
                top: 20,
                right: 0,
                width: MediaQuery.of(context).size.width/2.5,
                child: Expanded(
                  child: Image(
                    image: NetworkImage(imgUrl),
                  ),
                )  ,
            )
                 ],
               );
            }
          });

  }
}
