import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/Admin/Home.dart';

class Bonus_Pegawai extends StatefulWidget {
  String id_pegawai;
  int bonus_absensi, bonus_barang;
  Bonus_Pegawai({
    Key key,
    this.id_pegawai,
    this.bonus_barang,
    this.bonus_absensi,
  }) : super(key: key);

  @override
  _Bonus_PegawaiState createState() => _Bonus_PegawaiState();
}

class _Bonus_PegawaiState extends State<Bonus_Pegawai> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController bonus_absensi = TextEditingController();
  TextEditingController bonus_barang = TextEditingController();

  void initState() {
    super.initState();

    bonus_absensi = new TextEditingController(text: widget.bonus_absensi.toString());
    bonus_barang = new TextEditingController(text: widget.bonus_barang.toString());
  }

  void push_db() {
    if (bonus_absensi.text == "") {
      bonus_absensi.text = "0";
    }
    if (bonus_barang.text == "") {
      bonus_barang.text = "0";
    }
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pegawai/update_pegawai_bonus.php"));
    http.post(url, body: {
      "id_pegawai": widget.id_pegawai,
      "bonus_absensi": bonus_absensi.text,
      "bonus_barang": bonus_barang.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Bonus Pegawai'),
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
                            controller: bonus_barang,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(labelText: "Bonus Barang"),
                            validator: (val3) {
                              if (val3 == null || val3.isEmpty) {
                                return "Masukkan Bonus Barang";
                              }
                              return null;
                            },
                          ),
                          Divider(height: 50.0),
                          TextFormField(
                            controller: bonus_absensi,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(labelText: "Bonus Absensi"),
                            validator: (val4) {
                              if (val4 == null || val4.isEmpty) {
                                return "Masukkan Bonus Absensi";
                              }
                              return null;
                            },
                          ),
                          Divider(height: 50.0),
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
                                Icons.edit,
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
