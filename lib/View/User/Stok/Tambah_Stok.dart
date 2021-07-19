import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:validators/validators.dart' as validator;
import 'package:kios_epes/Controller/FutureDataBarang.dart';
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/View/User/Home.dart';

class User_Add_Stock extends StatefulWidget {
  final List<DataBarang> data;
  const User_Add_Stock({Key key, this.data}) : super(key: key);

  @override
  _User_Add_StockState createState() => _User_Add_StockState();
}

class _User_Add_StockState extends State<User_Add_Stock> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController stok = TextEditingController();
  TextEditingController harga = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    List<DataBarang> _dataBarang = [];
    // futureDataBarang _futureDataBarang = futureDataBarang();

    Future<List<DataBarang>> getBarang() async {
      // _futureDataBarang.getBarang();

      final response =
          await http.get(Uri.parse("http://timothy.buzz/kios_epes/Stok/get_barang.php"));
      final responseJson = json.decode(response.body);
      setState(() {
        for (Map Data in responseJson) {
          _dataBarang.add(DataBarang.fromJson(Data));
        }
      });
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

    void push_db() {
      String id_barang_2;
      String _nama = nama.text;
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

      print(id_barang_2.toLowerCase());
      print(nama.text);
      print(harga.text);
      print(stok.text);

      // var url = (Uri.parse("https://timothy.buzz/kios_epes/Stok/add_barang.php"));
      // http.post(url, body: {
      //   "id_barang": id_barang_1.toString(),
      //   "nama": nama.text,
      //   "harga": harga.text,
      //   "stok": stok.text,
      //   "nilai": "0",
      // });
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Tambah Produk'),
        ),
        body: Form(
          key: _formKey,
          child: Center(
              child: Expanded(
            child: Column(
              children: [
                Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            controller: nama,
                            decoration: new InputDecoration(labelText: "Nama Produk"),
                            validator: (val3) {
                              if (val3 == null || val3.isEmpty) {
                                return "Masukkan Nama Produk";
                              }
                              return null;
                            },
                          ),
                          new Container(
                            height: 50.0,
                          ),
                          TextFormField(
                            controller: stok,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(labelText: "Stok Produk"),
                            validator: (val1) {
                              if (val1 == null || val1.isEmpty) {
                                return "Masukkan Stok Produk";
                              }
                              return null;
                            },
                          ),
                          new Container(
                            height: 50.0,
                          ),
                          TextFormField(
                              controller: harga,
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(labelText: "Harga"),
                              validator: (val2) {
                                if (val2 == null || val2.isEmpty) {
                                  return "Masukkan Harga Produk";
                                }
                                return null;
                              }),
                          new Container(
                            height: 50.0,
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              push_db();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => new Home_User()),
                                (Route<dynamic> route) => false,
                              );
                            }
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
            ),
          )),
        ));
  }
}
