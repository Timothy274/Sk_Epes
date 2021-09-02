import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataHutang.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:kios_epes/Model/DataPesanan.dart';
import 'package:kios_epes/Model/DataPesananDetail.dart';
import 'package:kios_epes/Model/DataPesananSelesai.dart';
import 'package:kios_epes/View/User/Hutang/hutang_detail.dart';
import 'package:kios_epes/View/User/Ongoing/on_going_detail.dart';
import 'package:kios_epes/View/User/Progress/on_queue_detail.dart';
import 'package:kios_epes/View/User/Progress/on_queue_kirim.dart';
import 'package:kios_epes/View/User/Selesai/selesai_detail.dart';
import 'package:jiffy/jiffy.dart';

class TabProgress extends StatefulWidget {
  const TabProgress({Key key}) : super(key: key);

  @override
  _TabProgressState createState() => _TabProgressState();
}

class _TabProgressState extends State<TabProgress> with TickerProviderStateMixin {
  TabController _nestedTabController;
  List _selectedId = [];
  List<DataPesanan> _dataPesananProses = [];
  List<DataPesanan> _filteredPesanan = [];
  List<DataPesanan> _null_filteredPesanan = [];
  List<DataPesanan> _dataPesanan = [];
  List<DataPesananSelesai> _filteredPengirimanSelesai = [];
  List<DataPesananSelesai> _null_filteredPengirimanSelesai = [];
  List<DataPesananSelesai> _dataPesananSelesai = [];
  List<DataPengiriman> _dataPengirimanSelesai = [];
  List<DataHutang> _filteredHutang = [];
  List<DataHutang> _null_filteredHutang = [];
  List<DataHutang> _dataHutang = [];
  List<DataHutang> _dataHutang_Satuan = [];
  TextEditingController search_pesanan = new TextEditingController();
  TextEditingController search_pengiriman_selesai = new TextEditingController();
  TextEditingController search_hutang = new TextEditingController();
  var tahun = Jiffy().format("yyyy-MM-dd");

  Future<List> getData() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_antrian.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPesanan.add(DataPesanan.fromJson(Data));
      }
      _filteredPesanan.addAll(_dataPesanan);
      _null_filteredPesanan.addAll(_dataPesanan);
    });
  }

  Future<List> getdataPengiriman() async {
    final response = await http
        .get(Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/get_pengiriman_only_proses.php"));
    return json.decode(response.body);
  }

  // Future<List> getdataPengirimanList() async {
  //   final response =
  //       await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pengiriman/get_pengiriman.php"));
  //   final responseJson = json.decode(response.body);
  //   setState(() {
  //     for (Map Data in responseJson) {
  //       _dataPengirimanSelesai.add(DataPesananSelesai.fromJson(Data));
  //     }
  //     _filteredPengirimanSelesai.addAll(_dataPengirimanSelesai);
  //     _null_filteredPengirimanSelesai.addAll(_dataPengirimanSelesai);
  //   });
  // }

  Future<List> getdataPengirimanSelesai() async {
    final responseA = await http.get(Uri.parse(
        "http://timothy.buzz/kios_epes/Selesai/get_pengiriman_join_pengiriman_detail_only_finish.php"));
    final responseB = await http.get(
        Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_join_pesanan_detail.php"));
    final responseJsonA = json.decode(responseA.body);
    final responseJsonB = json.decode(responseB.body);
    setState(() {
      for (Map Data in responseJsonA) {
        if (DataPengiriman.fromJson(Data).tanggal == tahun) {
          _dataPengirimanSelesai.add(DataPengiriman.fromJson(Data));
        }
      }

      for (Map Data in responseJsonB) {
        for (int a = 0; a < _dataPengirimanSelesai.length; a++) {
          if (_dataPengirimanSelesai[a].id_pemesanan ==
              DataPesananDetail.fromJson(Data).id_pemesanan) {
            _dataPesananSelesai.add(DataPesananSelesai.fromJson(Data));
          }
        }
      }
      _filteredPengirimanSelesai.addAll(_dataPesananSelesai);
      _null_filteredPengirimanSelesai.addAll(_dataPesananSelesai);
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
      _filteredHutang.addAll(_dataHutang);
      _null_filteredHutang.addAll(_dataHutang);
    });
  }

  void initState() {
    super.initState();
    getData();
    getdataPengirimanSelesai();
    getdataPesananHutang();
    // getdataPengirimanList();
    _nestedTabController = new TabController(length: 3, vsync: this);
  }

  void _alterfilterpesanan(String query) {
    query = query.toLowerCase();
    List<DataPesanan> dummySearchList = [];
    dummySearchList.addAll(_null_filteredPesanan);
    if (query.isNotEmpty) {
      List<DataPesanan> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.alamat.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filteredPesanan.clear();
        _filteredPesanan.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filteredPesanan.clear();
        _filteredPesanan.addAll(_null_filteredPesanan);
      });
    }
  }

  void _alterPengirimanSelesai(String query) {
    query = query.toLowerCase();
    List<DataPesananSelesai> dummySearchList = [];
    dummySearchList.addAll(_null_filteredPengirimanSelesai);
    if (query.isNotEmpty) {
      List<DataPesananSelesai> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.alamat.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filteredPengirimanSelesai.clear();
        _filteredPengirimanSelesai.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filteredPengirimanSelesai.clear();
        _filteredPengirimanSelesai.addAll(_null_filteredPengirimanSelesai);
      });
    }
  }

  void _alterHutang(String query) {
    query = query.toLowerCase();
    List<DataHutang> dummySearchList = [];
    dummySearchList.addAll(_null_filteredHutang);
    if (query.isNotEmpty) {
      List<DataHutang> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.alamat.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filteredHutang.clear();
        _filteredHutang.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filteredHutang.clear();
        _filteredHutang.addAll(_null_filteredHutang);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: "Antrian Pesanan",
            ),
            Tab(
              text: "Sedang Pengiriman",
            ),
            Tab(
              text: "Pesanan Selesai",
            ),
            // Tab(
            //   text: "Hutang",
            // ),
          ],
        ),
        Container(
          height: screenHeight * 0.70,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              _inheritedqueue(),
              _inheritongoing(),
              _inheritedselesai(),
              // _inheritedhutang(),
            ],
          ),
        )
      ],
    );
  }

  Widget _inheritedqueue() {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: TextField(
              textAlign: TextAlign.left,
              controller: search_pesanan,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                _alterfilterpesanan(value);
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
            ),
          ),
        ),
        Expanded(
            flex: 8,
            child: Container(
                child: ListView.builder(
              itemCount: _filteredPesanan.length,
              itemBuilder: (context, i) {
                return new Container(
                  padding: const EdgeInsets.all(10.0),
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new on_queue_detail(
                                id_pemesanan: _filteredPesanan[i].id_pemesanan,
                                alamat: _filteredPesanan[i].alamat,
                                tanggal: _filteredPesanan[i].tanggal,
                                catatan: _filteredPesanan[i].catatan,
                                total: _filteredPesanan[i].total,
                                modal: _filteredPesanan[i].modal,
                                kembalian: _filteredPesanan[i].kembalian,
                                kasir: _filteredPesanan[i].id_user,
                              )));
                    },
                    child: new Card(
                        child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: new ListTile(
                              title: new Text(
                                _filteredPesanan[i].alamat,
                                style: TextStyle(fontSize: 25.0, color: Colors.black),
                              ),
                              // subtitle: new Text(
                              //   "Pengantar : ${snapshot.data[i]['nama_pegawai']}",
                              //   style: TextStyle(fontSize: 20.0, color: Colors.black),
                              // ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: Checkbox(
                              value: _selectedId.contains(_filteredPesanan[i].id_pemesanan),
                              onChanged: (bool selected) {
                                _onCategorySelectedonQueue(
                                  selected,
                                  (_filteredPesanan[i].id_pemesanan),
                                );
                              },
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    )),
                  ),
                );
              },
            ))),
        Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_selectedId.isEmpty) {
                      _showDialogerror();
                    } else {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new On_Queue_Kirim(
                                list: _selectedId,
                              )));
                    }
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
                        "Kirim Pesanan",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  )),
            ))
      ],
    );
  }

  Widget _inheritongoing() {
    return Column(
      children: [
        Expanded(
            flex: 8,
            child: Container(
              child: FutureBuilder<List>(
                future: getdataPengiriman(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return new Container(
                              padding: const EdgeInsets.all(10.0),
                              child: new GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new on_going_detail(
                                            id_pegawai: snapshot.data[i]['id_pegawai'],
                                            id_pengiriman: snapshot.data[i]['id_pengiriman'],
                                            nama_pegawai: snapshot.data[i]['nama_pegawai'],
                                            tanggal: snapshot.data[i]['tanggal'],
                                            waktu: snapshot.data[i]['waktu'],
                                            total: int.parse(snapshot.data[i]['total']),
                                            kembalian: int.parse(snapshot.data[i]['kembalian']),
                                            modal: int.parse(snapshot.data[i]['modal']),
                                            id_user: snapshot.data[i]['id_user'],
                                          )));
                                },
                                child: new Card(
                                    child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: new ListTile(
                                          title: new Text(
                                            snapshot.data[i]['nama_pegawai'],
                                            style: TextStyle(fontSize: 25.0, color: Colors.black),
                                          ),
                                          subtitle: new Text(
                                            "Waktu : ${snapshot.data[i]['waktu']}",
                                            style: TextStyle(fontSize: 20.0, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   margin: const EdgeInsets.only(right: 20.0),
                                      //   child: Checkbox(
                                      //     value: _selectedId
                                      //         .contains(snapshot.data[i]['id_pemesanan']),
                                      //     onChanged: (bool selected) {
                                      //       _onCategorySelectedonQueue(
                                      //         selected,
                                      //         (snapshot.data[i]['id_pemesanan']),
                                      //       );
                                      //     },
                                      //   ),
                                      //   alignment: Alignment.centerRight,
                                      // ),
                                    ],
                                  ),
                                )),
                              ),
                            );
                          },
                        )
                      : new Center(
                          child: new CircularProgressIndicator(),
                        );
                  ;
                },
              ),
            )),
      ],
    );
  }

  Widget _inheritedselesai() {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: TextField(
              textAlign: TextAlign.left,
              controller: search_pengiriman_selesai,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                _alterPengirimanSelesai(value);
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
            ),
          ),
        ),
        Expanded(
            flex: 8,
            child: Container(
                child: ListView.builder(
              itemCount: _filteredPengirimanSelesai.length,
              itemBuilder: (context, i) {
                return new Container(
                  padding: const EdgeInsets.all(10.0),
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new Selesai_Detail(
                                id_pemesanan: _filteredPengirimanSelesai[i].id_pemesanan,
                                // alamat: _filteredPengirimanSelesai[i].alamat,
                                // tanggal: _filteredPengirimanSelesai[i].tanggal,
                                // catatan: _filteredPengirimanSelesai[i].status,
                                id_pengiriman: _filteredPengirimanSelesai[i].id_pengiriman,
                                // total: _filteredPengirimanSelesai[i].total,
                                // modal: _filteredPengirimanSelesai[i].modal,
                                // kembalian: _filteredPengirimanSelesai[i].kembalian,
                                // id_user: _dataPengirimanSelesai[i].id_user,
                              )));
                    },
                    child: new Card(
                        child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: new ListTile(
                              title: new Text(
                                _filteredPengirimanSelesai[i].alamat,
                                style: TextStyle(fontSize: 25.0, color: Colors.black),
                              ),
                              // subtitle: new Text(
                              //   "Pengantar : ${snapshot.data[i]['nama_pegawai']}",
                              //   style: TextStyle(fontSize: 20.0, color: Colors.black),
                              // ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                );
              },
            ))),
      ],
    );
  }

  // Widget _inheritedhutang() {
  //   return Expanded(
  //       child: Column(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
  //           child: TextField(
  //             textAlign: TextAlign.left,
  //             controller: search_hutang,
  //             textCapitalization: TextCapitalization.words,
  //             onChanged: (value) {
  //               _alterHutang(value);
  //             },
  //             decoration: InputDecoration(
  //                 contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //                 filled: true,
  //                 fillColor: Colors.white,
  //                 // prefixIcon: Icon(
  //                 //   Icons.qr_code_scanner,
  //                 //   color: Colors.black,
  //                 // ),
  //                 suffixIcon: Icon(Icons.search, color: Colors.black),
  //                 hintStyle: new TextStyle(color: Colors.black38),
  //                 hintText: "Search"),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //           flex: 8,
  //           child: Container(
  //               child: ListView.builder(
  //             itemCount: _filteredHutang.length,
  //             itemBuilder: (context, i) {
  //               return new Container(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: new GestureDetector(
  //                   onTap: () {
  //                     Navigator.of(context).push(new MaterialPageRoute(
  //                         builder: (BuildContext context) => new hutang_detail(
  //                               id_pemesanan: _filteredHutang[i].id_pemesanan,
  //                               id_hutang: _filteredHutang[i].id_hutang,
  //                               id_pengiriman: _filteredHutang[i].id_pengiriman,
  //                               nama_pegawai: _filteredHutang[i].nama_pegawai,
  //                               alamat: _filteredHutang[i].alamat,
  //                               tanggal_pemesanan: _filteredHutang[i].tanggal_pemesanan,
  //                               tanggal_pengiriman: _filteredHutang[i].tanggal_pengiriman,
  //                               waktu_pengiriman: _filteredHutang[i].waktu_pengiriman,
  //                               catatan: _filteredHutang[i].catatan,
  //                               total: _filteredHutang[i].total,
  //                             )));
  //                   },
  //                   child: new Card(
  //                       child: Container(
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: <Widget>[
  //                         Expanded(
  //                           child: new ListTile(
  //                             title: new Text(
  //                               _filteredHutang[i].alamat,
  //                               style: TextStyle(fontSize: 25.0, color: Colors.black),
  //                             ),
  //                             // subtitle: new Text(
  //                             //   "Pengantar : ${snapshot.data[i]['nama_pegawai']}",
  //                             //   style: TextStyle(fontSize: 20.0, color: Colors.black),
  //                             // ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   )),
  //                 ),
  //               );
  //             },
  //           ))),
  //     ],
  //   ));
  // }
}
