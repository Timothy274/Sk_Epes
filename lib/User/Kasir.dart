import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User_Kasir extends StatefulWidget {
  const User_Kasir({Key key}) : super(key: key);

  @override
  _User_KasirState createState() => _User_KasirState();
}

class _User_KasirState extends State<User_Kasir> {
  Future<List> getData() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/juljol/get_barang.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kios Epes'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  textAlign: TextAlign.center,
                  // controller: search,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.qr_code_scanner,
                      color: Colors.black,
                    ),
                    suffixIcon: Icon(Icons.search, color: Colors.black),
                    hintStyle: new TextStyle(color: Colors.black38),
                    hintText: "Search"
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
                child: FutureBuilder<List>(
                    future: getData(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? new ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Card(
                                        child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: ListTile(
                                            leading: Icon(Icons.book),
                                            title: new Text(
                                              snapshot.data[i]['Nama']
                                            ),
                                            subtitle: Text(
                                              snapshot.data[i]['Harga']
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right: 10),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  new IconButton(
                                                    icon: const Icon(Icons.remove), 
                                                    // iconSize: 50,
                                                    onPressed: (){}
                                                  ),
                                                  new Container(
                                                    // margin: const EdgeInsets.only(
                                                    //     left: 10, right: 10),
                                                    child: Text(snapshot.data[i]['nilai_awal'],
                                                        style: new TextStyle(
                                                            fontSize: 20.0)),
                                                  ),
                                                  new IconButton(
                                                    icon: const Icon(Icons.add), 
                                                    // iconSize: 50,
                                                    onPressed: (){}
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  )
                                );
                              },
                            )
                          : new Center(
                              child: new CircularProgressIndicator(),
                            );
                    }
                  ),
                )
              ),
              Container(
                child: Row(
                  children: [Container()],
                ),
              )
            ],
          ),
        ));
  }
}
