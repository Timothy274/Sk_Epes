import 'package:flutter/material.dart';

class User_Kasir extends StatefulWidget {
  const User_Kasir({ Key key }) : super(key: key);

  @override
  _User_KasirState createState() => _User_KasirState();
}

class _User_KasirState extends State<User_Kasir> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kios Epes'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: TextField(
          textAlign: TextAlign.center,
          // controller: search,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.qr_code_scanner, color: Colors.black,),
            suffixIcon: Icon(Icons.search, color: Colors.black),
            hintStyle: new TextStyle(color: Colors.black38),
            hintText: "Search"
          ),
        ),    
      )
    );
  }
}