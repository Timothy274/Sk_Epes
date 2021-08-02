import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataHutang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class List_Hutang extends StatefulWidget {
  const List_Hutang({Key key}) : super(key: key);

  @override
  _List_HutangState createState() => _List_HutangState();
}

class _List_HutangState extends State<List_Hutang> {
  List<DataHutang> _filteredHutang = [];
  List<DataHutang> _null_filteredHutang = [];
  List<DataHutang> _dataHutang = [];
  TextEditingController search_hutang = new TextEditingController();

  void initState() {
    super.initState();
    getdataPesananHutang();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('List Hutang'),
      ),
      body: Expanded(
          child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child: TextField(
                textAlign: TextAlign.left,
                controller: search_hutang,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _alterHutang(value);
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
                itemCount: _filteredHutang.length,
                itemBuilder: (context, i) {
                  return new Container(
                    padding: const EdgeInsets.all(10.0),
                    child: new GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(new MaterialPageRoute(
                        //     builder: (BuildContext context) => new hutang_detail(
                        //           id_pemesanan: _filteredHutang[i].id_pemesanan,
                        //           id_hutang: _filteredHutang[i].id_hutang,
                        //           id_pengiriman: _filteredHutang[i].id_pengiriman,
                        //           nama_pegawai: _filteredHutang[i].nama_pegawai,
                        //           alamat: _filteredHutang[i].alamat,
                        //           tanggal_pemesanan: _filteredHutang[i].tanggal_pemesanan,
                        //           tanggal_pengiriman: _filteredHutang[i].tanggal_pengiriman,
                        //           waktu_pengiriman: _filteredHutang[i].waktu_pengiriman,
                        //           catatan: _filteredHutang[i].catatan,
                        //           total: _filteredHutang[i].total,
                        //         )));
                      },
                      child: new Card(
                          child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: new ListTile(
                                title: new Text(
                                  _filteredHutang[i].alamat,
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
      )),
    );
  }
}
