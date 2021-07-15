import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/View/User/Progress/on_queue_detail.dart';

class TabProgress extends StatefulWidget {
  const TabProgress({Key key}) : super(key: key);

  @override
  _TabProgressState createState() => _TabProgressState();
}

class _TabProgressState extends State<TabProgress> with TickerProviderStateMixin {
  TabController _nestedTabController;
  List _selectedId = [];

  Future<List> getData() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan.php"));
    return json.decode(response.body);
  }

  void initState() {
    super.initState();
    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: "Antrian Pesanan",
            ),
            Tab(
              text: "Sedang Pengiriman",
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.70,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              _inheritedqueue(),
              _inheritongoing(),
            ],
          ),
        )
      ],
    );
  }

  Widget _inheritongoing() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black,
      ),
    );
  }

  Widget _inheritedqueue() {
    return Expanded(
        child: Container(
      child: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: new GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) => new on_queue_detail(
                                    id_pemesanan: snapshot.data[i]["id_pemesanan"],
                                    alamat: snapshot.data[i]["alamat"],
                                    tanggal: snapshot.data[i]["tanggal"],
                                    catatan: snapshot.data[i]["catatan"],
                                  )));
                        },
                        child: new Card(
                            child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: new ListTile(
                                  title: new Text(
                                    snapshot.data[i]['alamat'],
                                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                                  ),
                                  subtitle: new Text(
                                    "Pengantar : ${snapshot.data[i]['nama_pegawai']}",
                                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20.0),
                                child: Checkbox(
                                  value: _selectedId.contains(snapshot.data[i]['id_pemesanan']),
                                  onChanged: (bool selected) {},
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ],
                          ),
                        )),
                      ),
                    );
                  },
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
          ;
        },
      ),
    ));
  }
}
