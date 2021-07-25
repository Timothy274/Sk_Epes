import 'package:flutter/material.dart';

class Manajemen_Akun extends StatefulWidget {
  const Manajemen_Akun({Key key}) : super(key: key);

  @override
  _Manajemen_AkunState createState() => _Manajemen_AkunState();
}

class _Manajemen_AkunState extends State<Manajemen_Akun> {
  TextEditingController nama_lengkap = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController no_telp = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
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
                                TextFormField(
                                  maxLength: 15,
                                  textCapitalization: TextCapitalization.words,
                                  controller: username,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Username"),
                                  validator: (val3) {
                                    if (val3 == null || val3.isEmpty) {
                                      return "Masukkan Username";
                                    }
                                    return null;
                                  },
                                ),
                                new Container(
                                  height: 50.0,
                                ),
                                TextFormField(
                                  maxLength: 10,
                                  textCapitalization: TextCapitalization.words,
                                  controller: password,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: new InputDecoration(labelText: "Password"),
                                  validator: (val4) {
                                    if (val4 == null || val4.isEmpty) {
                                      return "Masukkan Password";
                                    }
                                    return null;
                                  },
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
                            // kirim();
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
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
