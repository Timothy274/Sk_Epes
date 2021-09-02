import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/Admin/Home.dart';

class Tambah_Pegawai extends StatefulWidget {
  const Tambah_Pegawai({Key key}) : super(key: key);

  @override
  _Tambah_PegawaiState createState() => _Tambah_PegawaiState();
}

class _Tambah_PegawaiState extends State<Tambah_Pegawai> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController nama_lengkap = TextEditingController();
  TextEditingController bonus_thr = TextEditingController();
  TextEditingController bonus_absensi = TextEditingController();
  TextEditingController bonus_barang = TextEditingController();
  TextEditingController bonus_pengiriman = TextEditingController();

  var tahun = Jiffy().format("yyyy-MM-dd");
  var waktu = Jiffy().format("HH:mm:SS");
  var year = Jiffy().format("yyyy");
  var bulan = Jiffy().format("MM");
  var tanggal = Jiffy().format("dd");
  var jam = Jiffy().format("HH");
  var menit = Jiffy().format("mm");
  var detik = Jiffy().format("SS");

  void push_db() {
    if (bonus_thr.text == "") {
      bonus_thr.text = "0";
    }
    if (bonus_absensi.text == "") {
      bonus_absensi.text = "0";
    }
    String id;
    id = tanggal + bulan + year + nama.text;
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pegawai/add_pegawai.php"));
    http.post(url, body: {
      "id_pegawai": id,
      "nama_lengkap_pegawai": nama_lengkap.text,
      "nama_pegawai": nama.text,
      "bonus_absensi": bonus_absensi.text,
      "bonus_barang": bonus_barang.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Tambah Pegawai'),
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
                                Divider(height: 50.0),
                                TextFormField(
                                  controller: bonus_absensi,
                                  keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(labelText: "Bonus Absensi"),
                                  validator: (val3) {
                                    if (val3 == null || val3.isEmpty) {
                                      return "Masukkan Bonus Absensi";
                                    }
                                    return null;
                                  },
                                ),
                                Divider(height: 50.0),
                                TextFormField(
                                  controller: bonus_barang,
                                  keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(labelText: "Bonus Barang"),
                                  validator: (val4) {
                                    if (val4 == null || val4.isEmpty) {
                                      return "Masukkan Bonus Barang";
                                    }
                                    return null;
                                  },
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
