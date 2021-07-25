import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/Model/DataPesanan.dart';
import 'package:kios_epes/Model/DataPesanan_lengkap.dart';
import 'package:kios_epes/View/User/Home.dart';
import 'package:kios_epes/View/User/Progress/on_queue_detail_edit_alamat.dart';
import 'package:kios_epes/View/User/Progress/on_queue_detail_edit_pesanan.dart';
import 'package:intl/intl.dart';

class on_queue_detail extends StatefulWidget {
  String id_pemesanan, alamat, tanggal, catatan;
  int total, kembalian, modal;
  on_queue_detail(
      {Key key,
      this.id_pemesanan,
      this.alamat,
      this.tanggal,
      this.catatan,
      this.kembalian,
      this.modal,
      this.total})
      : super(key: key);

  @override
  _on_queue_detailState createState() => _on_queue_detailState();
}

class _on_queue_detailState extends State<on_queue_detail> {
  final oCcy = new NumberFormat.currency(locale: 'id');
  List<DataPesananLengkap> _dataPesanan = [];
  List<DataPesananLengkap> _dataPesananFiltered = [];
  List<DataBarang> _dataBarang = [];
  Map<String, int> array_barang = {};
  TextEditingController catatan = TextEditingController();

  void initState() {
    super.initState();
    getData();
    getDataBarang();
    catatan = new TextEditingController(text: widget.catatan);
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

  void update_catatan() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Pesanan/update_catatan.php"));
    http.post(url, body: {
      "id_pemesanan": widget.id_pemesanan,
      "catatan": catatan.text,
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
    int stok_awal = 0;
    int stok = 0;
    var url1 = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/delete_pesanan.php"));
    var url2 = (Uri.parse("https://timothy.buzz/kios_epes/Stok/update_stok.php"));
    http.post(url1, body: {
      "id_pemesanan": widget.id_pemesanan,
    });
    for (int a = 0; a < _dataPesananFiltered.length; a++) {
      for (int b = 0; b < _dataBarang.length; b++) {
        if (_dataPesananFiltered[a].id_barang == _dataBarang[b].id_barang) {
          stok_awal = _dataBarang[b].Stock;
        }
      }

      stok = _dataPesananFiltered[a].jumlah + stok_awal;
      http.post(url2,
          body: {"id_barang": _dataPesananFiltered[a].id_barang, "stok": stok.toString()});
    }
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
                                  subtitle: Text(
                                      'Total : ${oCcy.format(_dataPesananFiltered[i].harga)}')),
                              // subtitle: Text('Kembalian : ${_dataPengirimanFilteredDetail[i].kembalian.toString()}',),
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
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.blue, width: 2.0)),
              child: Container(
                  margin: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Catatan',
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        ':',
                        style: new TextStyle(fontSize: 18.0),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _catatanDialog(context),
                            barrierDismissible: false,
                          );
                        },
                        child: Text(
                          "Lihat",
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _accDialog(context),
                      );
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
                          "Edit",
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
      title: const Text('Edit Data'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAccInput(),
        ],
      ),
    );
  }

  Widget _buildAccInput() {
    return new Center(
      child: Column(
        children: <Widget>[
          new OutlineButton(
              child: new Text("Ubah Alamat"),
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new on_queue_detail_edit_alamat(
                      id_pemesanan: widget.id_pemesanan,
                      alamat: widget.alamat,
                      catatan: widget.catatan,
                    ),
                  )),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))),
          new OutlineButton(
              child: new Text("Ubah Pesanan"),
              onPressed: () {
                detail_barang();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new on_queue_detail_edit_pemesanan(
                    array_barang: array_barang,
                    id_pemesanan: widget.id_pemesanan,
                  ),
                ));
              },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))),
          new OutlineButton(
              child: new Text(
                "Hapus Pesanan",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _showDialogHapus();
              },
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ))
        ],
      ),
    );
  }

  Widget _catatanDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Edit Data'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _build_catatanDialog(),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        new ElevatedButton(
          onPressed: () {
            update_catatan();
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        )
      ],
    );
  }

  Widget _build_catatanDialog() {
    return new Column(
      children: <Widget>[
        new Container(
          child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: catatan,
              maxLength: 100,
              maxLines: 4,
              decoration: new InputDecoration(labelText: "Catatan")),
        ),
      ],
    );
  }
}
