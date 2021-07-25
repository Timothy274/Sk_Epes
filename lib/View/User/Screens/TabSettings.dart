import 'package:flutter/material.dart';
import 'package:kios_epes/View/User/Akun/manajemen_akun.dart';

class TabSettings extends StatefulWidget {
  const TabSettings({Key key}) : super(key: key);

  @override
  _TabSettingsState createState() => _TabSettingsState();
}

class _TabSettingsState extends State<TabSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Color.fromRGBO(159, 249, 243, 98),
        alignment: Alignment(0, 0),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Stack(
              children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: new Text(
                      "Pengaturan Akun",
                      style: TextStyle(fontSize: 30.0, fontFamily: 'Poppins'),
                    ),
                    alignment: AlignmentDirectional.topCenter)
              ],
            ),
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
                        // logout();
                      },
                      child: const Text('Log Out',
                          style: TextStyle(fontSize: 20, fontFamily: 'Poppins')),
                    ))),
          ]),
        ));
  }
}
