import 'package:flutter/material.dart';

class TabSettings extends StatefulWidget {
  const TabSettings({Key key}) : super(key: key);

  @override
  _TabSettingsState createState() => _TabSettingsState();
}

class _TabSettingsState extends State<TabSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    color: Colors.cyan,
                  )),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    color: Colors.yellow,
                  ))
            ],
          ),
          Row(
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    color: Colors.cyan,
                  )),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    color: Colors.yellow,
                  ))
            ],
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(76, 177, 247, 1),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  )),
              margin: const EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
              child: Column(
                children: [
                  TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      // controller: alamat,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(labelText: "Alamat"),
                      validator: (val) =>
                          val.length == 1 ? "Masukkan alamat" : null),
                  Divider(height: 50.0),
                  new Container(
                    width: 270.0,
                  ),
                  TextField(
                      // controller: catatan,
                      maxLength: 100,
                      maxLines: 4,
                      decoration: new InputDecoration(labelText: "Catatan")),
                  Divider(height: 50.0),
                  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.only(left: 60, right: 60),
                      alignment: Alignment(-1.0, -1.0),
                      child: new SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Color.fromRGBO(76, 177, 247, 1),
                            onPressed: () {},
                            child: const Text('Buat Order',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black))),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
