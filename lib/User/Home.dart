import 'package:flutter/material.dart';
import 'package:kios_epes/Map/DataBarang.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'Screens/TabHome.dart';
import 'Screens/TabProgress.dart';
import 'Screens/TabSettings.dart';
import 'Screens/TabStok.dart';

class Home_User extends StatefulWidget {
  const Home_User({Key key}) : super(key: key);

  @override
  _Home_UserState createState() => _Home_UserState();
}

GlobalKey<_Home_UserState> _home_key = GlobalKey();

class _Home_UserState extends State<Home_User> {
  int tabIndex = 0;
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _cek1 = [];
  List<DataBarang> _cek2 = [];
  List<Widget> listScreen;

  void initState() {
    super.initState();
    listScreen = [TabHome(), TabProgress(), TabStok(), TabSettings()];
  }

  Future<List<DataBarang>> getBarang() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/juljol/get_barang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  Future<List<DataBarang>> getCek() async {
    final responseA =
        await http.get(Uri.parse("http://timothy.buzz/juljol/get_odr_msk_join_odr_msk_detail.php"));
    final responseJsonA = json.decode(responseA.body);
    final responseB = await http
        .get(Uri.parse("http://timothy.buzz/juljol/get_pemesanan_detail_only_proses.php"));
    final responseJsonB = json.decode(responseB.body);
    setState(() {
      for (Map Data in responseJsonA) {
        _cek1.add(DataBarang.fromJson(Data));
      }
      for (Map Data in responseJsonB) {
        _cek2.add(DataBarang.fromJson(Data));
      }
    });
  }

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Kios Epes'),
      ),
      body: Center(
        child: listScreen[tabIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Stok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Lainnya',
          ),
        ],
        currentIndex: tabIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
