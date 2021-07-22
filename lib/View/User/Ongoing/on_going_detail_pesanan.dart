import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/Model/DataPesanan.dart';
import 'package:kios_epes/Model/DataPesanan_lengkap.dart';
import 'package:kios_epes/View/User/Home.dart';
import 'package:kios_epes/View/User/Progress/on_queue_detail_edit_alamat.dart';
import 'package:kios_epes/View/User/Progress/on_queue_detail_edit_pesanan.dart';

class on_going_detail_pesanan extends StatefulWidget {
  String id_pemesanan, alamat, tanggal, catatan;
  on_going_detail_pesanan({Key key, this.id_pemesanan, this.alamat, this.tanggal, this.catatan})
      : super(key: key);

  @override
  _on_going_detail_pesananState createState() => _on_going_detail_pesananState();
}

class _on_going_detail_pesananState extends State<on_going_detail_pesanan> {
  List<DataPesananLengkap> _dataPesanan = [];
  List<DataPesananLengkap> _dataPesananFiltered = [];
  List<DataBarang> _dataBarang = [];
  Map<String, int> array_barang = {};

  void initState() {
    super.initState();
    getData();
    getDataBarang();
  }

  Future<List<DataBarang>> getDataBarang() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Stok/get_barang.php"));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _dataBarang.forEach((DataBarang) {
        array_barang[DataBarang.id_barang] = DataBarang.nilai_awal;
      });
    });
  }

  Future<List> getData() async {
    final response = await http.get(
        Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_join_pesanan_detail.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPesanan.add(DataPesananLengkap.fromJson(Data));
      }
      for (int a = 0; a < _dataPesanan.length; a++) {
        if (_dataPesanan[a].id_pemesanan == widget.id_pemesanan) {
          _dataPesananFiltered.add(_dataPesanan[a]);
        }
      }
    });
  }

  void detail_barang() {
    for (var i = 0; i < _dataPesananFiltered.length; i++) {
      array_barang[_dataPesananFiltered[i].id_barang] = _dataPesananFiltered[i].jumlah;
    }
  }

  void _showDialogHapus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Hapus Data"),
          content: new Text("Apakah anda yakin ingin menghapus data berikut ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Hapus",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                hapus_pesanan();
                hapus_pesanan_detail();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void hapus_pesanan() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/delete_pesanan.php"));
    http.post(url, body: {
      "id_pemesanan": widget.id_pemesanan,
    });
  }

  void hapus_pesanan_detail() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/delete_pesanan_detail.php"));
    http.post(url, body: {
      "id_pemesanan": widget.id_pemesanan,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.blue, width: 2.0)),
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  child: Table(
                    columnWidths: {
                      1: FlexColumnWidth(0.2),
                    },
                    children: [
                      TableRow(children: [
                        Text(
                          'Alamat',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          widget.alamat,
                          style: new TextStyle(fontSize: 25.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Tanggal',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          widget.tanggal,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ]),
                    ],
                  ),
                ),
              )),
          Expanded(
            flex: 6,
            child: Container(
                margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none &&
                        snapshot.hasData == null) {
                      return Container();
                    }
                    return ListView.builder(
                      itemCount: _dataPesananFiltered.length,
                      itemBuilder: (context, i) {
                        return Container(
                            // padding: const EdgeInsets.all(10.0),
                            child: new Card(
                                child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: new Text(_dataPesananFiltered[i].nama_barang,
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                _dataPesananFiltered[i].jumlah.toString(),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        )));
                      },
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
