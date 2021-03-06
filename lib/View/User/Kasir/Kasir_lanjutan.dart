import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/Model/DataPegawai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import '../Home.dart';

class User_kasir_Lanjutan extends StatefulWidget {
  final List<DataBarang> data;
  final String alamat, catatan;
  const User_kasir_Lanjutan({Key key, this.data, this.alamat, this.catatan}) : super(key: key);

  @override
  _User_kasir_LanjutanState createState() => _User_kasir_LanjutanState();
}

class _User_kasir_LanjutanState extends State<User_kasir_Lanjutan> {
  final oCcy = new NumberFormat.currency(locale: 'id');
  int total_hitung = 0;
  int kembalian_hitung = 0;
  int modal_hitung = 0;
  List<DataBarang> _dataBarang = [];
  String id;
  String id_user;

  var tahun = Jiffy().format("yyyy-MM-dd");
  var waktu = Jiffy().format("HH:mm:SS");
  var year = Jiffy().format("yyyy");
  var bulan = Jiffy().format("MM");
  var tanggal = Jiffy().format("dd");
  var jam = Jiffy().format("HH");
  var menit = Jiffy().format("mm");
  var detik = Jiffy().format("SS");

  void initState() {
    super.initState();
    // getSWData();
    total();
    id_pemesanan();
    cek();
  }

  // Future<void> test() async {
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm80, profile);
  //   List<int> bytes = [];

  //   bytes += generator.text(
  //       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  //   bytes +=
  //       generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
  //   bytes += generator.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

  //   bytes += generator.text('Bold text', styles: PosStyles(bold: true));
  //   bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
  //   bytes += generator.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
  //   bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
  //   bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
  //   bytes += generator.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  //   bytes += generator.row([
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col6',
  //       width: 6,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //     PosColumn(
  //       text: 'col3',
  //       width: 3,
  //       styles: PosStyles(align: PosAlign.center, underline: true),
  //     ),
  //   ]);

  //   bytes += generator.text('Text size 200%',
  //       styles: PosStyles(
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ));

  //   bytes += generator.feed(2);
  //   bytes += generator.cut();
  //   return bytes;
  // }

  // launchWhatsApp() async {
  //   final link = WhatsAppUnilink(
  //     phoneNumber: '+6288808106020',
  //     text: "Hey! I'm inquiring about the apartment listing",
  //   );
  //   // Convert the WhatsAppUnilink instance to a string.
  //   // Use either Dart's string interpolation or the toString() method.
  //   // The "launch" method is part of "url_launcher".
  //   await launch('$link');
  // }

  Future cek() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id_user = pref.getString("id_user");
  }

  Future<String> getSWData() async {
    final response = await http.get(Uri.parse("http://timothy.buzz/kios_epes/Stok/get_barang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  void deactivate() {
    super.deactivate();
    widget.data.clear();
  }

  void _showDialogErrorStok() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Stok Habis"),
          content:
              new Text("Mohon periksa kembali stok, mohon untuk menambah stok terlebih dahulu"),
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

  void kembalian() {
    setState(() {
      if (total_hitung <= 10000) {
        kembalian_hitung = 10000;
      } else if (total_hitung <= 20000 && total_hitung > 10000) {
        kembalian_hitung = 20000;
      } else if (total_hitung <= 50000 && total_hitung > 20000) {
        kembalian_hitung = 50000;
      } else if (total_hitung <= 100000 && total_hitung > 50000) {
        kembalian_hitung = 100000;
      } else if (total_hitung <= 150000 && total_hitung > 100000) {
        kembalian_hitung = 150000;
      } else if (total_hitung <= 200000 && total_hitung > 150000) {
        kembalian_hitung = 200000;
      } else if (total_hitung <= 250000 && total_hitung > 200000) {
        kembalian_hitung = 250000;
      } else if (total_hitung <= 300000 && total_hitung > 250000) {
        kembalian_hitung = 300000;
      } else if (total_hitung <= 350000 && total_hitung > 300000) {
        kembalian_hitung = 350000;
      } else if (total_hitung <= 400000 && total_hitung > 350000) {
        kembalian_hitung = 400000;
      } else if (total_hitung <= 450000 && total_hitung > 400000) {
        kembalian_hitung = 450000;
      } else if (total_hitung <= 500000 && total_hitung > 450000) {
        kembalian_hitung = 500000;
      } else if (total_hitung <= 550000 && total_hitung > 500000) {
        kembalian_hitung = 550000;
      } else if (total_hitung <= 600000 && total_hitung > 550000) {
        kembalian_hitung = 600000;
      } else if (total_hitung <= 650000 && total_hitung > 600000) {
        kembalian_hitung = 650000;
      } else if (total_hitung <= 700000 && total_hitung > 650000) {
        kembalian_hitung = 700000;
      } else if (total_hitung <= 750000 && total_hitung > 700000) {
        kembalian_hitung = 750000;
      } else if (total_hitung <= 800000 && total_hitung > 750000) {
        kembalian_hitung = 800000;
      } else if (total_hitung <= 850000 && total_hitung > 800000) {
        kembalian_hitung = 850000;
      } else if (total_hitung <= 900000 && total_hitung > 850000) {
        kembalian_hitung = 900000;
      } else if (total_hitung <= 950000 && total_hitung > 900000) {
        kembalian_hitung = 950000;
      } else {
        kembalian_hitung = 0;
      }
      modal();
    });
  }

  void modal() {
    setState(() {
      modal_hitung = kembalian_hitung - total_hitung;
    });
  }

  void total() {
    setState(() {
      int total_hitung_awal = 0;
      for (int a = 0; a < widget.data.length; a++) {
        total_hitung_awal = widget.data[a].Harga + total_hitung_awal;
      }
      total_hitung = total_hitung_awal;
      kembalian();
    });
  }

  void add(nilai_awal, i, harga_awal) {
    int stok_awal = 1;
    setState(() {
      // int harga = int.parse(harga_awal.toString());
      // int total = int.parse(nilai_awal.toString());
      nilai_awal++;
      harga_awal = harga_awal * nilai_awal;
      for (int a = 0; a < widget.data.length; a++) {
        if (widget.data[a].id_barang == i) {
          if (widget.data[a].Stock != 0) {
            widget.data[a].Stock = widget.data[a].Stock - stok_awal;
            widget.data[a].nilai_awal = nilai_awal;
            widget.data[a].Harga = harga_awal;
          } else {
            _showDialogErrorStok();
          }
        }
      }
      total();
      kembalian();
    });
  }

  void minus(nilai_awal, i, harga_awal) {
    int stok_awal = 1;
    setState(() {
      if (nilai_awal != 0) {
        nilai_awal--;
        harga_awal = harga_awal * nilai_awal;
        for (int a = 0; a < widget.data.length; a++) {
          if (widget.data[a].id_barang == i) {
            widget.data[a].Stock = widget.data[a].Stock + stok_awal;
            widget.data[a].nilai_awal = nilai_awal;
            widget.data[a].Harga = harga_awal;
          }
        }
        total();
        kembalian();
      }
    });
  }

  void id_pemesanan() {
    String alamat = widget.alamat.replaceAll(" ", "");
    id = tanggal + bulan + year + jam + menit + detik + alamat.toLowerCase();
  }

  void kirim() {
    var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/add_pesanan.php"));
    http.post(url, body: {
      "id_pemesanan": id,
      "id_user": id_user,
      "alamat": widget.alamat,
      "tanggal": tahun,
      "total": total_hitung.toString(),
      "kembalian": kembalian_hitung.toString(),
      "modal": modal_hitung.toString(),
      "catatan": widget.catatan,
    });
  }

  void kirim_detail() {
    for (int a = 0; a < widget.data.length; a++) {
      var url = (Uri.parse("https://timothy.buzz/kios_epes/Pesanan/add_pesanan_detail.php"));
      http.post(url, body: {
        "id_pemesanan": id,
        "id_barang": widget.data[a].id_barang,
        "nama_barang": widget.data[a].Nama,
        "jumlah": widget.data[a].nilai_awal.toString(),
        "harga": widget.data[a].Harga.toString(),
        "stok": widget.data[a].Stock.toString(),
      });
    }
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
                      widget.alamat,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => _accDialog(context),
                              barrierDismissible: false,
                            );
                          },
                          child: Text(
                            "Detail",
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
                              leading: Icon(Icons.workspaces_filled),
                              title: new Text(widget.data[i].Nama, style: TextStyle(fontSize: 18)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    oCcy.format(widget.data[i].Harga_Tetap),
                                  ),
                                  Text(
                                    "Stok : ${widget.data[i].Stock.toString()}",
                                  )
                                ],
                              ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            child: Text(
                              'Total',
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Kembalian',
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Modal',
                              style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
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
                            child: Text(
                              total_hitung.toString(),
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              kembalian_hitung.toString(),
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              modal_hitung.toString(),
                              style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                            ),
                          ),
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
                    onPressed: () {
                      kirim();
                      kirim_detail();
                      // launchWhatsApp();
                      // test();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => new Home_User()),
                        (Route<dynamic> route) => false,
                      );
                    },
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

  Widget _accDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Detail'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAccInput(),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Cancel'),
        )
      ],
    );
  }

  Widget _buildAccInput() {
    return new Column(
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(top: 10),
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  'Alamat',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  ':',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  widget.alamat,
                  style: new TextStyle(fontSize: 15.0),
                ),
              ]),
              TableRow(children: [
                Text(
                  'Catatan',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  ':',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  widget.catatan,
                  style: new TextStyle(fontSize: 15.0),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
