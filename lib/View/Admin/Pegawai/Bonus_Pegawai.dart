import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/Admin/Home.dart';

class Bonus_Pegawai extends StatefulWidget {
  String id_pegawai;
  int bonus_thr, bonus_bulanan, bonus_barang, bonus_pengiriman;
  Bonus_Pegawai(
      {Key key,
      this.id_pegawai,
      this.bonus_barang,
      this.bonus_pengiriman,
      this.bonus_bulanan,
      this.bonus_thr})
      : super(key: key);

  @override
  _Bonus_PegawaiState createState() => _Bonus_PegawaiState();
}

class _Bonus_PegawaiState extends State<Bonus_Pegawai> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController bonus_thr = TextEditingController();
  TextEditingController bonus_bulanan = TextEditingController();
  TextEditingController bonus_barang = TextEditingController();
  TextEditingController bonus_pengiriman = TextEditingController();

  void initState() {
    super.initState();
    bonus_thr = new TextEditingController(text: widget.bonus_thr.toString());
    bonus_bulanan = new TextEditingController(text: widget.bonus_bulanan.toString());
    bonus_barang = new TextEditingController(text: widget.bonus_barang.toString());
    bonus_pengiriman = new TextEditingController(text: widget.bonus_pengiriman.toString());
  }

  void push_db() {
    if (bonus_thr.text == "") {
      bonus_thr.text = "0";
    }
    if (bonus_bulanan.text == "") {
      bonus_bulanan.text = "0";
    }
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pegawai/update_pegawai_bonus.php"));
    http.post(url, body: {
      "id_pegawai": widget.id_pegawai,
      "bonus_thr": bonus_thr.text,
      "bonus_bulanan": bonus_bulanan.text,
      "bonus_barang": bonus_barang.text,
      "bonus_pengiriman": bonus_pengiriman.text,
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
                            controller: bonus_thr,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(labelText: "Bonus THR"),
                          ),
                          Divider(height: 50.0),
                          TextFormField(
                            controller: bonus_bulanan,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(labelText: "Bonus Bulanan"),
                          ),
                          Divider(height: 50.0),
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
                            controller: bonus_pengiriman,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(labelText: "Bonus Pengiriman"),
                            validator: (val4) {
                              if (val4 == null || val4.isEmpty) {
                                return "Masukkan Bonus Pengiriman";
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
