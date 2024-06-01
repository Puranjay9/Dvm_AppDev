import 'package:flutter/material.dart';

class TypeNav extends StatelessWidget {
  final String name;
  final bool isTapped;
  final Function(String) onTap;

  const TypeNav({
    super.key,
    required this.name,
    required this.isTapped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => onTap(name),
            child: Container(
              width: isTapped ? 90 : 75,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                border: const Border(
                  top: BorderSide(color: Colors.white, width: 5),
                  right: BorderSide(color: Colors.white, width: 5),
                  bottom: BorderSide(color: Colors.white, width: 5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(6, 6),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w100,
                    fontFamily: 'Milord Book',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}