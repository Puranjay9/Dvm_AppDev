import 'package:dvmapp/main.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    _navigateHome();
  }

  _navigateHome() async {
    await Future.delayed(const Duration(milliseconds: 2500) , (){});
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => MyHomePage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: const Text('POKEDEX' , style: TextStyle(color: Colors.white , fontSize: 30),),
        ),
      ),
    );
  }
}