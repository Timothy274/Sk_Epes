import 'package:flutter/material.dart';
import 'package:kios_epes/Map/DataBarang.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class TabStok extends StatefulWidget {
  const TabStok({Key key}) : super(key: key);

  @override
  _TabStokState createState() => _TabStokState();
}

class _TabStokState extends State<TabStok> {
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _cek1 = [];
  List<DataBarang> _cek2 = [];

  Future<List<DataBarang>> getBarang() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/juljol/get_barang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  Future<List<DataBarang>> getCek() async {
    final responseA =
        await http.get(Uri.parse("http://timothy.buzz/juljol/get_odr_msk_join_odr_msk_detail.php"));
    final responseJsonA = json.decode(responseA.body);
    final responseB = await http
        .get(Uri.parse("http://timothy.buzz/juljol/get_pemesanan_detail_only_proses.php"));
    final responseJsonB = json.decode(responseB.body);
    setState(() {
      for (Map Data in responseJsonA) {
        _cek1.add(DataBarang.fromJson(Data));
      }
      for (Map Data in responseJsonB) {
        _cek2.add(DataBarang.fromJson(Data));
      }
    });
  }

  void initState() {
    super.initState();
    getBarang();
    getCek();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
            color: Color(0xffffff),
            child: Stack(children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Text(
                            'Stock',
                            style: new TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          // height: screenHeight,
                          width: screenWidth,
                          color: Color.fromRGBO(76, 177, 247, 1),
                          // margin: const EdgeInsets.only(
                          //     left: 20.0, right: 20.0, bottom: 150.0),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('Barang')),
                                    DataColumn(label: Text('Stock')),
                                    DataColumn(label: Text('Harga')),
                                    DataColumn(label: Text('Hapus'))
                                  ],
                                  rows: _dataBarang
                                      .map((barang) => DataRow(cells: [
                                            DataCell(
                                              Text(barang.Nama),
                                              onTap: () {},
                                            ),
                                            DataCell(
                                              Text(barang.Stock.toString()),
                                              onTap: () {},
                                            ),
                                            DataCell(
                                              Text(barang.Harga.toString()),
                                              onTap: () {},
                                            ),
                                            DataCell(
                                              Text('Hapus'),
                                              onTap: () {},
                                            )
                                          ]))
                                      .toList(),
                                ),
                              ))),
                    ],
                  ),
                ),
              )
            ])),
        Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            padding: const EdgeInsets.only(left: 60, right: 60),
            alignment: Alignment(-1.0, -1.0),
            child: new SizedBox(
              width: double.infinity,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Color.fromRGBO(76, 177, 247, 1),
                  onPressed: () {},
                  child: const Text('Buat Order',
                      style: TextStyle(fontSize: 20, color: Colors.black))),
            )),
      ],
    );
  }
}
