import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class List_Onprogress extends StatefulWidget {
  const List_Onprogress({Key key}) : super(key: key);

  @override
  _List_OnprogressState createState() => _List_OnprogressState();
}

class _List_OnprogressState extends State<List_Onprogress> {
  Future<List> getdataPengiriman() async {
    final response = await http
        .get(Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/get_pengiriman_only_proses.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('List Pengiriman'),
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
              flex: 8,
              child: Container(
                child: FutureBuilder<List>(
                  future: getdataPengiriman(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              return new Container(
                                padding: const EdgeInsets.all(10.0),
                                child: new GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(new MaterialPageRoute(
                                    //     builder: (BuildContext context) => new on_going_detail(
                                    //           id_pegawai: snapshot.data[i]['id_pegawai'],
                                    //           id_pengiriman: snapshot.data[i]['id_pengiriman'],
                                    //           nama_pegawai: snapshot.data[i]['nama_pegawai'],
                                    //           tanggal: snapshot.data[i]['tanggal'],
                                    //           waktu: snapshot.data[i]['waktu'],
                                    //           total: int.parse(snapshot.data[i]['total']),
                                    //           kembalian: int.parse(snapshot.data[i]['kembalian']),
                                    //           modal: int.parse(snapshot.data[i]['modal']),
                                    //           id_user: snapshot.data[i]['id_user'],
                                    //         )));
                                  },
                                  child: new Card(
                                      child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: new ListTile(
                                            title: new Text(
                                              snapshot.data[i]['nama_pegawai'],
                                              style: TextStyle(fontSize: 25.0, color: Colors.black),
                                            ),
                                            subtitle: new Text(
                                              "Waktu : ${snapshot.data[i]['waktu']}",
                                              style: TextStyle(fontSize: 20.0, color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   margin: const EdgeInsets.only(right: 20.0),
                                        //   child: Checkbox(
                                        //     value: _selectedId
                                        //         .contains(snapshot.data[i]['id_pemesanan']),
                                        //     onChanged: (bool selected) {
                                        //       _onCategorySelectedonQueue(
                                        //         selected,
                                        //         (snapshot.data[i]['id_pemesanan']),
                                        //       );
                                        //     },
                                        //   ),
                                        //   alignment: Alignment.centerRight,
                                        // ),
                                      ],
                                    ),
                                  )),
                                ),
                              );
                            },
                          )
                        : new Center(
                            child: new CircularProgressIndicator(),
                          );
                    ;
                  },
                ),
              )),
        ],
      )),
    );
  }
}
