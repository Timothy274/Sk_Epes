import 'package:flutter/material.dart';
import 'package:kios_epes/Admin/Home.dart';
import 'package:kios_epes/User/Home.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffff)),
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 70.0),
                        child: FlutterLogo(
                          size: 100,
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextField(
                        // controller: username,
                        style:
                            TextStyle(color: Color.fromRGBO(76, 177, 247, 1)),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(76, 177, 247, 1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(76, 177, 247, 1)),
                          ),
                          hintText: "Username",
                          hintStyle:
                              TextStyle(color: Color.fromRGBO(76, 177, 247, 1)),
                        ),
                      ),
                    ),
                    Divider(height: 30.0),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextField(
                        // controller: password,
                        style:
                            TextStyle(color: Color.fromRGBO(76, 177, 247, 1)),
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(76, 177, 247, 1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(76, 177, 247, 1)),
                          ),
                          hintText: "Password",
                          hintStyle:
                              TextStyle(color: Color.fromRGBO(76, 177, 247, 1)),
                        ),
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
                                // validasi();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home_User()));
                              },
                              onLongPress: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home_Admin()));
                              },
                              child: const Text('sign in',
                                  style: TextStyle(fontSize: 30)),
                            ))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
