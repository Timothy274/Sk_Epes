import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/View/User/Home.dart';

class on_queue_detail_edit_pemesanan extends StatefulWidget {
  Map array_barang;
  String id_pemesanan;
  on_queue_detail_edit_pemesanan({Key key, this.array_barang, this.id_pemesanan}) : super(key: key);

  @override
  _on_queue_detail_edit_pemesananState createState() => _on_queue_detail_edit_pemesananState();
}

class _on_queue_detail_edit_pemesananState extends State<on_queue_detail_edit_pemesanan> {
  List<DataBarang> _data_pesanan = [];
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _filtered = [];
  List<DataBarang> _null_filtered = [];
  List<String> id_barang = [];
  List<String> nama = [];
  List<int> harga = [];
  List<int> stock = [];
  List<int> harga_tetap = [];
  List<String> nilai_awal = [];
  int total_hitung = 0;
  int kembalian_hitung = 0;
  int modal_hitung = 0;

  TextEditingController search = new TextEditingController();

  void initState() {
    super.initState();
    getData();
    total();
    // print(widget.array_barang.values);
  }

  void kembalian() {
    setState(() {
      if (total_hitung <= 10000) {
        kembalian_hitung = 10000;
      } else if (total_hitung <= 20000 && total_hitung > 10000) {
        kembalian_hitung = 20000;
      } else if (total_hitung <= 50000 && total_hitung > 20000) {
        kembalian_hitung = 50000;
      } else if (total_hitung <= 100000 && total_hitung > 50000) {
        kembalian_hitung = 100000;
      } else if (total_hitung <= 150000 && total_hitung > 100000) {
        kembalian_hitung = 150000;
      } else if (total_hitung <= 200000 && total_hitung > 150000) {
        kembalian_hitung = 200000;
      } else if (total_hitung <= 250000 && total_hitung > 200000) {
        kembalian_hitung = 250000;
      } else if (total_hitung <= 300000 && total_hitung > 250000) {
        kembalian_hitung = 300000;
      } else if (total_hitung <= 350000 && total_hitung > 300000) {
        kembalian_hitung = 350000;
      } else if (total_hitung <= 400000 && total_hitung > 350000) {
        kembalian_hitung = 400000;
      } else if (total_hitung <= 450000 && total_hitung > 400000) {
        kembalian_hitung = 450000;
      } else if (total_hitung <= 500000 && total_hitung > 450000) {
        kembalian_hitung = 500000;
      } else if (total_hitung <= 550000 && total_hitung > 500000) {
        kembalian_hitung = 550000;
      } else if (total_hitung <= 600000 && total_hitung > 550000) {
        kembalian_hitung = 600000;
      } else if (total_hitung <= 650000 && total_hitung > 600000) {
        kembalian_hitung = 650000;
      } else if (total_hitung <= 700000 && total_hitung > 650000) {
        kembalian_hitung = 700000;
      } else if (total_hitung <= 750000 && total_hitung > 700000) {
        kembalian_hitung = 750000;
      } else if (total_hitung <= 800000 && total_hitung > 750000) {
        kembalian_hitung = 800000;
      } else if (total_hitung <= 850000 && total_hitung > 800000) {
        kembalian_hitung = 850000;
      } else if (total_hitung <= 900000 && total_hitung > 850000) {
        kembalian_hitung = 900000;
      } else if (total_hitung <= 950000 && total_hitung > 900000) {
        kembalian_hitung = 950000;
      } else {
        kembalian_hitung = 0;
      }
      modal();
    });
  }

  void modal() {
    setState(() {
      modal_hitung = kembalian_hitung - total_hitung;
    });
  }

  void total() {
    setState(() {
      _data_pesanan.clear();
      for (int a = 0; a < _filtered.length; a++) {
        if (_filtered[a].nilai_awal != 0) {
          _data_pesanan.add(_filtered[a]);
        }
      }

      int total_hitung_awal = 0;
      for (int a = 0; a < _data_pesanan.length; a++) {
        total_hitung_awal = _data_pesanan[a].Harga + total_hitung_awal;
      }
      total_hitung = total_hitung_awal;
      kembalian();
    });
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
    int harga_awal;
    String num, harga_akhir;

    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Stok/get_barang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _dataBarang.forEach((DataBarang) {
        id_barang.add(DataBarang.id_barang);
        nama.add(DataBarang.Nama);
        harga.add(DataBarang.Harga);
        harga_tetap.add(DataBarang.Harga_Tetap);
        stock.add(DataBarang.Stock);
        nilai_awal.add(DataBarang.nilai_awal.toString());
      });

      for (int a = 0; a < nilai_awal.length; a++) {
        if (widget.array_barang[id_barang[a]] != 0) {
          int b = a + 1;
          harga_awal = _dataBarang[a].Harga * widget.array_barang[id_barang[a]];
          num = widget.array_barang[id_barang[a]].toString();
          harga.replaceRange(a, b, [harga_awal]);
          nilai_awal.replaceRange(a, b, [num]);
        } else {
          int b = a + 1;
          harga.replaceRange(a, b, [0]);
        }
      }

      for (int a = 0; a < id_barang.length; a++) {
        _filtered.add(DataBarang(
            id_barang: id_barang[a],
            Nama: nama[a],
            Harga: harga[a],
            Stock: stock[a],
            Harga_Tetap: _dataBarang[a].Harga,
            nilai_awal: int.parse(nilai_awal[a])));
      }
      _null_filtered.addAll(_filtered);
    });
    return responseJson;
  }

  void add(nilai_awal, i, harga_awal) {
    int stok_awal = 1;
    setState(() {
      nilai_awal++;
      harga_awal = harga_awal * nilai_awal;
      for (int a = 0; a < _filtered.length; a++) {
        if (_filtered[a].id_barang == i) {
          if (_filtered[a].Stock != 0) {
            _filtered[a].Stock = _filtered[a].Stock - stok_awal;
            _filtered[a].nilai_awal = nilai_awal;
            _filtered[a].Harga = harga_awal;
          } else {
            _showDialogErrorStok();
          }
        }
      }
    });
  }

  void minus(nilai_awal, i, harga_awal) {
    int stok_awal = 1;
    setState(() {
      if (nilai_awal != 0) {
        nilai_awal--;
        harga_awal = harga_awal * nilai_awal;
        for (int a = 0; a < _filtered.length; a++) {
          if (_filtered[a].id_barang == i) {
            _filtered[a].Stock = _filtered[a].Stock + stok_awal;
            _filtered[a].nilai_awal = nilai_awal;
            _filtered[a].Harga = harga_awal;
          }
        }
      }
    });
  }

  void confirmation() {
    int b = 0;
    for (int a = 0; a < _filtered.length; a++) {
      if (_filtered[a].nilai_awal != 0) {
        b = b + 1;
      }
    }
    if (b == 0) {
      _showDialogPilihan();
    } else {
      kirim();
      kirim_detail();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void kirim() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/update_pesanan.php"));
    http.post(url, body: {
      "id_pemesanan": widget.id_pemesanan,
      "total": total_hitung.toString(),
      "kembalian": kembalian_hitung.toString(),
      "modal": modal_hitung.toString(),
    });
  }

  void kirim_detail() {
    for (int a = 0; a < _filtered.length; a++) {
      // print(widget.id_pemesanan);
      // print(_filtered[a].id_barang);
      // print(_filtered[a].Nama);
      // print(_filtered[a].nilai_awal.toString());
      // print(_filtered[a].Harga.toString());
      // print("=====");
      var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/update_pesanan_detail.php"));
      http.post(url, body: {
        "id_pemesanan": widget.id_pemesanan,
        "id_barang": _filtered[a].id_barang,
        "nama_barang": _filtered[a].Nama,
        "jumlah": _filtered[a].nilai_awal.toString(),
        "harga": _filtered[a].Harga.toString(),
        "stok": _filtered[a].Stock.toString(),
      });
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

  void _showDialogErrorStok() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Stok Habis"),
          content:
              new Text("Mohon periksa kembali stok, mohon untuk menambah stok terlebih dahulu"),
          actions: <Widget>[
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
                textCapitalization: TextCapitalization.words,
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
                              leading: Icon(Icons.workspaces_filled),
                              title: new Text(_filtered[i].Nama),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Harga : ${_filtered[i].Harga_Tetap.toString()}",
                                  ),
                                  Text(
                                    "Stok : ${_filtered[i].Stock.toString()}",
                                  )
                                ],
                              ),
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
                      total();
                      confirmation();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        new Container(
                          width: 20.0,
                        ),
                        Text(
                          "Ubah Pesanan",
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
