import 'package:flutter/material.dart';

class TypeNav extends StatefulWidget {
  final name ;
  const TypeNav({super.key , this.name});

  @override
  State<TypeNav> createState() => _TypeNavState();
}

class _TypeNavState extends State<TypeNav> {

  bool tap = false;
  void _onTapAction(){
    setState(() {
      tap = !tap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: _onTapAction,
            child: Container(
              width: tap? 75 :90,
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
            ),]
              ),
              child:  Center(child :Text( widget.name,
               style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w900 ),
              ),
            ),),
          )
        )
      ],
    );
  }
}
