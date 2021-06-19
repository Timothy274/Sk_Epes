import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Map/DataBarang.dart';

class User_Kasir extends StatefulWidget {
  const User_Kasir({Key key}) : super(key: key);

  @override
  _User_KasirState createState() => _User_KasirState();
}

class _User_KasirState extends State<User_Kasir> {
  List<DataBarang> _dataBarang = [];
  List<String> nilai_harga = [];
  List<String> nilai_awal = [];
  List<String> nilai_awal_harga = [];
  List<DataBarang> _filtered = [];
  List<DataBarang> _null_filtered = [];

  TextEditingController search = new TextEditingController();

  void initState() {
    super.initState();
    getData();
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

  Future<List> getData() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/juljol/get_barang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _filtered.addAll(_dataBarang);
      _null_filtered.addAll(_dataBarang);
      _dataBarang.forEach((DataBarang) {
        nilai_awal.add(DataBarang.nilai_awal);
        nilai_awal_harga.add(DataBarang.nilai_awal);
        nilai_harga.add(DataBarang.Harga);
      });
      // nilai_awal.forEach((e) => print(e));
      // for (int a = 0; a < nilai_awal.length; a++) {
      //   print(nilai_awal[a]);
      // }
    });
    return responseJson;
  }

  void add(array, i) {
    setState(() {
      int num, awal, akhir;
      num = int.parse(array);
      num++;
      int hrg = int.parse(nilai_harga[i]) * num;
      // print(harga);
      String harga = hrg.toString();
      String angka = num.toString();
      awal = i;
      akhir = awal + 1;
      nilai_awal.replaceRange(awal, akhir, [angka]);
      nilai_awal_harga.replaceRange(awal, akhir, [harga]);
    });
  }

  void minus(array, i) {
    setState(() {
      int num, awal, akhir;
      num = int.parse(array);
      if (num != 0) {
        num--;
        int hrg = int.parse(nilai_harga[i]) * num;
        // print(harga);
        String harga = hrg.toString();
        String angka = num.toString();
        awal = i;
        akhir = awal + 1;
        nilai_awal.replaceRange(awal, akhir, [angka]);
        nilai_awal_harga.replaceRange(awal, akhir, [harga]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kios Epes'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                ),
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
                child: FutureBuilder<List>(
                    future: getData(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? new ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Card(
                                        child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: ListTile(
                                            leading: Icon(Icons.book),
                                            title: new Text(_filtered[i].Nama),
                                            subtitle: Text(_filtered[i].Harga),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                _settingModalBottomSheet(context);
                                              },
                                              child: Text("Pilih")),
                                        )
                                        // Column(
                                        //   children: [
                                        //     Container(
                                        //       margin: const EdgeInsets.only(right: 10),
                                        //       child: new Row(
                                        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        //         children: <Widget>[
                                        //           new IconButton(
                                        //               icon: const Icon(Icons.remove),
                                        //               // iconSize: 50,
                                        //               onPressed: () => minus(nilai_awal[i], i)),
                                        //           new Container(
                                        //             // margin: const EdgeInsets.only(
                                        //             //     left: 10, right: 10),
                                        //             child: Text(nilai_awal[i],
                                        //                 style: new TextStyle(fontSize: 20.0)),
                                        //           ),
                                        //           new IconButton(
                                        //               icon: const Icon(Icons.add),
                                        //               // iconSize: 50,
                                        //               onPressed: () => add(nilai_awal[i], i)),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       margin: const EdgeInsets.only(right: 10),
                                        //       child: Text("Rp." + nilai_awal_harga[i]),
                                        //     )
                                        //   ],
                                        // )
                                      ],
                                    )));
                              },
                            )
                          : new Center(
                              child: new CircularProgressIndicator(),
                            );
                    }),
              )),
              Container(
                child: Row(
                  children: [Container()],
                ),
              )
            ],
          ),
        ));
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("Nama"), Text("Aqua")],
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("Harga Per Item"), Text("Rp.100000")],
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("Total"), Text("Rp.100000")],
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Qty",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new IconButton(icon: const Icon(Icons.remove), iconSize: 35, onPressed: () {}),
                    new Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        "1",
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                    new IconButton(icon: const Icon(Icons.add), iconSize: 35, onPressed: () {}),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
