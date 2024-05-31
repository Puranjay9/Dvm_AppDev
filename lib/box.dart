import 'package:dvmapp/description.dart';
import 'package:dvmapp/pokemon_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Box extends StatefulWidget {
  final index;
  final url;
  final name;

  const Box({
    super.key,
    required this.index,
    required this.url,
    required this.name,
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

  Future pokemon_details() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(widget.url);

    if (cachedData != null) {
      return json.decode(cachedData);
    } else {
      Pokemon pokemon = Pokemon(widget.url);
      final pokemonData = await pokemon.getData();
      if (pokemonData != null) {
        await prefs.setString(widget.url, json.encode(pokemonData));
      }
      return pokemonData;
    }
  }

  @override
  void initState() {
    _pokemon_Data = pokemon_details();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Box oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _pokemon_Data = pokemon_details();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _pokemon_Data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text(''));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            var data = snapshot.data!;
            var name = widget.name;
            var id = data['id'];
            var imgUrl =
                data['sprites']['other']['official-artwork']['front_default'];
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 30, right: 10, top: 20),
                      padding:
                          const EdgeInsets.only(left: 65, top: 40, right: 0),
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
                            '#${widget.index + 1}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'PT Sans',
                            ),
                          ),
                          Text(
                            name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'PT Sans',
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Image(
                                  image: AssetImage('assets/img/type1.png'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Image(
                                  image: AssetImage('assets/img/type2.png'),
                                ),
                              ),
                              GestureDetector(
                                onTap: WidgetVisibility,
                                child: Image.asset(
                                  _isWidgetVisible
                                      ? 'assets/img/back.png'
                                      : 'assets/img/des.png',
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
                          child: Container(
                            padding: const EdgeInsets.only(left: 70 , right: 10),
                            child: Description(index: id, url: widget.url),
                          )),
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
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Image(
                    image: NetworkImage(imgUrl),
                  ),
                )
              ],
            );
          }
        });
  }
}
