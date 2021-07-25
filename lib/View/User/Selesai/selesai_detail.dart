import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:kios_epes/Model/DataPesanan_lengkap.dart';

class Selesai_Detail extends StatefulWidget {
  String id_pengiriman, id_pemesanan, alamat, catatan, tanggal;
  int total, kembalian, modal;
  Selesai_Detail({
    Key key,
    this.id_pengiriman,
    this.id_pemesanan,
    this.kembalian,
    this.modal,
    this.alamat,
    this.tanggal,
    this.total,
    this.catatan,
  }) : super(key: key);

  @override
  _Selesai_DetailState createState() => _Selesai_DetailState();
}

class _Selesai_DetailState extends State<Selesai_Detail> {
  final oCcy = new NumberFormat.currency(locale: 'id');
  List<DataPesananLengkap> _dataPesanan = [];
  TextEditingController catatan = TextEditingController();

  void initState() {
    super.initState();
    getPengirimanDetail();
    catatan = new TextEditingController(text: widget.catatan);
  }

  Future<List> getPengirimanDetail() async {
    final response = await http.get(
        Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_join_pesanan_detail.php"));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        if (DataPesananLengkap.fromJson(Data).id_pemesanan == widget.id_pemesanan) {
          _dataPesanan.add(DataPesananLengkap.fromJson(Data));
        }
      }
    });
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
                      itemCount: _dataPesanan.length,
                      itemBuilder: (context, i) {
                        return Container(
                            // padding: const EdgeInsets.all(10.0),
                            child: new Card(
                                child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: new Text(_dataPesanan[i].nama_barang,
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text('Total : ${_dataPesanan[i].harga}'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                _dataPesanan[i].jumlah.toString(),
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
          child: const Text('Tutup'),
        ),
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
