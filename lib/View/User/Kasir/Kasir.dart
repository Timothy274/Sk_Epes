import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/View/User/Kasir/Kasir_lanjutan.dart';

class User_Kasir extends StatefulWidget {
  const User_Kasir({Key key}) : super(key: key);

  @override
  _User_KasirState createState() => _User_KasirState();
}

class _User_KasirState extends State<User_Kasir> {
  List<DataBarang> _dataBarang = [];
  List<int> nilai_harga = [];
  List<int> nilai_awal = [];
  List<int> nilai_awal_harga = [];
  List<DataBarang> _filtered = [];
  List<DataBarang> _null_filtered = [];
  List<DataBarang> kirim_data = [];

  TextEditingController search = new TextEditingController();

  void initState() {
    super.initState();
    getData();
  }

  void _alterfilter(String query) {
    List<DataBarang> dummySearchList = [];
    dummySearchList.addAll(_filtered);
    if (query.isNotEmpty) {
      List<DataBarang> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.Nama.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filtered.clear();
        _filtered.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filtered.clear();
        _filtered.addAll(_null_filtered);
      });
    }
  }

  Future<List> getData() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/juljol/get_barang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _filtered.addAll(_dataBarang);
      _null_filtered.addAll(_dataBarang);
      _dataBarang.forEach((DataBarang) {
        nilai_awal.add(DataBarang.nilai_awal);
        nilai_awal_harga.add(DataBarang.nilai_awal);
        nilai_harga.add(DataBarang.Harga);
      });
    });
    return responseJson;
  }

  void add(nilai_awal, i, harga_awal) {
    setState(() {
      // int harga = int.parse(harga_awal.toString());
      // int total = int.parse(nilai_awal.toString());
      nilai_awal++;
      harga_awal = harga_awal * nilai_awal;
      for (int a = 0; a < _filtered.length; a++) {
        if (_filtered[a].id_barang == i) {
          _filtered[a].nilai_awal = nilai_awal;
          _filtered[a].Harga = harga_awal;
        }
      }
    });
  }

  void minus(nilai_awal, i, harga_awal) {
    setState(() {
      if (nilai_awal != 0) {
        nilai_awal--;
        harga_awal = harga_awal * nilai_awal;
        for (int a = 0; a < _filtered.length; a++) {
          if (_filtered[a].id_barang == i) {
            _filtered[a].nilai_awal = nilai_awal;
            _filtered[a].Harga = harga_awal;
          }
        }
      }
    });
  }

  void confirmation() {
    for (int a = 0; a < _filtered.length; a++) {
      if (_filtered[a].nilai_awal != 0) {
        kirim_data.add(_filtered[a]);
      }
    }
    if (kirim_data.isEmpty) {
      _showDialogPilihan();
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => User_kasir_Lanjutan(
                    data: kirim_data,
                  )));
    }
  }

  void _showDialogPilihan() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Data kosong"),
          content: new Text(
              "Mohon periksa kembali data yang anda masukkan, pastikan sudah memasukkan semua data yang dibutuhkan"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kios Epes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextField(
                textAlign: TextAlign.left,
                controller: search,
                onChanged: (value) {
                  _alterfilter(value);
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
                  margin: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
                  child: ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      return Container(
                          // padding: const EdgeInsets.all(10.0),
                          child: new Card(
                              child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              leading: Icon(Icons.book),
                              title: new Text(_filtered[i].Nama),
                              subtitle: Text(_filtered[i].Harga_Tetap.toString()),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new IconButton(
                                        icon: const Icon(Icons.remove),
                                        // iconSize: 50,
                                        onPressed: () => minus(_filtered[i].nilai_awal,
                                            _filtered[i].id_barang, _filtered[i].Harga_Tetap)),
                                    new Container(
                                      // margin: const EdgeInsets.only(
                                      //     left: 10, right: 10),
                                      child: Text(_filtered[i].nilai_awal.toString(),
                                          style: new TextStyle(fontSize: 20.0)),
                                    ),
                                    new IconButton(
                                        icon: const Icon(Icons.add),
                                        // iconSize: 50,
                                        onPressed: () => add(_filtered[i].nilai_awal,
                                            _filtered[i].id_barang, _filtered[i].Harga_Tetap)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Text("Rp." + _filtered[i].Harga.toString()),
                              )
                            ],
                          )
                        ],
                      )));
                    },
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      confirmation();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        Text(
                          "Keranjang",
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
