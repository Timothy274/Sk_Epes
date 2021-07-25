import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataHutang.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:kios_epes/Model/DataPesanan.dart';
import 'package:kios_epes/Model/DataPesananSelesai.dart';
import 'package:kios_epes/View/User/Kasir/Kasir.dart';
import 'package:http/http.dart' as http;

class TabHome extends StatefulWidget {
  @override
  _TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  final _formKey = new GlobalKey<FormState>();

  final alamat = TextEditingController();
  final catatan = TextEditingController();
  List<DataPesanan> _dataPesanan = [];
  List<DataPesananSelesai> _dataPengirimanSelesai = [];
  List<DataHutang> _dataHutang = [];
  List<DataPengiriman> _dataPengiriman = [];
  void dispose() {
// Clean up the controller when the widget is disposed.
    alamat.dispose();
    catatan.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    getData();
    getdataPengirimanSelesai();
    getdataPesananHutang();
    getdataPengiriman();
    // getSWData();
    // getTahun();
  }

  void _showDialogErrorAlamat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alamat Error"),
          content: new Text(
              "Alamat yang anda masukkan sudah pernah dimasukkan kedalam antrian, apakah anda yakin ingin memasukkan pesanan ini lagi ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Lanjutkan"),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new User_Kasir(
                          alamat: alamat.text,
                          catatan: catatan.text,
                        )));
              },
            ),
          ],
        );
      },
    );
  }

  Future<List> getData() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_antrian.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPesanan.add(DataPesanan.fromJson(Data));
      }
    });
  }

  Future<List> getdataPengiriman() async {
    final response = await http
        .get(Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/get_pengiriman_only_proses.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPengiriman.add(DataPengiriman.fromJson(Data));
      }
    });
  }

  Future<List> getdataPengirimanSelesai() async {
    final response = await http.get(Uri.parse(
        "http://timothy.buzz/kios_epes/Selesai/get_pesanan_join_pengiriman_only_finish.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPengirimanSelesai.add(DataPesananSelesai.fromJson(Data));
      }
    });
  }

  Future<List> getdataPesananHutang() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Hutang/get_hutang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataHutang.add(DataHutang.fromJson(Data));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Antrian Pesanan",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _dataPesanan.length.toString(),
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ],
                      ))),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sedang Pengiriman",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _dataPengiriman.length.toString(),
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ],
                      )))
            ],
          ),
          Row(
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Pesanan Selesai",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _dataPengirimanSelesai.length.toString(),
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ],
                      ))),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Hutang",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _dataHutang.length.toString(),
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ],
                      )))
            ],
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(76, 177, 247, 1)),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    )),
                margin: const EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
                child: Column(
                  children: [
                    new Container(
                      height: 20.0,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: alamat,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(labelText: "Alamat"),
                      validator: (val1) {
                        if (val1 == null || val1.isEmpty) {
                          return "Masukkan Alamat";
                        }
                        return null;
                      },
                    ),
                    new Container(
                      height: 50.0,
                    ),
                    TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: catatan,
                        maxLength: 100,
                        maxLines: 4,
                        decoration: new InputDecoration(labelText: "Catatan")),
                    new Container(
                      height: 50.0,
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        alignment: Alignment(-1.0, -1.0),
                        child: new SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              color: Color.fromRGBO(76, 177, 247, 1),
                              onPressed: () {
                                int t = 0;
                                if (_formKey.currentState.validate()) {
                                  for (int a = 0; a < _dataPesanan.length; a++) {
                                    String alamat_data = _dataPesanan[a].alamat.replaceAll(" ", "");
                                    String alamatText = alamat.text.replaceAll(" ", "");

                                    if (alamat_data.toLowerCase() == alamatText.toLowerCase()) {
                                      t = t + 1;
                                    }
                                  }
                                  if (t == 0) {
                                    Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context) => new User_Kasir(
                                              alamat: alamat.text,
                                              catatan: catatan.text,
                                            )));
                                  } else {
                                    _showDialogErrorAlamat();
                                  }
                                  // if (_formKey.currentState.validate()) {
                                  //   Navigator.of(context).push(new MaterialPageRoute(
                                  //       builder: (BuildContext context) => new User_Kasir(
                                  //             alamat: alamat.text,
                                  //             catatan: catatan.text,
                                  //           )));
                                  // }
                                }
                              },
                              child: const Text('Buat Order',
                                  style: TextStyle(fontSize: 20, color: Colors.black))),
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
