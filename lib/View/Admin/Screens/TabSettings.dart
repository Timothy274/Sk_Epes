import 'package:flutter/material.dart';
import 'package:kios_epes/View/Admin/Laporan/Laporan_List.dart';
import 'package:kios_epes/View/Admin/Settings/Manajemen_Akun.dart';
import 'package:kios_epes/View/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tab_Settings_Admin extends StatefulWidget {
  const Tab_Settings_Admin({Key key}) : super(key: key);

  @override
  _Tab_Settings_AdminState createState() => _Tab_Settings_AdminState();
}

class _Tab_Settings_AdminState extends State<Tab_Settings_Admin> {
  void _showdialogLogout() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Perhatian Logout"),
          content: new Text("Jika anda keluar maka anda harus melakukan login ulang kembali"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Proses"),
              onPressed: () {
                exit();
              },
            ),
          ],
        );
      },
    );
  }

  Future exit() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new MyApp()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Color.fromRGBO(159, 249, 243, 98),
        alignment: Alignment(0, 0),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
                padding: const EdgeInsets.only(bottom: 40),
                child: new Text(
                  "Pengaturan Akun",
                  style: TextStyle(fontSize: 30.0, fontFamily: 'Poppins'),
                ),
                alignment: Alignment.topCenter),
            Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: new SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new Laporan_List()));
                      },
                      child: const Text('Laporan',
                          style: TextStyle(fontSize: 20, fontFamily: 'Poppins')),
                    ))),
            Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: new SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new Manajemen_Akun()));
                      },
                      child: const Text('Manajemen Akun',
                          style: TextStyle(fontSize: 20, fontFamily: 'Poppins')),
                    ))),
            Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: new SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.red,
                      onPressed: () {
                        _showdialogLogout();
                      },
                      child: const Text('Log Out',
                          style: TextStyle(fontSize: 20, fontFamily: 'Poppins')),
                    ))),
          ]),
        ));
  }
}
