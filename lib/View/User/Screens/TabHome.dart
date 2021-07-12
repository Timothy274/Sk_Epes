import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:jiffy/jiffy.dart';
import 'package:kios_epes/Model/DataPegawai.dart';
import 'package:kios_epes/Model/DataTahun.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/User/Kasir/Kasir.dart';

class TabHome extends StatefulWidget {
  @override
  _TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  final _formKey = new GlobalKey<FormState>();
  String _mySelection;
  // List<DataTahun> _tahunnosort = [];
  // List<String> _tahun = [];
  // List<String> _sorttahun = [];
  // List<String> _tahunset = [];
  // List<String> _tahunnocut = [];
  List _pekerja = List();
  List<DataPegawai> _caripekerja = [];
  Future<String> getSWData() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/juljol/get_pegawai_except_p.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      _pekerja = responseJson;
      for (Map Data in responseJson) {
        _caripekerja.add(DataPegawai.fromJson(Data));
      }
    });
  }

  // Future<String> getTahun() async {
  //   final response = await http.get(Uri.parse("http://timothy.buzz/juljol/get_tahun.php"));
  //   final responseJson = json.decode(response.body);
  //   setState(() {
  //     for (Map Data in responseJson) {
  //       _tahunnosort.add(DataTahun.fromJson(Data));
  //     }
  //     for (int a = 0; a < _tahunnosort.length; a++) {
  //       _tahun.add(_tahunnosort[a].Tahun);
  //     }
  //     _sorttahun = _tahun.toSet().toList();
  //   });
  // }

  final alamat = TextEditingController();
  final catatan = TextEditingController();
  void dispose() {
// Clean up the controller when the widget is disposed.
    alamat.dispose();
    catatan.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    getSWData();
    // getTahun();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    child: Placeholder(
                      color: Colors.black,
                    ),
                  )),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    child: Placeholder(
                      color: Colors.black,
                    ),
                  ))
            ],
          ),
          Row(
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    child: Placeholder(
                      color: Colors.black,
                    ),
                  )),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    child: Placeholder(
                      color: Colors.black,
                    ),
                  ))
            ],
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(76, 177, 247, 1)),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    )),
                margin: const EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
                child: Column(
                  children: [
                    new Container(
                      height: 20.0,
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: alamat,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(labelText: "Alamat"),
                      validator: (val1) {
                        if (val1 == null || val1.isEmpty) {
                          return "Masukkan Alamat";
                        }
                        return null;
                      },
                    ),
                    new Container(
                      height: 50.0,
                    ),
                    Container(
                      width: screenWidth,
                      child: DropdownButtonFormField<String>(
                        validator: (val2) {
                          if (val2 == null || val2.isEmpty) {
                            return "Masukkan Pegawai";
                          }
                          return null;
                        },
                        items: _pekerja.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['id_pegawai'],
                            child: Text(item['Nama']),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            this._mySelection = newValueSelected;
                          });
                        },
                        hint: Text('Pegawai'),
                        value: _mySelection,
                      ),
                    ),
                    new Container(
                      height: 20.0,
                    ),
                    TextField(
                        // controller: catatan,
                        maxLength: 100,
                        maxLines: 4,
                        decoration: new InputDecoration(labelText: "Catatan")),
                    new Container(
                      height: 50.0,
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        alignment: Alignment(-1.0, -1.0),
                        child: new SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              color: Color.fromRGBO(76, 177, 247, 1),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new User_Kasir(
                                            alamat: alamat.text,
                                            pegawai: _mySelection,
                                            catatan: catatan.text,
                                          )));
                                }
                              },
                              child: const Text('Buat Order',
                                  style: TextStyle(fontSize: 20, color: Colors.black))),
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
