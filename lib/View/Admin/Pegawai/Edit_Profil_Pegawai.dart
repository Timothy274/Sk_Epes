import 'package:flutter/material.dart';

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

  void initState() {
    super.initState();
    nama = TextEditingController(text: widget.nama);
    nama_lengkap = TextEditingController(text: widget.nama_lengkap);
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
                              // push_db();
                              // Navigator.pushAndRemoveUntil(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (BuildContext context) => new Home_Admin()),
                              //   (Route<dynamic> route) => false,
                              // );
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
