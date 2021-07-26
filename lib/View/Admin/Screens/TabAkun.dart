import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kios_epes/Model/DataAkun.dart';
import 'package:kios_epes/View/Admin/Akun/Detail_Akun.dart';
import 'package:kios_epes/View/Admin/Akun/Tambah_Akun.dart';

class Tab_Akun_Admin extends StatefulWidget {
  const Tab_Akun_Admin({Key key}) : super(key: key);

  @override
  _Tab_Akun_AdminState createState() => _Tab_Akun_AdminState();
}

class _Tab_Akun_AdminState extends State<Tab_Akun_Admin> {
  List<DataAkun> _dataAkun = [];
  List<DataAkun> _filtered = [];
  List<DataAkun> _null_filtered = [];

  void initState() {
    super.initState();
    getAkun();
  }

  Future<List> getAkun() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Akun/get_user.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataAkun.add(DataAkun.fromJson(Data));
      }
      _filtered.addAll(_dataAkun);
      _null_filtered.addAll(_dataAkun);
    });
  }

  void _alterfilter(String query) {
    List<DataAkun> dummySearchList = [];
    dummySearchList.addAll(_null_filtered);
    if (query.isNotEmpty) {
      List<DataAkun> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nama.contains(query)) {
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
                      'Pegawai',
                      style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: TextField(
                      textAlign: TextAlign.left,
                      // controller: search,
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
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  return new Container(
                    padding: const EdgeInsets.all(10.0),
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new Detail_Akun(
                                  list: [_filtered[i]],
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
                                  _filtered[i].nama,
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
              )),
        ),
        Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    // confirmation();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Tambah_Akun()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        "Tambah Pegawai",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  )),
            ))
      ],
    );
  }
}
