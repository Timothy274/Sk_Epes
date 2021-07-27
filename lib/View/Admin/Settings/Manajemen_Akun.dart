import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataAkun.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/Admin/Home.dart';
import 'package:kios_epes/View/Admin/Settings/Manajemen_Password.dart';
import 'package:kios_epes/View/Admin/Settings/Manajemen_Username.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class Manajemen_Akun extends StatefulWidget {
  const Manajemen_Akun({Key key}) : super(key: key);

  @override
  _Manajemen_AkunState createState() => _Manajemen_AkunState();
}

class _Manajemen_AkunState extends State<Manajemen_Akun> {
  List<DataAkun> _dataAkun = [];
  TextEditingController nama_lengkap = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController no_telp = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  String id_user, username, password;

  void initState() {
    super.initState();
    cekuser();
    getAkun();
  }

  Future cekuser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("id_user") != null) {
      setState(() {
        id_user = pref.getString("id_user");
      });
    }
  }

  Future<List> getAkun() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Akun/get_user.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataAkun.add(DataAkun.fromJson(Data));
        if (DataAkun.fromJson(Data).id_user == id_user) {
          nama = TextEditingController(text: DataAkun.fromJson(Data).nama);
          nama_lengkap = TextEditingController(text: DataAkun.fromJson(Data).nama_lengkap);
          no_telp = TextEditingController(text: DataAkun.fromJson(Data).no_telp);
          username = DataAkun.fromJson(Data).username;
          password = DataAkun.fromJson(Data).password;
        }
      }
    });
  }

  void _showDialogerror() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Perubahan Tertunda"),
          content: new Text(
              "Ada nama atau nama lengkap pegawai yang sama, jika ini pegawai baru bisa dilanjutkan untuk konfirmasi perubahan, namun jika bukan pegawai baru disarankan untuk tidak memasukkan nama pegawai yang sama"),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new ElevatedButton(
              child: new Text("Konfirmasi"),
              onPressed: () {
                kirim();
              },
            ),
          ],
        );
      },
    );
  }

  void konfirmasi_perubahan() {
    for (int a = 0; a < _dataAkun.length; a++) {
      if (_dataAkun[a].nama_lengkap == nama_lengkap.text || _dataAkun[a].nama == nama.text) {
        _showDialogerror();
      } else {
        kirim();
      }
    }
  }

  void kirim() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Akun/update_profil_user.php"));
    http.post(url, body: {
      "id_akun": id_user,
      "nama_lengkap": nama_lengkap.text,
      "nama": nama.text,
      "no_telp": no_telp.text,
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
          title: const Text('Manajemen Akun'),
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
                                new Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Text(
                                    'Data Diri',
                                    style: new TextStyle(fontSize: 25.0),
                                  ),
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  controller: nama_lengkap,
                                  decoration: new InputDecoration(labelText: "Nama Lengkap"),
                                  validator: (val1) {
                                    if (val1 == null || val1.isEmpty) {
                                      return "Masukkan Nama lengkap";
                                    }
                                    return null;
                                  },
                                ),
                                new Container(
                                  height: 50.0,
                                ),
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: nama,
                                  maxLength: 20,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Nama"),
                                  validator: (val2) {
                                    if (val2 == null || val2.isEmpty) {
                                      return "Masukkan Nama";
                                    }
                                    return null;
                                  },
                                ),
                                new Container(
                                  height: 50.0,
                                ),
                                TextFormField(
                                  maxLength: 14,
                                  // textCapitalization: TextCapitalization.words,
                                  controller: no_telp,
                                  keyboardType: TextInputType.phone,
                                  decoration: new InputDecoration(labelText: "Nomor Telepon"),
                                ),
                                new Container(
                                  height: 80.0,
                                ),
                                new Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    'Keamanan',
                                    style: new TextStyle(fontSize: 25.0),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(top: 20, left: 40),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Username',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.only(right: 40),
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      new Manajemen_Username(
                                                        id_user: id_user,
                                                        username: username,
                                                      )));
                                            },
                                            child: Text(
                                              "Ubah",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                                new Container(
                                  height: 50.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(top: 20, left: 40),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Password',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.only(right: 40),
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      new Manajemen_Password(
                                                        id_user: id_user,
                                                        password: password,
                                                      )));
                                            },
                                            child: Text(
                                              "Ubah",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                                new Container(
                                  height: 50.0,
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
                            new Container(
                              width: 20.0,
                            ),
                            Text(
                              "Simpan Perubahan",
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
