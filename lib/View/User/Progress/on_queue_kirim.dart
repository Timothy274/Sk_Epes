import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataPegawai.dart';
import 'dart:async';
import 'dart:convert';
import 'package:jiffy/jiffy.dart';

import 'package:kios_epes/Model/DataPesanan.dart';
import 'package:kios_epes/View/User/Home.dart';

class On_Queue_Kirim extends StatefulWidget {
  List list;
  On_Queue_Kirim({Key key, this.list}) : super(key: key);

  @override
  _On_Queue_KirimState createState() => _On_Queue_KirimState();
}

class _On_Queue_KirimState extends State<On_Queue_Kirim> {
  List<DataPesanan> _dataPesanan = [];
  List<DataPesanan> _dataPesananFiltered = [];
  List<DataPegawai> _dataPekerja = [];
  String _mySelection2;
  String id;
  int total = 0;
  int kembalian = 0;
  int modal = 0;

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
    getDataPesanan();
    getDataPegawai();
  }

  void deactivate() {
    super.deactivate();
    widget.list.clear();
  }

  Future<List<DataPesanan>> getDataPesanan() async {
    final response =
        await http.get(Uri.parse("https://timothy.buzz/kios_epes/Pesanan/get_pesanan.php"));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataPesanan.add(DataPesanan.fromJson(Data));
      }
      for (int a = 0; a < _dataPesanan.length; a++) {
        for (int b = 0; b < widget.list.length; b++) {
          if (_dataPesanan[a].id_pemesanan == widget.list[b]) {
            _dataPesananFiltered.add(_dataPesanan[a]);
          }
        }
      }
      for (int a = 0; a < _dataPesananFiltered.length; a++) {
        total = _dataPesananFiltered[a].total + total;
        kembalian = _dataPesananFiltered[a].kembalian + kembalian;
        modal = _dataPesananFiltered[a].modal + modal;
      }
    });
  }

  Future<List> getDataPegawai() async {
    final response =
        await http.get(Uri.parse("https://timothy.buzz/kios_epes/Pegawai/get_pegawai.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPekerja.add(DataPegawai.fromJson(Data));
      }
    });
  }

  void id_pemesanan() {
    int num = total + kembalian + modal + _dataPesananFiltered.length;
    id = tanggal + bulan + year + jam + menit + detik + num.toString();
  }

  void kirim() {
    String nama_pegawai;
    for (int a = 0; a < _dataPekerja.length; a++) {
      if (_dataPekerja[a].id_pegawai == _mySelection2) {
        nama_pegawai = _dataPekerja[a].nama_pegawai;
      }
    }
    // print(id);
    // print(_mySelection2);
    // print(nama_pegawai);
    // print(tahun);
    // print(waktu);
    // print(total.toString());
    // print(kembalian.toString());
    // print(modal.toString());
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/add_pengiriman.php"));
    http.post(url, body: {
      "id_pengiriman": id,
      "id_pegawai": _mySelection2,
      "nama_pegawai": nama_pegawai,
      "tanggal": tahun,
      "waktu": waktu,
      "total": total.toString(),
      "kembalian": kembalian.toString(),
      "modal": modal.toString(),
    });
  }

  void kirim_detail() {
    for (int a = 0; a < _dataPesananFiltered.length; a++) {
      // print(id);
      // print(_dataPesananFiltered[a].id_pemesanan);
      var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/add_pengiriman_detail.php"));
      http.post(url, body: {
        "id_pengiriman": id,
        "id_pemesanan": _dataPesananFiltered[a].id_pemesanan,
      });
    }
  }

  void _showDialogPilihan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Belum Memilih Pegawai"),
          content: new Text(
              "Mohon periksa kembali data yang anda masukkan, pastikan sudah memilih pegawai"),
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Pengiriman Barang'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: screenWidth,
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
                      "Pilih Pengirim",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: screenWidth,
                      child: DropdownButton<String>(
                        items: _dataPekerja.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.id_pegawai,
                            child: Text(item.nama_pegawai),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            this._mySelection2 = newValueSelected;
                          });
                        },
                        hint: Text('Pegawai'),
                        value: _mySelection2,
                      ),
                    ),
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
                  itemCount: _dataPesananFiltered.length,
                  itemBuilder: (context, i) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: GestureDetector(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: new ListTile(
                                        title: new Text(
                                          _dataPesananFiltered[i].alamat,
                                          style: TextStyle(
                                            fontSize: 25.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  padding: const EdgeInsets.only(left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: new Table(
                                    columnWidths: {
                                      1: FlexColumnWidth(0.2),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Text(
                                          'Total',
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          ':',
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          _dataPesananFiltered[i].total.toString(),
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          'Kembalian',
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          ':',
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          _dataPesananFiltered[i].kembalian.toString(),
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Text(
                                          'Modal',
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          ':',
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                        Text(
                                          _dataPesananFiltered[i].modal.toString(),
                                          style: new TextStyle(fontSize: 15.0),
                                        ),
                                      ]),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              )),
          Expanded(
            flex: 2,
            child: Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.blue, width: 2.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              total.toString(),
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              kembalian.toString(),
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              modal.toString(),
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
                      if (_mySelection2 == null) {
                        _showDialogPilihan();
                      } else {
                        id_pemesanan();
                        kirim();
                        kirim_detail();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.motorcycle,
                          color: Colors.white,
                        ),
                        new Container(
                          width: 20.0,
                        ),
                        Text(
                          "Kirim",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    )),
              )),
        ],
      ),
    );
  }
}
