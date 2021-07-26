import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kios_epes/View/Admin/Home.dart';

class Edit_Stok extends StatefulWidget {
  String id_barang, nama_barang;
  int harga, stok;
  Edit_Stok({Key key, this.id_barang, this.nama_barang, this.harga, this.stok}) : super(key: key);

  @override
  _Edit_StokState createState() => _Edit_StokState();
}

class _Edit_StokState extends State<Edit_Stok> {
  TextEditingController id_barang = TextEditingController();
  TextEditingController nama_barang = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController stok = TextEditingController();
  List<DataBarang> _dataBarang = [];
  final _formKey = new GlobalKey<FormState>();

  void initState() {
    super.initState();
    getBarang();
    id_barang = new TextEditingController(text: widget.id_barang);
    nama_barang = new TextEditingController(text: widget.nama_barang);
    harga = new TextEditingController(text: widget.harga.toString());
    stok = new TextEditingController(text: widget.stok.toString());
  }

  Future<List<DataBarang>> getBarang() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Stok/get_barang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  void kirim() {
    if (id_barang.text == widget.id_barang) {
      var url = (Uri.parse("https://timothy.buzz/kios_epes/Stok/update_stok_keseluruhan.php"));
      http.post(url, body: {
        "id_barang": id_barang.text,
        "nama_barang": nama_barang.text,
        "stok": stok.text,
        "harga": harga.text,
      });
    } else {
      String id_barang_2;
      String _nama = nama_barang.text;
      int id = 0;
      id_barang(String words) => words.replaceAllMapped(
          new RegExp(r'\b(\w*?)([aeiou]\w*)', caseSensitive: false),
          (Match m) => "${m[2]}${m[1]}${m[1].isEmpty ? 'way' : 'ay'}");
      var id_barang_1 = id_barang("$_nama");
      id_barang_2 = id_barang_1.replaceAll(" ", "");
      for (int a = 0; a < _dataBarang.length; a++) {
        if (_dataBarang[a].id_barang == id_barang_2) {
          test_peringatan();
        } else if (_dataBarang[a].Nama == _nama) {
          test_peringatan();
        }
      }
      var url = (Uri.parse("https://timothy.buzz/kios_epes/Stok/update_stok_keseluruhan.php"));
      http.post(url, body: {
        "id_barang": id_barang_2.toString().toLowerCase(),
        "nama_barang": nama_barang.text,
        "stok": stok.text,
        "harga": harga.text,
      });
    }
  }

  void test_peringatan() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Terdapat error dalam input data"),
          content: new Text("anda sudah pernah input barang ini ke produk silahakan cek kembali"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Ubah Data Barang'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Center(
                      child: Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: id_barang,
                                  enabled: false,
                                  decoration: new InputDecoration(labelText: "Id Barang"),
                                  validator: (val1) {
                                    if (val1 == null || val1.isEmpty) {
                                      return "Masukkan Id Barang";
                                    }
                                    return null;
                                  },
                                ),
                                new Container(
                                  height: 50.0,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: nama_barang,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Nama Barang"),
                                  validator: (val2) {
                                    if (val2 == null || val2.isEmpty) {
                                      return "Masukkan Nama Barang";
                                    }
                                    return null;
                                  },
                                ),
                                new Container(
                                  height: 50.0,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: harga,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Harga"),
                                  validator: (val3) {
                                    if (val3 == null || val3.isEmpty) {
                                      return "Masukkan Harga";
                                    }
                                    return null;
                                  },
                                ),
                                new Container(
                                  height: 50.0,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: stok,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Stok"),
                                  validator: (val4) {
                                    if (val4 == null || val4.isEmpty) {
                                      return "Masukkan Stok";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          )))),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            kirim();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => new Home_Admin()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            new Container(
                              width: 20.0,
                            ),
                            Text(
                              "Simpan",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        )),
                  ))
            ],
          ),
        ));
  }
}
