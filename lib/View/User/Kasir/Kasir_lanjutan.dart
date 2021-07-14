import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/Model/DataPegawai.dart';
import 'package:jiffy/jiffy.dart';

import '../Home.dart';

class User_kasir_Lanjutan extends StatefulWidget {
  final List<DataBarang> data;
  final String alamat, pegawai, catatan;
  const User_kasir_Lanjutan({Key key, this.data, this.alamat, this.pegawai, this.catatan})
      : super(key: key);

  @override
  _User_kasir_LanjutanState createState() => _User_kasir_LanjutanState();
}

class _User_kasir_LanjutanState extends State<User_kasir_Lanjutan> {
  List _pekerja = [];
  List<DataPegawai> _caripekerja = [];
  String nama_pegawai = "";
  int total_hitung = 0;
  int kembalian_hitung = 0;
  int modal_hitung = 0;

  var tahun = Jiffy().format("yyyy-MM-dd");
  var waktu = Jiffy().format("HH:mm:SS");
  var year = Jiffy().format("yyyy");
  var bulan = Jiffy().format("MM");
  var tanggal = Jiffy().format("dd");
  var jam = Jiffy().format("HH");
  var menit = Jiffy().format("mm");
  var detik = Jiffy().format("SS");

  void initState() {
    super.initState();
    getSWData();
    total();
  }

  Future<String> getSWData() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/juljol/get_pegawai_except_p.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _caripekerja.add(DataPegawai.fromJson(Data));
      }
      for (int a = 0; a < _caripekerja.length; a++) {
        if (widget.pegawai == _caripekerja[a].id_pegawai) {
          nama_pegawai = _caripekerja[a].nama_pegawai;
        }
      }
    });
  }

  void deactivate() {
    super.deactivate();
    widget.data.clear();
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
      int total_hitung_awal = 0;
      for (int a = 0; a < widget.data.length; a++) {
        total_hitung_awal = widget.data[a].Harga + total_hitung_awal;
      }
      total_hitung = total_hitung_awal;
      kembalian();
    });
  }

  void add(nilai_awal, i, harga_awal) {
    setState(() {
      // int harga = int.parse(harga_awal.toString());
      // int total = int.parse(nilai_awal.toString());
      nilai_awal++;
      harga_awal = harga_awal * nilai_awal;
      for (int a = 0; a < widget.data.length; a++) {
        if (widget.data[a].id_barang == i) {
          widget.data[a].nilai_awal = nilai_awal;
          widget.data[a].Harga = harga_awal;
        }
      }
      total();
      kembalian();
    });
  }

  void minus(nilai_awal, i, harga_awal) {
    setState(() {
      if (nilai_awal != 0) {
        nilai_awal--;
        harga_awal = harga_awal * nilai_awal;
        for (int a = 0; a < widget.data.length; a++) {
          if (widget.data[a].id_barang == i) {
            widget.data[a].nilai_awal = nilai_awal;
            widget.data[a].Harga = harga_awal;
          }
        }
        total();
        kembalian();
      }
    });
  }

  void kirim() {
    String id;
    id = tanggal + bulan + year + jam + menit + detik + widget.alamat + widget.pegawai;
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/add_pesanan.php"));
    http.post(url, body: {
      "id_pemesanan": id,
      "alamat": widget.alamat,
      "id_pegawai": widget.pegawai,
      "nama_pegawai": nama_pegawai,
      "tanggal": tahun,
      "total": total_hitung.toString(),
      "kembalian": kembalian_hitung.toString(),
      "modal": modal_hitung.toString(),
      "catatan": widget.catatan,
    });
  }

  void kirim_detail() {
    String id;
    id = tanggal + bulan + year + jam + menit + detik + widget.alamat + widget.pegawai;
    for (int a = 0; a < widget.data.length; a++) {
      var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/add_pesanan_detail.php"));
      http.post(url, body: {
        "id_pemesanan": id,
        "id_barang": widget.data[a].id_barang,
        "nama_barang": widget.data[a].Nama,
        "jumlah": widget.data[a].nilai_awal.toString(),
        "harga": widget.data[a].Harga.toString()
      });
    }
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
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.blue, width: 2.0)),
              child: Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.alamat,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      nama_pegawai,
                      style: TextStyle(fontSize: 18),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => _accDialog(context),
                              barrierDismissible: false,
                            );
                          },
                          child: Text(
                            "Detail",
                            style: TextStyle(fontSize: 15),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 6,
              child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ListView.builder(
                    itemCount: widget.data.length,
                    itemBuilder: (context, i) {
                      return Container(
                          // padding: const EdgeInsets.all(10.0),
                          child: new Card(
                              child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              leading: Icon(Icons.book),
                              title: new Text(widget.data[i].Nama, style: TextStyle(fontSize: 18)),
                              subtitle: Text(widget.data[i].Harga_Tetap.toString(),
                                  style: TextStyle(fontSize: 13)),
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
                                        onPressed: () => minus(widget.data[i].nilai_awal,
                                            widget.data[i].id_barang, widget.data[i].Harga_Tetap)),
                                    new Container(
                                      // margin: const EdgeInsets.only(
                                      //     left: 10, right: 10),
                                      child: Text(widget.data[i].nilai_awal.toString(),
                                          style: new TextStyle(fontSize: 20.0)),
                                    ),
                                    new IconButton(
                                        icon: const Icon(Icons.add),
                                        // iconSize: 50,
                                        onPressed: () => add(widget.data[i].nilai_awal,
                                            widget.data[i].id_barang, widget.data[i].Harga_Tetap)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Text("Rp." + widget.data[i].Harga.toString()),
                              )
                            ],
                          )
                        ],
                      )));
                    },
                  ))),
          Expanded(
            flex: 2,
            child: Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.blue, width: 2.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Total',
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Kembalian',
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Modal',
                              style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        verticalDirection: VerticalDirection.down,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              total_hitung.toString(),
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              kembalian_hitung.toString(),
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              modal_hitung.toString(),
                              style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      kirim();
                      kirim_detail();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        Text(
                          "Order",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    )),
              )),
        ],
      ),
    );
  }

  Widget _accDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Detail'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAccInput(),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Cancel'),
        )
      ],
    );
  }

  Widget _buildAccInput() {
    return new Column(
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(top: 10),
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  'Alamat',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  ':',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  widget.alamat,
                  style: new TextStyle(fontSize: 15.0),
                ),
              ]),
              TableRow(children: [
                Text(
                  'Pegawai',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  ':',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  widget.pegawai,
                  style: new TextStyle(fontSize: 15.0),
                ),
              ]),
              TableRow(children: [
                Text(
                  'Catatan',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  ':',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  widget.catatan,
                  style: new TextStyle(fontSize: 15.0),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
