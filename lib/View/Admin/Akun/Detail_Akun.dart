import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataAkun.dart';
import 'package:kios_epes/View/Admin/Akun/Edit_Akses_Akun.dart';
import 'package:kios_epes/View/Admin/Akun/Edit_Password_Akun.dart';
import 'package:kios_epes/View/Admin/Akun/Edit_Profil_Akun.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/Admin/Akun/Edit_Username_Akun.dart';
import 'package:kios_epes/View/Admin/Home.dart';

class Detail_Akun extends StatefulWidget {
  List<DataAkun> list;
  Detail_Akun({
    Key key,
    this.list,
  }) : super(key: key);

  @override
  _Detail_AkunState createState() => _Detail_AkunState();
}

class _Detail_AkunState extends State<Detail_Akun> {
  String id_user;
  String nama_lengkap = "";
  String no_telp = "";
  String username = "";
  String password = "";
  String akses = "";
  String nama = "";

  void initState() {
    super.initState();
    id_user = widget.list[0].id_user;
    nama_lengkap = widget.list[0].nama_lengkap;
    nama = widget.list[0].nama;
    no_telp = widget.list[0].no_telp;
    username = widget.list[0].username;
    password = widget.list[0].password;
    akses = widget.list[0].akses;
  }

  void _showdialogkonfirmasihapus() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Konfirmasi Penghapusan"),
          content: new Text(
              "Apakah anda yakin ingin menghapus akun user berikut, Jika anda menghapus pegawai maka semua data user akan hilang"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Hapus"),
              onPressed: () {
                hapususer();
              },
            ),
          ],
        );
      },
    );
  }

  void hapususer() {
    var url = Uri.parse("http://timothy.buzz/kios_epes/Akun/delete_user.php");
    http.post(url, body: {
      "id_user": id_user,
    });
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
      body: Container(
        color: Color(0xffffff),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blue, width: 2.0)),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: Icon(
                                Icons.account_circle,
                                size: 100,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 20, bottom: 25),
                              child: Text(
                                nama_lengkap,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin:
                          const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blue, width: 2.0)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 20),
                            alignment: Alignment(-1.0, -1.0),
                            child: Text(
                              'Data Diri Pegawai',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Container(
                              // margin: const EdgeInsets.only(top: 20, bottom: 20),
                              // padding: const EdgeInsets.only(left: 40),
                              alignment: Alignment(-1.0, -1.0),
                              child: Column(
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(top: 20, left: 40),
                                        alignment: Alignment(-1.0, -1.0),
                                        child: Text(
                                          'Nama Lengkap',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                                        padding: const EdgeInsets.only(left: 40),
                                        alignment: Alignment(-1.0, -1.0),
                                        child: Text(
                                          nama_lengkap,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(top: 20, left: 40),
                                        alignment: Alignment(-1.0, -1.0),
                                        child: Text(
                                          'Nama',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                                        padding: const EdgeInsets.only(left: 40),
                                        alignment: Alignment(-1.0, -1.0),
                                        child: Text(
                                          nama,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(top: 20, left: 40),
                                        alignment: Alignment(-1.0, -1.0),
                                        child: Text(
                                          'Nomor Telepon',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                                        padding: const EdgeInsets.only(left: 40),
                                        alignment: Alignment(-1.0, -1.0),
                                        child: Text(
                                          no_telp,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new Edit_Profil_Akun(
                                            id_akun: id_user,
                                            nama: nama,
                                            nama_lengkap: nama_lengkap,
                                            no_telp: no_telp,
                                          )));
                                },
                                child: Text(
                                  "Ubah",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Container(height: 20)
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin:
                          const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blue, width: 2.0)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 20),
                            alignment: Alignment(-1.0, -1.0),
                            child: Text(
                              'Keamanan',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Container(
                              // margin: const EdgeInsets.only(top: 20, bottom: 20),
                              // padding: const EdgeInsets.only(left: 40),
                              alignment: Alignment(-1.0, -1.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          padding: const EdgeInsets.only(top: 20, left: 40),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Username',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        padding: const EdgeInsets.only(right: 40),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                        new Edit_Username_Akun(
                                                          id_user: id_user,
                                                          username: username,
                                                        )));
                                              },
                                              child: Text(
                                                "Ubah",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          padding: const EdgeInsets.only(top: 20, left: 40),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Password',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        padding: const EdgeInsets.only(right: 40),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                        new Edit_Password_Akun(
                                                          id_user: id_user,
                                                          password: password,
                                                        )));
                                              },
                                              child: Text(
                                                "Ubah",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Container(height: 20)
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin:
                          const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blue, width: 2.0)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 20, bottom: 20),
                            alignment: Alignment(-1.0, -1.0),
                            child: Text(
                              'Akses',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Container(
                              // margin: const EdgeInsets.only(top: 20, bottom: 20),
                              // padding: const EdgeInsets.only(left: 40),
                              alignment: Alignment(-1.0, -1.0),
                              child: Column(
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(top: 20, left: 40),
                                        alignment: Alignment(-1.0, -1.0),
                                        child: Text(
                                          'Akses',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                                        padding: const EdgeInsets.only(left: 40),
                                        alignment: Alignment(-1.0, -1.0),
                                        child: Text(
                                          akses,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new Edit_Akun_Akses(
                                            id_user: id_user,
                                            akses: akses,
                                          )));
                                },
                                child: Text(
                                  "Ubah",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Container(height: 20)
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 20),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: new SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              _showdialogkonfirmasihapus();
                            },
                            child: const Text('Hapus Akun', style: TextStyle(fontSize: 30)),
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
