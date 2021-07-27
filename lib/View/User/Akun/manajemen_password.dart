import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/User/Home.dart';

class Manajemen_Password extends StatefulWidget {
  String id_user, password;
  Manajemen_Password({Key key, this.id_user, this.password}) : super(key: key);

  @override
  _Manajemen_PasswordState createState() => _Manajemen_PasswordState();
}

class _Manajemen_PasswordState extends State<Manajemen_Password> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController password_konfirmasi = TextEditingController();

  void konfirmasi() {
    if (password.text == widget.password) {
      _showDialogerrorlama();
    } else {
      if (password.text != password_konfirmasi.text) {
        _showDialogerrorsama();
      } else {
        push_db();
      }
    }
  }

  void _showDialogerrorlama() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Perubahan Tertunda"),
          content: new Text(
              "Password yang anda masukkan, sama dengan password anda sebelumnya. Mohon untuk merubah kembali password baru anda"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
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

  void _showDialogerrorsama() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Perubahan Tertunda"),
          content: new Text("Password yang anda masukkan tidak sama mohon periksa kembali"),
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

  void push_db() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Akun/update_profil_password.php"));
    http.post(url, body: {
      "id_akun": widget.id_user,
      "password": password.text,
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Ubah Password'),
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
                            controller: password,
                            decoration: new InputDecoration(labelText: "Password"),
                            maxLength: 10,
                            validator: (val1) {
                              if (val1 == null || val1.isEmpty) {
                                return "Masukkan Password";
                              }
                              return null;
                            },
                          ),
                          Divider(height: 50.0),
                          TextFormField(
                            controller: password_konfirmasi,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(labelText: "Konfirmasi Password"),
                            maxLength: 10,
                            validator: (val2) {
                              if (val2 == null || val2.isEmpty) {
                                return "Masukkan Password";
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
                              konfirmasi();
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
