import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataPegawai.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:kios_epes/View/Admin/Home.dart';

class Edit_Profil_Pegawai extends StatefulWidget {
  String id_pegawai, nama, nama_lengkap;
  Edit_Profil_Pegawai({Key key, this.id_pegawai, this.nama, this.nama_lengkap}) : super(key: key);

  @override
  _Edit_Profil_PegawaiState createState() => _Edit_Profil_PegawaiState();
}

class _Edit_Profil_PegawaiState extends State<Edit_Profil_Pegawai> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController nama_lengkap = TextEditingController();
  List<DataPegawai> _dataPegawai = [];

  void initState() {
    super.initState();
    getDataPegawai();
    nama = TextEditingController(text: widget.nama);
    nama_lengkap = TextEditingController(text: widget.nama_lengkap);
  }

  Future<List> getDataPegawai() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pegawai/get_pegawai.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPegawai.add(DataPegawai.fromJson(Data));
      }
    });
  }

  void konfirmasi_perubahan() {
    for (int a = 0; a < _dataPegawai.length; a++) {
      if (_dataPegawai[a].nama_lengkap_pegawai == nama_lengkap.text ||
          _dataPegawai[a].nama_pegawai == nama.text) {
        _showDialogerror();
      } else {
        push_db();
      }
    }
  }

  void _showDialogerror() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Perubahan Tertunda"),
          content: new Text(
              "Ada nama atau nama lengkap pegawai yang sama, jika ini pegawai baru bisa dilanjutkan untuk konfirmasi perubahan, namun jika bukan pegawai baru disarankan untuk tidak memasukkan nama pegawai yang sama"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new ElevatedButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton(
              child: new Text("Konfirmasi"),
              onPressed: () {
                push_db();
              },
            ),
          ],
        );
      },
    );
  }

  void push_db() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pegawai/update_pegawai_nama.php"));
    http.post(url, body: {
      "id_pegawai": widget.id_pegawai,
      "nama_lengkap_pegawai": nama_lengkap.text,
      "nama_pegawai": nama.text,
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new Home_Admin()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Ubah Profil Pegawai'),
      ),
      body: new Form(
          key: _formKey,
          child: Center(
            child: Expanded(
                child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: new SingleChildScrollView(
                        child:
                            Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            controller: nama_lengkap,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(labelText: "Nama Lengkap Pegawai"),
                            validator: (val1) {
                              if (val1 == null || val1.isEmpty) {
                                return "Masukkan Nama Lengkap Pegawai";
                              }
                              return null;
                            },
                          ),
                          Divider(height: 50.0),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: nama,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(labelText: "Nama Pegawai"),
                            validator: (val2) {
                              if (val2 == null || val2.isEmpty) {
                                return "Masukkan Nama Pegawai";
                              }
                              return null;
                            },
                          ),
                        ]),
                      )),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              konfirmasi_perubahan();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              Text(
                                "Konfirmasi Perubahan",
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          )),
                    ))
              ],
            )),
          )),
    );
  }
}
