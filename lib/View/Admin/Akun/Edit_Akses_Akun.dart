import 'package:flutter/material.dart';
import 'package:kios_epes/View/Admin/Home.dart';
import 'package:http/http.dart' as http;

class Edit_Akun_Akses extends StatefulWidget {
  String id_user, akses;
  Edit_Akun_Akses({Key key, this.id_user, this.akses}) : super(key: key);

  @override
  _Edit_Akun_AksesState createState() => _Edit_Akun_AksesState();
}

class _Edit_Akun_AksesState extends State<Edit_Akun_Akses> {
  TextEditingController akses_lama = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  String _mySelection2;
  List<String> akses = ["Admin", "Non-Admin"];

  void initState() {
    super.initState();
    akses_lama = TextEditingController(text: widget.akses);
  }

  void push_db() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Akun/update_profil_akses.php"));
    http.post(url, body: {"id_akun": widget.id_user, "akses": _mySelection2});
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new Home_Admin()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Ubah Profil Pegawai'),
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
                                  controller: akses_lama,
                                  decoration: new InputDecoration(labelText: "Akses"),
                                  enabled: false,
                                ),
                                Divider(height: 50.0),
                                Container(
                                  width: screenWidth,
                                  // margin:
                                  //     const EdgeInsets.only(top: 10, bottom: 20, left: 40.0, right: 40.0),
                                  child: DropdownButtonFormField<String>(
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
    );
  }
}
