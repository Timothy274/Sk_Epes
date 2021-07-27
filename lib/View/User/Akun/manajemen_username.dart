import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/User/Home.dart';

class Manajemen_Username extends StatefulWidget {
  String id_user, username;
  Manajemen_Username({Key key, this.id_user, this.username}) : super(key: key);

  @override
  _Manajemen_UsernameState createState() => _Manajemen_UsernameState();
}

class _Manajemen_UsernameState extends State<Manajemen_Username> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController username_lama = TextEditingController();
  TextEditingController username_baru = TextEditingController();

  void initState() {
    super.initState();
    username_lama = TextEditingController(text: widget.username);
  }

  void push_db() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Akun/update_profil_username.php"));
    http.post(url, body: {
      "id_akun": widget.id_user,
      "username": username_baru.text,
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
        title: const Text('Ubah Username'),
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
                            controller: username_lama,
                            enabled: false,
                            decoration: new InputDecoration(labelText: "Username Lama"),
                          ),
                          Divider(height: 50.0),
                          TextFormField(
                            controller: username_baru,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(labelText: "Username Baru"),
                            maxLength: 15,
                            validator: (val1) {
                              if (val1 == null || val1.isEmpty) {
                                return "Masukkan Username";
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
                              push_db();
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
