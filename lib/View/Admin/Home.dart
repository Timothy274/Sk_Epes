import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kios_epes/View/Admin/Screens/TabHome.dart';
import 'package:kios_epes/View/Admin/Screens/TabPegawai.dart';
import 'package:kios_epes/View/Admin/Screens/TabProgress.dart';
import 'package:kios_epes/View/Admin/Screens/TabSettings.dart';
import 'package:kios_epes/View/Admin/Screens/TabStok.dart';
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:http/http.dart' as http;

class Home_Admin extends StatefulWidget {
  const Home_Admin({Key key}) : super(key: key);

  @override
  _Home_AdminState createState() => _Home_AdminState();
}

class _Home_AdminState extends State<Home_Admin> {
  int tabIndex = 0;
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _cek1 = [];
  List<DataBarang> _cek2 = [];
  List<Widget> listScreen;

  void initState() {
    super.initState();
    listScreen = [
      Tab_Home_Admin(),
      Tab_Progress_Admin(),
      Tab_Pegawai_Dart(),
      Tab_Settings_Admin(),
      Tab_Stok_Admin()
    ];
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
            icon: Icon(Icons.timelapse),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pegawai',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspaces_filled),
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
