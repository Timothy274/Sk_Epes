import 'package:flutter/material.dart';
import 'package:kios_epes/Controller/FutureDataBarang.dart';
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:kios_epes/View/Admin/Stok/Edit_Stok.dart';
import 'package:kios_epes/View/Admin/Stok/Tambah_Stok.dart';
import 'package:intl/intl.dart';

class Tab_Stok_Admin extends StatefulWidget {
  final List<DataBarang> data;
  const Tab_Stok_Admin({Key key, this.data}) : super(key: key);

  @override
  _Tab_Stok_AdminState createState() => _Tab_Stok_AdminState();
}

class _Tab_Stok_AdminState extends State<Tab_Stok_Admin> {
  final oCcy = new NumberFormat.currency(locale: 'id');
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _filtered = [];
  List<DataBarang> _null_filtered = [];

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;
  // futureDataBarang _futureDataBarang = futureDataBarang();

  TextEditingController search = new TextEditingController();

  Future<List<DataBarang>> getBarang() async {
    // _futureDataBarang.getBarang();

    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Stok/get_barang.php"));
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
    query = query.toLowerCase();
    List<DataBarang> dummySearchList = [];
    dummySearchList.addAll(_null_filtered);
    if (query.isNotEmpty) {
      List<DataBarang> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.Nama.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        print(dummyListData.length);
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
        Expanded(
            flex: 2,
            child: Column(
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
                      // controller: search,
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
                    )),
              ],
            )),
        Expanded(
          flex: 6,
          child: Container(
            width: screenWidth,
            color: Color(0xffffff),
            child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 600,
                columns: [
                  DataColumn2(
                    label: Text('Nama'),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text('Stok'),
                  ),
                  DataColumn(
                    label: Text('Harga'),
                  ),
                  DataColumn(
                    label: Text('Edit'),
                  ),
                  DataColumn(
                    label: Text('Hapus'),
                  ),
                ],
                rows: List<DataRow>.generate(
                    _filtered.length,
                    (i) => DataRow(cells: [
                          DataCell(
                            Text(_filtered[i].Nama),
                            onTap: () {},
                          ),
                          DataCell(
                            Text(_filtered[i].Stock.toString()),
                            onTap: () {},
                          ),
                          DataCell(
                            Text(oCcy.format(_filtered[i].Harga_Tetap)),
                            onTap: () {},
                          ),
                          DataCell(TextButton(
                            child: Text('Edit'),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new Edit_Stok(
                                  id_barang: _filtered[i].id_barang,
                                  nama_barang: _filtered[i].Nama,
                                  harga: _filtered[i].Harga,
                                  stok: _filtered[i].Stock,
                                ),
                              ));
                            },
                          )),
                          DataCell(TextButton(
                            child: Text('Hapus'),
                            onPressed: () {},
                          )),
                        ]))),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    // confirmation();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Tambah_Stok()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        "Tambah Item",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  )),
            ))
      ],
    );
  }
}
