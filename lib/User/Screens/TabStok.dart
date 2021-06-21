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
  List<DataBarang> _filtered = [];
  List<DataBarang> _null_filtered = [];
  TextEditingController search = new TextEditingController();

  Future<List<DataBarang>> getBarang() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/juljol/get_barang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _filtered.addAll(_dataBarang);
      _null_filtered.addAll(_dataBarang);
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

  void initState() {
    super.initState();
    getBarang();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          child: Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Text(
              'Stock',
              style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
            )),
        Container(
            color: Color(0xffffff),
            child: Stack(children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                          // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          // height: screenHeight,
                          width: screenWidth,
                          // color: Color.fromRGBO(76, 177, 247, 1),
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
                                  rows: _filtered
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
