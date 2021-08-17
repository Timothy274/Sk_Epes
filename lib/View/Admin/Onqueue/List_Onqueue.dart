import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataPesanan.dart';
import 'package:kios_epes/View/Admin/Onqueue/Detail_Onqueue.dart';
import 'package:http/http.dart' as http;

class List_Onqueue extends StatefulWidget {
  const List_Onqueue({Key key}) : super(key: key);

  @override
  _List_OnqueueState createState() => _List_OnqueueState();
}

class _List_OnqueueState extends State<List_Onqueue> {
  List _selectedId = [];
  List<DataPesanan> _dataPesanan = [];
  List<DataPesanan> _filteredPesanan = [];
  List<DataPesanan> _null_filteredPesanan = [];
  TextEditingController search_pesanan = new TextEditingController();

  void initState() {
    super.initState();
    getData();
  }

  Future<List> getData() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_antrian.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPesanan.add(DataPesanan.fromJson(Data));
      }
      _filteredPesanan.addAll(_dataPesanan);
      _null_filteredPesanan.addAll(_dataPesanan);
    });
  }

  void _alterfilterpesanan(String query) {
    query = query.toLowerCase();
    List<DataPesanan> dummySearchList = [];
    dummySearchList.addAll(_null_filteredPesanan);
    if (query.isNotEmpty) {
      List<DataPesanan> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.alamat.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filteredPesanan.clear();
        _filteredPesanan.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filteredPesanan.clear();
        _filteredPesanan.addAll(_null_filteredPesanan);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('List Antrian'),
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child: TextField(
                textAlign: TextAlign.left,
                controller: search_pesanan,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _alterfilterpesanan(value);
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: Colors.white,
                    // prefixIcon: Icon(
                    //   Icons.qr_code_scanner,
                    //   color: Colors.black,
                    // ),
                    suffixIcon: Icon(Icons.search, color: Colors.black),
                    hintStyle: new TextStyle(color: Colors.black38),
                    hintText: "Search"),
              ),
            ),
          ),
          Expanded(
              flex: 8,
              child: Container(
                  child: ListView.builder(
                itemCount: _filteredPesanan.length,
                itemBuilder: (context, i) {
                  return new Container(
                    padding: const EdgeInsets.all(10.0),
                    child: new GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(new MaterialPageRoute(
                        //     builder: (BuildContext context) => new Detail_Onqueue(
                        //           id_pemesanan: _filteredPesanan[i].id_pemesanan,
                        //           alamat: _filteredPesanan[i].alamat,
                        //           tanggal: _filteredPesanan[i].tanggal,
                        //           catatan: _filteredPesanan[i].catatan,
                        //           total: _filteredPesanan[i].total,
                        //           modal: _filteredPesanan[i].modal,
                        //           kembalian: _filteredPesanan[i].kembalian,
                        //           kasir: _filteredPesanan[i].id_user,
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
                                  _filteredPesanan[i].alamat,
                                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                                ),
                                // subtitle: new Text(
                                //   "Pengantar : ${snapshot.data[i]['nama_pegawai']}",
                                //   style: TextStyle(fontSize: 20.0, color: Colors.black),
                                // ),
                              ),
                            ),
                            // Container(
                            //   margin: const EdgeInsets.only(right: 20.0),
                            //   child: Checkbox(
                            //     value: _selectedId.contains(_filteredPesanan[i].id_pemesanan),
                            //     onChanged: (bool selected) {
                            //       _onCategorySelectedonQueue(
                            //         selected,
                            //         (_filteredPesanan[i].id_pemesanan),
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
              ))),
          // Expanded(
          //     flex: 1,
          //     child: Container(
          //       width: double.infinity,
          //       child: ElevatedButton(
          //           onPressed: () {
          //             // if (_selectedId.isEmpty) {
          //             //   _showDialogerror();
          //             // } else {
          //             //   Navigator.of(context).push(new MaterialPageRoute(
          //             //       builder: (BuildContext context) => new On_Queue_Kirim(
          //             //             list: _selectedId,
          //             //           )));
          //             // }
          //           },
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(
          //                 Icons.edit,
          //                 color: Colors.white,
          //               ),
          //               new Container(
          //                 width: 20.0,
          //               ),
          //               Text(
          //                 "Kirim Pesanan",
          //                 style: TextStyle(fontSize: 15),
          //               )
          //             ],
          //           )),
          //     ))
        ],
      )),
    );
  }
}
