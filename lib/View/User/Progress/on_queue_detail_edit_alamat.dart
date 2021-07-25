import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/User/Home.dart';

class on_queue_detail_edit_alamat extends StatefulWidget {
  String id_pemesanan, alamat, catatan;
  on_queue_detail_edit_alamat({Key key, this.id_pemesanan, this.alamat, this.catatan})
      : super(key: key);

  @override
  _on_queue_detail_edit_alamatState createState() => _on_queue_detail_edit_alamatState();
}

class _on_queue_detail_edit_alamatState extends State<on_queue_detail_edit_alamat> {
  TextEditingController alamat = TextEditingController();
  TextEditingController catatan = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  void initState() {
    super.initState();
    alamat = new TextEditingController(text: widget.alamat);
    catatan = new TextEditingController(text: widget.catatan);
    print(widget.catatan);
  }

  void kirim() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/update_pesanan_order_masuk.php"));
    http.post(url, body: {
      "id_pemesanan": widget.id_pemesanan,
      "alamat": alamat.text,
      "catatan": catatan.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: const Text('Detail Pesanan'),
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
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: alamat,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(labelText: "Alamat"),
                                  validator: (val1) {
                                    if (val1 == null || val1.isEmpty) {
                                      return "Masukkan Alamat";
                                    }
                                    return null;
                                  },
                                ),
                                new Container(
                                  height: 50.0,
                                ),
                                TextField(
                                    controller: catatan,
                                    maxLength: 100,
                                    maxLines: 4,
                                    decoration: new InputDecoration(labelText: "Catatan")),
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
                            kirim();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
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
                            new Container(
                              width: 20.0,
                            ),
                            Text(
                              "Ubah Alamat",
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
