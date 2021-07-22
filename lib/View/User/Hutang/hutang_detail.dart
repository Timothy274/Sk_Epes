import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataHutang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kios_epes/Model/DataPesanan_lengkap.dart';
import 'package:kios_epes/View/User/Home.dart';

class hutang_detail extends StatefulWidget {
  String id_pemesanan,
      id_pengiriman,
      id_hutang,
      nama_pegawai,
      alamat,
      tanggal_pemesanan,
      tanggal_pengiriman,
      waktu_pengiriman,
      catatan;
  int total;
  hutang_detail(
      {Key key,
      this.id_pemesanan,
      this.id_pengiriman,
      this.id_hutang,
      this.nama_pegawai,
      this.alamat,
      this.tanggal_pemesanan,
      this.tanggal_pengiriman,
      this.waktu_pengiriman,
      this.catatan,
      this.total})
      : super(key: key);

  @override
  _hutang_detailState createState() => _hutang_detailState();
}

class _hutang_detailState extends State<hutang_detail> {
  List<DataHutang> _dataHutang = [];
  List<DataPesananLengkap> _dataPesananDetail = [];
  TextEditingController catatan = TextEditingController();

  void initState() {
    getBarang();
    catatan = new TextEditingController(text: widget.catatan);
  }

  void confirm_selesai() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Hutang Selesai"),
          content: new Text("Apakah anda yakin ingin menyelesaikan pengiriman berikut ?"),
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
                update_status_pesanan();
                update_status_pengiriman();
                delete_hutang();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                  (Route<dynamic> route) => false,
                );

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

  update_status_pesanan() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Hutang/update_status_hutang_pesanan.php"));
    http.post(url, body: {
      "id_pemesanan": widget.id_pemesanan,
    });
  }

  update_status_pengiriman() {
    var url =
        (Uri.parse("http://timothy.buzz/kios_epes/Hutang/update_status_hutang_pengiriman.php"));
    http.post(url, body: {
      "id_pengiriman": widget.id_pemesanan,
    });
  }

  delete_hutang() {
    var url = (Uri.parse("http://timothy.buzz/kios_epes/Hutang/delete_hutang.php"));
    http.post(url, body: {
      "id_hutang": widget.id_hutang,
    });
  }

  Future<List> getBarang() async {
    final response = await http.get(
        Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_join_pesanan_detail.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        if (DataPesananLengkap.fromJson(Data).id_pemesanan == widget.id_pemesanan) {
          _dataPesananDetail.add(DataPesananLengkap.fromJson(Data));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Hutang'),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 3,
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
                          'Pengirim',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          widget.nama_pegawai,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Tanggal Pemesanan',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          widget.tanggal_pemesanan,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Tanggal Pengiriman',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          widget.tanggal_pengiriman,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Waktu Pengiriman',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          widget.waktu_pengiriman,
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
                          widget.total.toString(),
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ]),
                    ],
                  ),
                ),
              )),
          Expanded(
            flex: 3,
            child: Container(
                margin: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none &&
                        snapshot.hasData == null) {
                      return Container();
                    }
                    return ListView.builder(
                      itemCount: _dataPesananDetail.length,
                      itemBuilder: (context, i) {
                        return Container(
                            // padding: const EdgeInsets.all(10.0),
                            child: new Card(
                                child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: new Text(_dataPesananDetail[i].nama_barang,
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                _dataPesananDetail[i].jumlah.toString(),
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
            flex: 1,
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
                            builder: (BuildContext context) => _accDialog(context),
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
                      confirm_selesai();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        new Container(
                          width: 20.0,
                        ),
                        Text(
                          "Selesai",
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
      title: const Text('Detail Catatan'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAccInput(),
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
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        )
      ],
    );
  }

  Widget _buildAccInput() {
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
