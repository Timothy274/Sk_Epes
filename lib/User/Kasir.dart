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
        await http.get(Uri.parse("http://timothy.buzz/juljol/get.php"));
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
                      hintText: "Search"),
                ),
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(top: 50, left: 20.0, right: 20.0),
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
                                        child: Container(
                                            child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: new ListTile(
                                            title: new Text(
                                              snapshot.data[i]['Alamat'],
                                              style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: Colors.black),
                                            ),
                                            // subtitle: new Text(
                                            //   "Pengantar : ${snapshot.data[i]['NamaPekerja']}",
                                            //   style: TextStyle(
                                            //       fontSize: 20.0,
                                            //       color: Colors.black),
                                            // ),
                                          ),
                                        ),
                                      ],
                                    ))));
                              },
                            )
                          : new Center(
                              child: new CircularProgressIndicator(),
                            );
                    }),
              )),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            new Container(
                              width: 40,
                              height: 40,
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                heroTag: null,
                                onPressed: () {},
                                child: new Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            new Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text("1",
                                  style: new TextStyle(fontSize: 35.0)),
                            ),
                            new Container(
                              width: 40,
                              height: 40,
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                heroTag: null,
                                onPressed: () {},
                                child:
                                    new Icon(Icons.remove, color: Colors.black),
                                backgroundColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [Container()],
                        )
                      ],
                    ),
                  ),
                ],
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
