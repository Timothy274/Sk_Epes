import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataPesananSelesai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class List_Finish extends StatefulWidget {
  const List_Finish({Key key}) : super(key: key);

  @override
  _List_FinishState createState() => _List_FinishState();
}

class _List_FinishState extends State<List_Finish> {
  TextEditingController search_pengiriman_selesai = new TextEditingController();
  List<DataPesananSelesai> _filteredPengirimanSelesai = [];
  List<DataPesananSelesai> _null_filteredPengirimanSelesai = [];
  List<DataPesananSelesai> _dataPengirimanSelesai = [];

  Future<List> getdataPengirimanSelesai() async {
    final response = await http.get(Uri.parse(
        "http://timothy.buzz/kios_epes/Selesai/get_pesanan_join_pengiriman_only_finish.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPengirimanSelesai.add(DataPesananSelesai.fromJson(Data));
      }
      _filteredPengirimanSelesai.addAll(_dataPengirimanSelesai);
      _null_filteredPengirimanSelesai.addAll(_dataPengirimanSelesai);
    });
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

  void initState() {
    super.initState();
    getdataPengirimanSelesai();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('List Pengiriman Selesai'),
      ),
      body: Container(
          child: Column(
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
                        // Navigator.of(context).push(new MaterialPageRoute(
                        //     builder: (BuildContext context) => new Selesai_Detail(
                        //           id_pemesanan: _filteredPengirimanSelesai[i].id_pemesanan,
                        //           alamat: _filteredPengirimanSelesai[i].alamat,
                        //           tanggal: _filteredPengirimanSelesai[i].tanggal,
                        //           catatan: _filteredPengirimanSelesai[i].status,
                        //           id_pengiriman: _filteredPengirimanSelesai[i].id_pengiriman,
                        //           total: _filteredPengirimanSelesai[i].total,
                        //           modal: _filteredPengirimanSelesai[i].modal,
                        //           kembalian: _filteredPengirimanSelesai[i].kembalian,
                        //           // id_user: _dataPengirimanSelesai[i].id_user,
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
      )),
    );
  }
}
