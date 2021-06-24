import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataBarang.dart';

class User_kasir_Lanjutan extends StatefulWidget {
  final List<DataBarang> data;
  const User_kasir_Lanjutan({Key key, this.data}) : super(key: key);

  @override
  _User_kasir_LanjutanState createState() => _User_kasir_LanjutanState();
}

class _User_kasir_LanjutanState extends State<User_kasir_Lanjutan> {
  void add(nilai_awal, i, harga_awal) {
    setState(() {
      // int harga = int.parse(harga_awal.toString());
      // int total = int.parse(nilai_awal.toString());
      nilai_awal++;
      harga_awal = harga_awal * nilai_awal;
      for (int a = 0; a < widget.data.length; a++) {
        if (widget.data[a].id_barang == i) {
          widget.data[a].nilai_awal = nilai_awal;
          widget.data[a].Harga = harga_awal;
        }
      }
    });
  }

  void minus(nilai_awal, i, harga_awal) {
    setState(() {
      if (nilai_awal != 0) {
        nilai_awal--;
        harga_awal = harga_awal * nilai_awal;
        for (int a = 0; a < widget.data.length; a++) {
          if (widget.data[a].id_barang == i) {
            widget.data[a].nilai_awal = nilai_awal;
            widget.data[a].Harga = harga_awal;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kios Epes'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.blue, width: 2.0)),
              child: Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Alamat",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Pengirim",
                      style: TextStyle(fontSize: 18),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Edit",
                            style: TextStyle(fontSize: 15),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 6,
              child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ListView.builder(
                    itemCount: widget.data.length,
                    itemBuilder: (context, i) {
                      return Container(
                          // padding: const EdgeInsets.all(10.0),
                          child: new Card(
                              child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              leading: Icon(Icons.book),
                              title: new Text(widget.data[i].Nama, style: TextStyle(fontSize: 18)),
                              subtitle: Text(widget.data[i].Harga_Tetap.toString(),
                                  style: TextStyle(fontSize: 13)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new IconButton(
                                        icon: const Icon(Icons.remove),
                                        // iconSize: 50,
                                        onPressed: () => minus(widget.data[i].nilai_awal,
                                            widget.data[i].id_barang, widget.data[i].Harga_Tetap)),
                                    new Container(
                                      // margin: const EdgeInsets.only(
                                      //     left: 10, right: 10),
                                      child: Text(widget.data[i].nilai_awal.toString(),
                                          style: new TextStyle(fontSize: 20.0)),
                                    ),
                                    new IconButton(
                                        icon: const Icon(Icons.add),
                                        // iconSize: 50,
                                        onPressed: () => add(widget.data[i].nilai_awal,
                                            widget.data[i].id_barang, widget.data[i].Harga_Tetap)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Text("Rp." + widget.data[i].Harga.toString()),
                              )
                            ],
                          )
                        ],
                      )));
                    },
                  ))),
          Expanded(
            flex: 2,
            child: Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.blue, width: 2.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Modal',
                                  style: new TextStyle(fontSize: 18.0),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Total',
                                  style: new TextStyle(fontSize: 18.0),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Kembalian',
                                  style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  ":",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  ":",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  ":",
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        verticalDirection: VerticalDirection.down,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Modal',
                                  style: new TextStyle(fontSize: 18.0),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Total',
                                  style: new TextStyle(fontSize: 18.0),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Kembalian',
                                  style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        Text(
                          "Order",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    )),
              )),
        ],
      ),
    );
  }
}
