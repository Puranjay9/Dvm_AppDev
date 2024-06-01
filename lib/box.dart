import 'package:dvmapp/description.dart';
import 'package:dvmapp/pokemon_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class Box extends StatefulWidget {
  final String url;
  final String name;

  const Box({
    Key? key,
    required this.url,
    required this.name,
  }) : super(key: key);

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  bool _isWidgetVisible = false;
  late Future _pokemonData;
  int? id;
  String? imgUrl;

  void _toggleWidgetVisibility() {
    setState(() {
      _isWidgetVisible = !_isWidgetVisible;
    });
  }

  Future _pokemonDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(widget.url);

    if (cachedData != null) {
      var pokemonData = json.decode(cachedData);
      if (mounted) {
        setState(() {
          id = pokemonData['id'];
          imgUrl = pokemonData['sprites']['other']['official-artwork']['front_default'];
        });
      }
      return pokemonData;
    } else {
      Pokemon pokemon = Pokemon(widget.url);
      final pokemonData = await pokemon.getData();
      if (pokemonData != null) {
        await prefs.setString(widget.url, json.encode(pokemonData));
        if (mounted) {
          setState(() {
            id = pokemonData['id'];
            imgUrl = pokemonData['sprites']['other']['official-artwork']['front_default'];
          });
        }
      }
      return pokemonData;
    }
  }

  @override
  void initState() {
    super.initState();
    _pokemonData = _pokemonDetails();
  }

  @override
  void didUpdateWidget(covariant Box oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {
        id = null;
        imgUrl = null;
        _pokemonData = _pokemonDetails();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pokemonData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 150,
            child: const Center(
              child: Text('Loading...' , style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        } else {
          var name = widget.name;

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: const EdgeInsets.only(left: 65, top: 40, right: 0),
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
                          id != null ? '#$id' : '',
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
                              onTap: _toggleWidgetVisibility,
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
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/page.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 70, right: 10),
                        child: Description(index: id, url: widget.url),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
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
              if (imgUrl != null)
                Positioned(
                  top: 20,
                  right: 0,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: CachedNetworkImage(
                    imageUrl: imgUrl!,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}
