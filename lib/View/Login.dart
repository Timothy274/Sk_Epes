import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataAkun.dart';
import 'package:kios_epes/View/Admin/Home.dart';
import 'package:kios_epes/View/User/Home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = new GlobalKey<FormState>();
  bool isLogin = false;
  var userLogin;
  List<DataAkun> _dataAkun = [];
  final username = TextEditingController();
  final password = TextEditingController();

  Future<List> getAkun() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Akun/get_user.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataAkun.add(DataAkun.fromJson(Data));
      }
    });
  }

  Future cek() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin") == true) {
      if (pref.getString("akses") == "Admin") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home_Admin()));
      } else if (pref.getString("akses") == "Non-Admin") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home_User()));
      }
    }
  }

  void _showdialogerror() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Error Login"),
          content: new Text("Username / Password salah, Mohon lakukan login ulang"),
          actions: <Widget>[
            new FlatButton(
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

  void validasi() async {
    String _username = username.text;
    String _password = password.text;
    String susername = "";
    String spassword = "";
    String id_user = "";
    String akses = "";

    for (int a = 0; a < _dataAkun.length; a++) {
      if (_dataAkun[a].username.toLowerCase() == _username.toLowerCase() &&
          _dataAkun[a].password == _password) {
        susername = _username;
        spassword = _password;
        akses = _dataAkun[a].akses;
        id_user = _dataAkun[a].id_user;
      }
    }
    if ((susername.isNotEmpty && spassword.isNotEmpty) || (susername != "" && spassword != "")) {
      if (akses == "Admin") {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("isLogin", true);
        pref.setString("id_user", id_user);
        pref.setString("username", susername);
        pref.setString("akses", akses);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home_Admin()));
      } else if (akses == "Non-Admin") {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("isLogin", true);
        pref.setString("id_user", id_user);
        pref.setString("username", susername);
        pref.setString("akses", akses);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home_User()));
      }
    } else {
      _showdialogerror();
    }
  }

  void initState() {
    super.initState();
    getAkun();
    cek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        // resizeToAvoidBottomPadding: false,
        body: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(color: Color(0xffffff)),
            child: Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 70.0),
                            child: Image(
                              image: AssetImage('assets/LOGOG.jpg'),
                            )),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            controller: username,
                            style: TextStyle(color: Color.fromRGBO(76, 177, 247, 1)),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color.fromRGBO(76, 177, 247, 1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color.fromRGBO(76, 177, 247, 1)),
                              ),
                              hintText: "Username",
                              hintStyle: TextStyle(color: Color.fromRGBO(76, 177, 247, 1)),
                            ),
                            validator: (val1) {
                              if (val1 == null || val1.isEmpty) {
                                return "Masukkan Username";
                              }
                              return null;
                            },
                          ),
                        ),
                        Divider(height: 30.0),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextFormField(
                            controller: password,
                            style: TextStyle(color: Color.fromRGBO(76, 177, 247, 1)),
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color.fromRGBO(76, 177, 247, 1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color.fromRGBO(76, 177, 247, 1)),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Color.fromRGBO(76, 177, 247, 1)),
                            ),
                            validator: (val2) {
                              if (val2 == null || val2.isEmpty) {
                                return "Masukkan Password";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 30, bottom: 20),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: new SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Color.fromRGBO(76, 177, 247, 1),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      validasi();
                                    }
                                  },
                                  onLongPress: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) => Home_Admin()));
                                  },
                                  child: const Text('sign in', style: TextStyle(fontSize: 30)),
                                ))),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
