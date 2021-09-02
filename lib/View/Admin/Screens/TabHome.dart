import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataHutang.dart';
import 'package:kios_epes/Model/DataPegawai.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:kios_epes/Model/DataPesanan.dart';
import 'package:kios_epes/Model/DataPesananSelesai.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:kios_epes/View/Admin/Finish/List_Finish.dart';
import 'package:kios_epes/View/Admin/Hutang/List_Hutang.dart';
import 'package:kios_epes/View/Admin/Onprogress/List_Onprogress.dart';
import 'package:kios_epes/View/Admin/Onqueue/List_Onqueue.dart';

class Tab_Home_Admin extends StatefulWidget {
  const Tab_Home_Admin({Key key}) : super(key: key);

  @override
  _Tab_Home_AdminState createState() => _Tab_Home_AdminState();
}

class _Tab_Home_AdminState extends State<Tab_Home_Admin> {
  final oCcy = new NumberFormat.currency(locale: 'id');
  final alamat = TextEditingController();
  final catatan = TextEditingController();
  int pendapatan_bersih = 0;
  int pendapatan_tertahan = 0;
  List<DataPesanan> _dataPesanan = [];
  List<DataPesananSelesai> _dataPengirimanSelesai = [];
  List<DataPesananSelesai> _dataPengirimanSelesai_harian = [];
  List<DataHutang> _dataHutang = [];
  List<DataPengiriman> _dataPengiriman = [];
  List<DataPegawai> _dataPegawai = [];

  void initState() {
    super.initState();
    getData();
    getdataPengirimanSelesai();
    getdataPesananHutang();
    getdataPengiriman();
    getDataPegawai();
  }

  var tahun = Jiffy().format("yyyy-MM-dd");

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
    final response = await http
        .get(Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/get_pengiriman_only_finish.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        if (DataPesananSelesai.fromJson(Data).tanggal == tahun) {
          print(DataPesananSelesai.fromJson(Data).tanggal);
          print(tahun);
          _dataPengirimanSelesai_harian.add(DataPesananSelesai.fromJson(Data));
        }
        // _dataPengirimanSelesai.add(DataPesananSelesai.fromJson(Data));
      }

      // for (int a = 0; a < _dataPengirimanSelesai.length; a++) {
      //   if (_dataPengirimanSelesai[a].tanggal.contains(tahun)) {
      //     _dataPengirimanSelesai_harian.add(_dataPengirimanSelesai[a]);
      //   }
      // }

      for (int b = 0; b < _dataPengirimanSelesai_harian.length; b++) {
        pendapatan_bersih = pendapatan_bersih + _dataPengirimanSelesai_harian[b].total;
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

      for (int b = 0; b < _dataHutang.length; b++) {
        pendapatan_tertahan = pendapatan_tertahan + _dataHutang[b].total;
      }
    });
  }

  Future<List> getDataPegawai() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pegawai/get_pegawai.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPegawai.add(DataPegawai.fromJson(Data));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new List_Onqueue()));
                      },
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
                          )))),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new List_Onprogress()));
                      },
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
                          ))))
            ],
          ),
          Row(
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new List_Finish()));
                      },
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
                                  _dataPengirimanSelesai_harian.length.toString(),
                                  style: TextStyle(fontSize: 50),
                                ),
                              ),
                            ],
                          )))),
              // Flexible(
              //     flex: 2,
              //     fit: FlexFit.tight,
              //     child: GestureDetector(
              //         onTap: () {
              //           Navigator.of(context).push(new MaterialPageRoute(
              //               builder: (BuildContext context) => new List_Hutang()));
              //         },
              //         child: Container(
              //             margin: const EdgeInsets.all(20),
              //             height: 100,
              //             child: Column(
              //               children: [
              //                 Container(
              //                   alignment: Alignment.centerLeft,
              //                   child: Text(
              //                     "Hutang",
              //                     style: TextStyle(fontSize: 18),
              //                   ),
              //                 ),
              //                 Container(
              //                   alignment: Alignment.centerRight,
              //                   child: Text(
              //                     _dataHutang.length.toString(),
              //                     style: TextStyle(fontSize: 50),
              //                   ),
              //                 ),
              //               ],
              //             ))))
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
                              "Jumlah Pegawai",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _dataPegawai.length.toString(),
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
                              "Pegawai Hadir",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _dataPengirimanSelesai_harian.length.toString(),
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ],
                      )))
            ],
          ),
          Container(
              padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.blue, width: 2.0)),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 20, bottom: 20),
                    alignment: Alignment(-1.0, -1.0),
                    child: Text(
                      'Informasi Toko',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Container(
                      // margin: const EdgeInsets.only(top: 20, bottom: 20),
                      // padding: const EdgeInsets.only(left: 40),
                      alignment: Alignment(-1.0, -1.0),
                      child: Column(
                        children: [
                          Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 20, left: 40),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  'Pendapatan Hari Ini',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20, bottom: 20),
                                padding: const EdgeInsets.only(left: 40),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  oCcy.format(pendapatan_bersih),
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          // Column(
                          //   children: <Widget>[
                          //     Container(
                          //       padding: const EdgeInsets.only(top: 20, left: 40),
                          //       alignment: Alignment(-1.0, -1.0),
                          //       child: Text(
                          //         'Pendapatan Tertunda',
                          //         style: TextStyle(fontSize: 20),
                          //       ),
                          //     ),
                          //     Container(
                          //       margin: const EdgeInsets.only(top: 20, bottom: 10),
                          //       padding: const EdgeInsets.only(left: 40),
                          //       alignment: Alignment(-1.0, -1.0),
                          //       child: Text(
                          //         oCcy.format(pendapatan_tertahan),
                          //         style: TextStyle(fontSize: 18),
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      )),
                  Container(height: 20)
                ],
              )),
        ],
      ),
    ));
  }
}
