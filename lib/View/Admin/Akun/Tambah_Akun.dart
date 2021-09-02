import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataAkun.dart';
import 'package:kios_epes/View/Admin/Home.dart';
import 'dart:convert';

class Tambah_Akun extends StatefulWidget {
  const Tambah_Akun({Key key}) : super(key: key);

  @override
  _Tambah_AkunState createState() => _Tambah_AkunState();
}

class _Tambah_AkunState extends State<Tambah_Akun> {
  final _formKey = new GlobalKey<FormState>();
  FocusNode focusNode = new FocusNode();
  TextEditingController nama = TextEditingController();
  TextEditingController nama_lengkap = TextEditingController();
  TextEditingController no_telp = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  List<DataAkun> _dataAkun = [];
  List<String> akses = ["Admin", "Non-Admin"];
  String _mySelection2;

  var tahun = Jiffy().format("yyyy-MM-dd");
  var waktu = Jiffy().format("HH:mm:SS");
  var year = Jiffy().format("yyyy");
  var bulan = Jiffy().format("MM");
  var tanggal = Jiffy().format("dd");
  var jam = Jiffy().format("HH");
  var menit = Jiffy().format("mm");
  var detik = Jiffy().format("SS");

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
    });
  }

  void push_db() {
    for (int a = 0; a < _dataAkun.length; a++) {
      if (_dataAkun[a].username == username.text) {
        _showDialogerror();
      } else {
        if (username.text.contains(" ") ||
            password.text.contains(" ") ||
            no_telp.text.contains(" ")) {
          _showDialogerrorspasi();
        } else {
          String id;
          id = jam + menit + detik + tanggal + bulan + year + nama.text;
          var url = (Uri.parse("http://timothy.buzz/kios_epes/Akun/add_user.php"));
          http.post(url, body: {
            "id_user": id,
            "nama_lengkap_user": nama_lengkap.text,
            "nama_user": nama.text,
            "no_telp": no_telp.text,
            "username": username.text,
            "password": password.text,
            "akses": _mySelection2,
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => new Home_Admin()),
            (Route<dynamic> route) => false,
          );
          // print(id);
          // print();
          // print();
          // print();
          // print();
          // print();
          // print();
        }
      }
    }
  }

  void _showDialogerror() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Penamabahan Error"),
          content: new Text(
              "Username yang dimasukkan sama dengan akun lain, mohon untuk mengubah nama username yang anda masukkan"),
          actions: <Widget>[
            new ElevatedButton(
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

  void _showDialogerrorspasi() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Penamabahan Error"),
          content: new Text(
              "Mohon periksa inputan anda di username, password, maupun nomor telepon untuk tidak memberikan spasi"),
          actions: <Widget>[
            new ElevatedButton(
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Tambah Akun'),
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
                                  decoration:
                                      new InputDecoration(labelText: "Nama Lengkap Pegawai"),
                                  validator: (val1) {
                                    if (val1 == null || val1.isEmpty) {
                                      return "Masukkan Nama Lengkap Pegawai";
                                    }
                                    return null;
                                  },
                                ),
                                Divider(height: 50.0),
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
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
                                Divider(height: 50.0),
                                TextFormField(
                                  controller: username,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Username"),
                                  maxLength: 15,
                                  validator: (val4) {
                                    if (val4 == null || val4.isEmpty) {
                                      return "Masukkan Username";
                                    }
                                    return null;
                                  },
                                ),
                                Divider(height: 50.0),
                                TextFormField(
                                  controller: password,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Password"),
                                  maxLength: 10,
                                  obscureText: true,
                                  validator: (val5) {
                                    if (val5 == null || val5.isEmpty) {
                                      return "Masukkan Password";
                                    }
                                    return null;
                                  },
                                ),
                                Divider(height: 50.0),
                                Container(
                                  width: screenWidth,
                                  // margin:
                                  //     const EdgeInsets.only(top: 10, bottom: 20, left: 40.0, right: 40.0),
                                  child: DropdownButtonFormField<String>(
                                    onTap: () {
                                      focusNode.unfocus();
                                    },
                                    items: akses.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (String newValueSelected) {
                                      setState(() {
                                        this._mySelection2 = newValueSelected;
                                      });
                                    },
                                    hint: Text('Pilih Akses'),
                                    value: _mySelection2,
                                    validator: (val6) {
                                      if (val6 == null || val6.isEmpty) {
                                        return "Masukkan Akses";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Divider(height: 50.0),
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
                            push_db();
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
                              "Tambah Pegawai",
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
