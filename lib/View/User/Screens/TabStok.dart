import 'package:flutter/material.dart';
import 'package:kios_epes/Controller/FutureDataBarang.dart';
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:kios_epes/Model/DataPesananDetail.dart';
import 'package:kios_epes/View/Login.dart';
import 'package:kios_epes/View/User/Home.dart';
import 'package:kios_epes/View/User/Stok/Edit_Stok.dart';
import 'package:kios_epes/View/User/Stok/Tambah_Stok.dart';
import 'package:intl/intl.dart';

class TabStok extends StatefulWidget {
  final List<DataBarang> data;
  const TabStok({Key key, this.data}) : super(key: key);

  @override
  _TabStokState createState() => _TabStokState();
}

class _TabStokState extends State<TabStok> {
  final oCcy = new NumberFormat.currency(locale: 'id');
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _filtered = [];
  List<DataBarang> _null_filtered = [];
  List<DataPesananDetail> _dataPengiriman = [];
  List<DataPesananDetail> _dataPesananDetail = [];

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

  Future<List> getdataPengiriman() async {
    final responseA = await http.get(Uri.parse(
        "https://timothy.buzz/kios_epes/Pengiriman/get_pengiriman_join_pengiriman_detail_only_proses.php"));
    final responseB =
        await http.get(Uri.parse("https://timothy.buzz/kios_epes/Pesanan/get_pesanan_detail.php"));
    final responseAJson = json.decode(responseA.body);
    final responseBJson = json.decode(responseB.body);
    setState(() {
      for (Map DataA in responseAJson) {
        for (Map DataB in responseBJson) {
          if (DataPengiriman.fromJson(DataA).id_pemesanan ==
              DataPesananDetail.fromJson(DataB).id_pemesanan) {
            _dataPengiriman.add(DataPesananDetail.fromJson(DataB));
          }
        }
      }
    });
  }

  void _alterfilter(String query) {
    query = query.toLowerCase();
    List<DataBarang> dummySearchList = [];
    dummySearchList.addAll(_null_filtered);
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

  void test_peringatan(id_barang) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Peringatan"),
          content: new Text("Apakah anda yakin ingin menghapus barang ini dari stok ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Hapus"),
              onPressed: () {
                hapus(id_barang);
              },
            ),
          ],
        );
      },
    );
  }

  void peringatan_hapus_barang() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Peringatan"),
          content: new Text(
              "Data yang ingin anda hapus sedang digunakan dalam pengiriman, mohon selesaikan pengiriman dahulu"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  void hapus(id_barang) {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Stok/delete_barang.php"));
    http.post(url, body: {
      "id_barang": id_barang,
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
      (Route<dynamic> route) => false,
    );
  }

  void initState() {
    super.initState();
    getBarang();
    getdataPengiriman();
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
                            onPressed: () {
                              int b = 0;
                              for (int a = 0; a < _dataPengiriman.length; a++) {
                                if (_dataPengiriman[a].id_barang == _filtered[i].id_barang) {
                                  b = b + 1;
                                }
                              }
                              if (b == 0) {
                                test_peringatan(_filtered[i].id_barang);
                              } else {
                                peringatan_hapus_barang();
                              }
                            },
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
                        builder: (BuildContext context) => new User_Add_Stock()));
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

  // List<Widget> _getTitledWidget() {
  //   return [
  //     TextButton(
  //         onPressed: () {},
  //         child: _getTitleItemWidget(
  //             "Nama" + (sortType == sortName ? (isAscending ? '↓' : '↑') : ''), 50)),
  //     TextButton(onPressed: () {}, child: _getTitleItemWidget("Stock", 50)),
  //     TextButton(onPressed: () {}, child: _getTitleItemWidget("Harga", 50)),
  //     TextButton(onPressed: () {}, child: _getTitleItemWidget("Hapus", 50))
  //   ];
  // }

  // Widget _getTitleItemWidget(String label, double width) {
  //   return Container(
  //     child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
  //     width: width,
  //     height: 56,
  //     padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }

  // Widget _generateFirstColumnRow(BuildContext context, int index) {
  //   return Container(
  //     child: Text(_filtered[index].Nama),
  //     width: 100,
  //     height: 52,
  //     padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }

  // Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  //   return Row(
  //     children: [
  //       Container(
  //         child: Text(_filtered[index].Stock.toString()),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.centerLeft,
  //       ),
  //       Container(
  //         child: Text(_filtered[index].Harga_Tetap.toString()),
  //         width: 50,
  //         height: 52,
  //         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.centerLeft,
  //       ),
  //       Container(
  //           width: 50,
  //           height: 52,
  //           padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
  //           alignment: Alignment.centerLeft,
  //           child: FlatButton(
  //             onPressed: () {},
  //             child: Text(_filtered[index].Harga_Tetap.toString()),
  //           )),
  //     ],
  //   );
  // }
}
