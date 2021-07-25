import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataPesananDetail.dart';
import 'package:kios_epes/Model/DataPesanan_lengkap.dart';
import 'package:kios_epes/View/User/Home.dart';
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';

import 'package:kios_epes/View/User/Ongoing/on_going_detail_pesanan.dart';
import 'package:kios_epes/View/User/Screens/TabProgress.dart';

class on_going_detail extends StatefulWidget {
  String id_pengiriman, id_pegawai, nama_pegawai, tanggal, waktu;
  int total, kembalian, modal;

  on_going_detail(
      {Key key,
      this.id_pengiriman,
      this.id_pegawai,
      this.kembalian,
      this.modal,
      this.nama_pegawai,
      this.tanggal,
      this.total,
      this.waktu})
      : super(key: key);

  @override
  _on_going_detailState createState() => _on_going_detailState();
}

class _on_going_detailState extends State<on_going_detail> {
  final oCcy = new NumberFormat.currency(locale: 'id');
  List _selectedId = [];
  String id;
  List<DataPengiriman> _dataPengirimanDetail = [];
  List<DataPengiriman> _dataPengirimanFilteredDetail = [];
  List<DataBarang> _dataBarang = [];
  List<DataPesananDetail> _dataPesananDetail = [];
  List<DataPengiriman> _dataPesananProses = [];
  List<DataPengiriman> _dataPengiriman = [];

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
    getPengirimanDetail();
    getDataBarang();
    getDataPesananDetail();
    getPengiriman();
  }

  Future<List> getPengirimanDetail() async {
    final response = await http.get(Uri.parse(
        "http://timothy.buzz/kios_epes/Pengiriman/get_pengiriman_detail_join_pesanan_only_proses.php"));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataPengirimanDetail.add(DataPengiriman.fromJson(Data));
      }
      for (int a = 0; a < _dataPengirimanDetail.length; a++) {
        if (_dataPengirimanDetail[a].id_pengiriman == widget.id_pengiriman) {
          _dataPengirimanFilteredDetail.add(_dataPengirimanDetail[a]);
        }
      }
    });
  }

  Future<List<DataBarang>> getDataBarang() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Stok/get_barang.php"));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  Future<List<DataBarang>> getDataPesananDetail() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_detail.php"));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataPesananDetail.add(DataPesananDetail.fromJson(Data));
      }
    });
  }

  Future<List> getPengiriman() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/get_pengiriman.php"));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataPengiriman.add(DataPengiriman.fromJson(Data));
      }
    });
  }

  void _onCategorySelectedonQueue(bool selected, _searchId) {
    if (selected == true) {
      setState(() {
        _selectedId.add(_searchId);
      });
    } else {
      setState(() {
        _selectedId.remove(_searchId);
      });
    }
  }

  void _showDialogerror() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Tidak ada data yang di pilih"),
          content: new Text("Mohon periksa kembali, apakah anda sudah memilih data pesanan !"),
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

  void confirm_cancel() {
    if (_selectedId.length == 0) {
      _showDialogerror();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Cancel Pengiriman"),
            content: new Text("Apakah anda yakin ingin mengembalikan pengiriman berikut ?"),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("Tutup"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new ElevatedButton(
                child: new Text("Konfirmasi"),
                onPressed: () {
                  if (_selectedId.length == _dataPengirimanFilteredDetail.length) {
                    hapus_pengiriman_semua();
                    hapus_pengiriman_detail_semua();
                    update_status();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    hapus_pengiriman_detail();
                    update_status();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  void confirm_delete() {
    if (_selectedId.length == 0) {
      _showDialogerror();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Hapus Pengiriman"),
            content: new Text("Apakah anda yakin ingin menghapus pengiriman berikut ?"),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("Tutup"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new ElevatedButton(
                child: new Text("Hapus", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  if (_selectedId.length == _dataPengirimanFilteredDetail.length) {
                    hapus_pesanan();
                    hapus_pesanan_detail();
                    hapus_pengiriman_semua();
                    hapus_pengiriman_detail_semua();
                    update_stok();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    hapus_pesanan();
                    hapus_pesanan_detail();
                    hapus_pengiriman_detail();
                    update_stok();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                      (Route<dynamic> route) => false,
                    );
                  }
                  // hapus_pesanan();
                  // hapus_pesanan_detail();
                  // hapus_pengiriman_semua();
                  // hapus_pengiriman_detail();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void confirm_finish() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Selesai Pengiriman"),
          content: new Text("Apakah anda yakin ingin menyelesaikan pengiriman ini ?"),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton(
              child: new Text("Konfirmasi"),
              onPressed: () {
                konfirmasi_pemesanan();
                konfirmasi_pengiriman();
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

  void confirm_hutang() {
    if (_selectedId.length == 0) {
      _showDialogerror();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pesanan Berhutang"),
            content: new Text("Apakah anda yakin ingin pesanan ini berhutang ?"),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("Tutup"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new ElevatedButton(
                child: new Text("Konfirmasi"),
                onPressed: () {
                  if (_selectedId.length == _dataPengirimanFilteredDetail.length) {
                    tambah_hutang();
                    update_status_hutang();
                    update_status_hutang_pengiriman();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    tambah_hutang();
                    update_status_hutang();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  void hapus_pengiriman_detail() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/delete_pengiriman_detail.php"));
    for (int a = 0; a < _selectedId.length; a++) {
      http.post(url, body: {
        "id_pengiriman": widget.id_pengiriman,
        "id_pemesanan": _selectedId[a],
      });
    }
  }

  void hapus_pengiriman_semua() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/delete_pengiriman_semua.php"));
    http.post(url, body: {
      "id_pengiriman": widget.id_pengiriman,
    });
  }

  void hapus_pengiriman_detail_semua() {
    var url =
        (Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/delete_pengiriman_detail_semua.php"));
    http.post(url, body: {
      "id_pengiriman": widget.id_pengiriman,
    });
  }

  void hapus_pesanan() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Pesanan/delete_pesanan.php"));
    for (int a = 0; a < _selectedId.length; a++) {
      http.post(url, body: {
        "id_pemesanan": _selectedId[a],
      });
      // print(_selectedId[a]);
    }
  }

  void hapus_pesanan_detail() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Pesanan/delete_pesanan_detail.php"));
    for (int a = 0; a < _selectedId.length; a++) {
      http.post(url, body: {
        "id_pemesanan": _selectedId[a],
      });
      // print(_selectedId[a]);
    }
  }

  void update_status() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Pesanan/update_pesanan_status_semua.php"));
    for (int a = 0; a < _selectedId.length; a++) {
      http.post(url, body: {
        "id_pemesanan": _selectedId[a],
      });
    }
  }

  void update_status_hutang() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Hutang/update_status_hutang.php"));
    for (int a = 0; a < _selectedId.length; a++) {
      http.post(url, body: {
        "id_pemesanan": _selectedId[a],
      });
      // print(_selectedId[a]);
    }
  }

  void update_status_hutang_pengiriman() {
    var url =
        (Uri.parse("http://timothy.buzz/kios_epes/Hutang/update_status_hutang_pengiriman.php"));
    http.post(url, body: {
      "id_pengiriman": widget.id_pengiriman,
    });
    // print(widget.id_pengiriman);
  }

  void konfirmasi_pemesanan() {
    var url =
        (Uri.parse("http://timothy.buzz/kios_epes/Konfirmasi/update_konfirmasi_pemesanan.php"));
    for (int a = 0; a < _dataPengirimanFilteredDetail.length; a++) {
      http.post(url, body: {
        "id_pemesanan": _dataPengirimanFilteredDetail[a].id_pemesanan,
      });
      // print(_dataPengirimanFiltered[a].id_pemesanan);
    }
  }

  void konfirmasi_pengiriman() {
    var url =
        (Uri.parse("http://timothy.buzz/kios_epes/Konfirmasi/update_konfirmasi_pengiriman.php"));
    // print(widget.id_pengiriman);
    http.post(url, body: {
      "id_pengiriman": widget.id_pengiriman,
    });
  }

  void id_hutang(alamat) {
    id = tanggal +
        bulan +
        year +
        jam +
        menit +
        detik +
        widget.id_pengiriman.length.toString() +
        widget.id_pegawai.length.toString() +
        alamat;
  }

  void tambah_hutang() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Hutang/add_hutang.php"));
    for (int a = 0; a < _dataPengirimanFilteredDetail.length; a++) {
      for (int b = 0; b < _selectedId.length; b++) {
        for (int c = 0; c < _dataPengiriman.length; c++) {
          if (_dataPengirimanFilteredDetail[a].id_pemesanan == _selectedId[b] &&
              _dataPengirimanFilteredDetail[a].id_pengiriman == _dataPengiriman[c].id_pengiriman) {
            id_hutang(_dataPengirimanFilteredDetail[a].alamat);
            http.post(url, body: {
              "id_hutang": id,
              "id_pemesanan": _dataPengirimanFilteredDetail[a].id_pemesanan,
              "id_pengiriman": _dataPengirimanFilteredDetail[a].id_pengiriman,
              "id_pegawai": _dataPengiriman[c].id_pegawai,
              "alamat": _dataPengirimanFilteredDetail[a].alamat,
              "nama_pegawai": _dataPengiriman[c].nama_pegawai,
              "total": _dataPengirimanFilteredDetail[a].total.toString(),
              "tanggal_pemesanan": _dataPengirimanFilteredDetail[a].tanggal,
              "tanggal_pengiriman": widget.tanggal,
              "waktu_pengiriman": widget.waktu,
            });
            // print(id);
            // print(_dataPengirimanFilteredDetail[a].id_pemesanan);
            // print(_dataPengirimanFilteredDetail[a].id_pengiriman);
            // print(_dataPengiriman[c].id_pegawai);
            // print(_dataPengirimanFilteredDetail[a].alamat);
            // print(_dataPengiriman[c].nama_pegawai);
            // print(_dataPengirimanFilteredDetail[a].total.toString());
            // print(_dataPengirimanFilteredDetail[a].tanggal);
            // print(widget.tanggal);
            // print(widget.waktu);
          }
        }
      }
    }
  }

  void update_stok() {
    // print(_dataPesananDetail.length);
    // print(_selectedId.length);
    // print(_dataBarang.length);
    int stok = 0;
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Stok/update_stok.php"));
    for (int a = 0; a < _dataPesananDetail.length; a++) {
      for (int b = 0; b < _selectedId.length; b++) {
        if (_dataPesananDetail[a].id_pemesanan == _selectedId[b]) {
          for (int c = 0; c < _dataBarang.length; c++) {
            if (_dataPesananDetail[a].id_barang == _dataBarang[c].id_barang) {
              stok = _dataPesananDetail[a].jumlah + _dataBarang[c].Stock;
              http.post(url,
                  body: {"id_barang": _dataPesananDetail[a].id_barang, "stok": stok.toString()});
              // print(_dataPesananDetail[a].id_barang);
              // print(stok);
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengiriman'),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 4,
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
                          'Pengirim',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          widget.nama_pegawai,
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
                      TableRow(children: [
                        Text(
                          'Waktu',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          widget.waktu,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Total',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          oCcy.format(widget.total),
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Kembalian',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          oCcy.format(widget.kembalian),
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Modal',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          oCcy.format(widget.modal),
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
                    itemCount: _dataPengirimanFilteredDetail.length,
                    itemBuilder: (context, i) {
                      return Container(
                          // padding: const EdgeInsets.all(10.0),
                          child: new GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => new on_going_detail_pesanan(
                                    id_pemesanan: _dataPengirimanFilteredDetail[i].id_pemesanan,
                                    alamat: _dataPengirimanFilteredDetail[i].alamat,
                                    tanggal: _dataPengirimanFilteredDetail[i].tanggal,
                                    catatan: _dataPengirimanFilteredDetail[i].catatan,
                                    modal: _dataPengirimanFilteredDetail[i].modal,
                                    kembalian: _dataPengirimanFilteredDetail[i].kembalian,
                                    total: _dataPengirimanFilteredDetail[i].total,
                                  )));
                        },
                        child: Card(
                            child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: new Text(_dataPengirimanFilteredDetail[i].alamat,
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(
                                  'Kembalian : ${oCcy.format(_dataPengirimanFilteredDetail[i].kembalian)}',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: Checkbox(
                                value: _selectedId
                                    .contains(_dataPengirimanFilteredDetail[i].id_pemesanan),
                                onChanged: (bool selected) {
                                  _onCategorySelectedonQueue(
                                    selected,
                                    (_dataPengirimanFilteredDetail[i].id_pemesanan),
                                  );
                                },
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        )),
                      ));
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Center(
                child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              confirm_cancel();
                            },
                            child: new Text("Cancel"),
                          ),
                        ),
                        new Container(
                          margin: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              confirm_delete();
                            },
                            child: new Text("Hapus"),
                          ),
                        ),
                        new Container(
                          margin: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              confirm_hutang();
                            },
                            child: new Text("Hutang"),
                          ),
                        ),
                        new Container(
                          margin: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              confirm_finish();
                            },
                            child: new Text("Selesai"),
                          ),
                        )
                      ],
                    )),
              )),
        ],
      ),
    );
  }
}
