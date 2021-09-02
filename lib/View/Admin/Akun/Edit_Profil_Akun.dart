import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kios_epes/Model/DataAkun.dart';
import 'package:kios_epes/View/Admin/Home.dart';

class Edit_Profil_Akun extends StatefulWidget {
  String id_akun, nama, nama_lengkap, no_telp;
  Edit_Profil_Akun({Key key, this.id_akun, this.nama, this.nama_lengkap, this.no_telp})
      : super(key: key);

  @override
  _Edit_Profil_AkunState createState() => _Edit_Profil_AkunState();
}

class _Edit_Profil_AkunState extends State<Edit_Profil_Akun> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController nama_lengkap = TextEditingController();
  TextEditingController no_telp = TextEditingController();
  List<DataAkun> _dataAkun = [];

  void initState() {
    super.initState();
    getDataAkun();
    nama = TextEditingController(text: widget.nama);
    nama_lengkap = TextEditingController(text: widget.nama_lengkap);
    no_telp = TextEditingController(text: widget.no_telp);
  }

  Future<List> getDataAkun() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Akun/get_user.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataAkun.add(DataAkun.fromJson(Data));
      }
    });
  }

  void konfirmasi_perubahan() {
    for (int a = 0; a < _dataAkun.length; a++) {
      if (_dataAkun[a].nama_lengkap == nama_lengkap.text || _dataAkun[a].nama == nama.text) {
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
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Akun/update_profil_user.php"));
    http.post(url, body: {
      "id_akun": widget.id_akun,
      "nama_lengkap": nama_lengkap.text,
      "nama": nama.text,
      "no_telp": no_telp.text
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
          child: Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                        child: new SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: nama_lengkap,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Nama Lengkap"),
                                  validator: (val1) {
                                    if (val1 == null || val1.isEmpty) {
                                      return "Masukkan Nama Lengkap";
                                    }
                                    return null;
                                  },
                                ),
                                Divider(height: 50.0),
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  controller: nama,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Nama"),
                                  validator: (val2) {
                                    if (val2 == null || val2.isEmpty) {
                                      return "Masukkan Nama";
                                    }
                                    return null;
                                  },
                                ),
                                Divider(height: 50.0),
                                TextFormField(
                                  controller: no_telp,
                                  keyboardType: TextInputType.phone,
                                  decoration: new InputDecoration(labelText: "Nomor Telepon"),
                                  maxLength: 14,
                                  validator: (val3) {
                                    if (val3 == null || val3.isEmpty) {
                                      return "Masukkan Nomor Telepon";
                                    }
                                    return null;
                                  },
                                ),
                              ]),
                        )),
                  )),
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
    );
  }
}
