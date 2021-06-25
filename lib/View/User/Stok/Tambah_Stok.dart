import 'package:flutter/material.dart';

class User_Add_Stock extends StatefulWidget {
  const User_Add_Stock({Key key}) : super(key: key);

  @override
  _User_Add_StockState createState() => _User_Add_StockState();
}

class _User_Add_StockState extends State<User_Add_Stock> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  children: [
                    TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        // controller: alamat,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(labelText: "Alamat"),
                        validator: (val) => val.length == 1 ? "Masukkan alamat" : null),
                    new Container(
                      height: 50.0,
                    ),
                    TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        // controller: alamat,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(labelText: "Alamat"),
                        validator: (val) => val.length == 1 ? "Masukkan alamat" : null),
                    new Container(
                      height: 50.0,
                    ),
                    TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        // controller: alamat,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(labelText: "Alamat"),
                        validator: (val) => val.length == 1 ? "Masukkan alamat" : null),
                    new Container(
                      height: 50.0,
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      // confirmation();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new User_Add_Stock()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          "Tambah Item",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    )),
              ))
        ],
      ),
    );
  }
}
