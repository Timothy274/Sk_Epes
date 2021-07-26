import 'package:flutter/material.dart';
import 'package:kios_epes/View/Admin/Home.dart';
import 'package:http/http.dart' as http;

class Edit_Username_Akun extends StatefulWidget {
  String id_user, username;
  Edit_Username_Akun({Key key, this.id_user, this.username}) : super(key: key);

  @override
  _Edit_Username_AkunState createState() => _Edit_Username_AkunState();
}

class _Edit_Username_AkunState extends State<Edit_Username_Akun> {
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
      MaterialPageRoute(builder: (BuildContext context) => new Home_Admin()),
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
