import 'package:flutter/material.dart';

class TypeNav extends StatefulWidget {
  final String name;
  final Function(String) onTypeSelected;

  const TypeNav({super.key, required this.name, required this.onTypeSelected});

  @override
  State<TypeNav> createState() => _TypeNavState();
}

class _TypeNavState extends State<TypeNav> {
  bool tap = false;

  void _onTapAction() {
    setState(() {
      tap = !tap;
      if(tap){
        widget.onTypeSelected(widget.name);
      }else{
        widget.onTypeSelected('default');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: _onTapAction,
            child: Container(
              width: tap ? 90 : 75,
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
                  widget.name,
                  style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w100 , fontFamily: 'Milord Book'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
