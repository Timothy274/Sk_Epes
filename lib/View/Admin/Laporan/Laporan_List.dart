import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kios_epes/View/Admin/Laporan/Laporan_Detail.dart';

class Laporan_List extends StatefulWidget {
  const Laporan_List({Key key}) : super(key: key);

  @override
  _Laporan_ListlState createState() => _Laporan_ListlState();
}

class _Laporan_ListlState extends State<Laporan_List> {
  List<String> tanggal = [];
  List<String> _filteredTanggal = [];
  List<String> _null_filteredTanggal = [];
  TextEditingController search_pesanan_selesai = new TextEditingController();

  void initState() {
    super.initState();
    getDataPengiriman();
  }

  void _alterPengirimanSelesai(String query) {
    query = query.toLowerCase();
    List<String> dummySearchList = [];
    dummySearchList.addAll(_null_filteredTanggal);
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filteredTanggal.clear();
        _filteredTanggal.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filteredTanggal.clear();
        _filteredTanggal.addAll(_null_filteredTanggal);
      });
    }
  }

  Future<List> getDataPengiriman() async {
    String date, tahunan, bulanan, bulanan_name;
    final response = await http
        .get(Uri.parse("https://timothy.buzz/kios_epes/Laporan/get_laporan_date_sort.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        date = DataPengiriman.fromJson(Data).tanggal;
        tahunan = date.substring(0, 4);
        bulanan = date.substring(5, 7);

        if (bulanan == '01') {
          bulanan_name = 'Januari';
        } else if (bulanan == '02') {
          bulanan_name = 'Februari';
        } else if (bulanan == '03') {
          bulanan_name = 'Maret';
        } else if (bulanan == '04') {
          bulanan_name = 'April';
        } else if (bulanan == '05') {
          bulanan_name = 'Mei';
        } else if (bulanan == '06') {
          bulanan_name = 'Juni';
        } else if (bulanan == '07') {
          bulanan_name = 'Juli';
        } else if (bulanan == '08') {
          bulanan_name = 'Agustus';
        } else if (bulanan == '09') {
          bulanan_name = 'September';
        } else if (bulanan == '10') {
          bulanan_name = 'Oktober';
        } else if (bulanan == '11') {
          bulanan_name = 'November';
        } else if (bulanan == '12') {
          bulanan_name = 'Desember';
        }

        tanggal.add(tahunan + " " + bulanan_name);
      }
      tanggal = tanggal.toSet().toList();
      _filteredTanggal.addAll(tanggal);
      _null_filteredTanggal.addAll(tanggal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Laporan Penjualan'),
        ),
        body: Container(
            child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 10),
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: search_pesanan_selesai,
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
                  itemCount: _filteredTanggal.length,
                  itemBuilder: (context, i) {
                    return new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: new GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => new Laporan_Detail(
                                    tanggal: _filteredTanggal[i],
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
                                    tanggal[i],
                                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                                  ),
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
        )));
  }
}
