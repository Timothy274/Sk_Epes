import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kios_epes/Model/DataBarang.dart';
import 'package:kios_epes/Model/DataHutang.dart';
import 'package:kios_epes/Model/DataJsonBarang.dart';
import 'package:kios_epes/Model/DataJsonPegawai.dart';
import 'package:kios_epes/Model/DataJsonPengirimanLaporan.dart';
import 'package:kios_epes/Model/DataJsonTest.dart';
import 'package:kios_epes/Model/DataLaporan.dart';
import 'package:kios_epes/Model/DataPegawai.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:kios_epes/Model/DataPesanan.dart';
import 'package:kios_epes/Model/DataPesanan_lengkap.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:kios_epes/Model/DataPesananSelesai.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Laporan_Detail extends StatefulWidget {
  String tanggal;

  Laporan_Detail({Key key, this.tanggal}) : super(key: key);

  @override
  _Laporan_DetailState createState() => _Laporan_DetailState();
}

class _Laporan_DetailState extends State<Laporan_Detail> {
  List<DataPengiriman> _dataPengirimanSelesai = [];
  List<DataPesananLengkap> _dataJumlahPesanan = [];
  List<DataPegawai> _dataPegawai = [];
  List<DataBarang> _dataBarang = [];
  List<DataPengiriman> _filterdataPesanan = [];
  List<DataPengiriman> _null_filterdataPesanan = [];
  List<Barang_Json> array_barang = [];
  List<Pegawai_Json> array_laporan_pegawai = [];
  List<Pengiriman_Json> array_laporan_pengiriman = [];
  List<DataHutang> _dataHutang = [];
  List<Test_JSON> _testJson = [];
  List<DataLaporan> _dataLaporan = [];
  // List<array_report_detail> array_laporan_detail = [];
  TextEditingController search_pesanan_selesai = new TextEditingController();
  String date_sum, tahun, bulan;
  int pendapatan_bersih = 0;
  int pendapatan_tertahan = 0;
  int pendapatan = 0;
  final List detailsDataset = [];
  final oCcy = new NumberFormat.currency(locale: 'id');

  void initState() {
    super.initState();
    getdataPengirimanSelesai();
    getDataPegawai();
    getDataPesanan();
    getdataPesananHutang();
    tahun = widget.tanggal.substring(0, 4);
    bulan = widget.tanggal.substring(5);
    pra_array_pegawai();
  }

  void tanggal_converter() {
    String tahunan, bulanan, bulanan_name;
    tahunan = widget.tanggal.substring(0, 4);
    bulanan = widget.tanggal.substring(5);
    if (bulanan == 'Januari') {
      bulanan_name = '01';
    } else if (bulanan == 'Februari') {
      bulanan_name = '02';
    } else if (bulanan == 'Maret') {
      bulanan_name = '03';
    } else if (bulanan == 'April') {
      bulanan_name = '04';
    } else if (bulanan == 'Mei') {
      bulanan_name = '05';
    } else if (bulanan == 'Juni') {
      bulanan_name = '06';
    } else if (bulanan == 'Juli') {
      bulanan_name = '07';
    } else if (bulanan == 'Agustus') {
      bulanan_name = '08';
    } else if (bulanan == 'September') {
      bulanan_name = '09';
    } else if (bulanan == 'Oktober') {
      bulanan_name = '10';
    } else if (bulanan == 'November') {
      bulanan_name = '11';
    } else if (bulanan == 'Desember') {
      bulanan_name = '12';
    }
    // print(date_sum);
    // print(tahunan);
    // print(bulanan);
    date_sum = tahunan + "-" + bulanan_name;
  }

  // Future<String> getPemesanan() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   final response = await http.get(
  //       Uri.parse("http://timothy.buzz/kios_epes/Pesanan/get_pesanan_join_pesanan_detail.php"));
  //   final responseJson = json.decode(response.body);
  //   setState(() {
  //     for (Map Data in responseJson) {
  //       var tanggal = DataPesanan.fromJson(Data).tanggal;
  //       var _bulan = tanggal.substring(5, 7);
  //       if (_bulan == bulan) {
  //         sortbarang.add(a);
  //       }
  //     }
  //     barang.forEach((a) {});
  //     konverter_barang();
  //   });
  // }

  // void konverter_barang() {
  //   int jumlah = 0;
  //   for (int a = 0; a < _pekerja.length; a++) {
  //     jumlah = 0;
  //     for (int b = 0; b < sortbarang.length; b++) {
  //       if (_pekerja[a].id_pegawai == sortbarang[b].id_pegawai) {
  //         jumlah = jumlah + int.parse(sortbarang[b].Jumlah);
  //       }
  //     }
  //     jmlbrg.add(jumlah);
  //   }
  //   print(jmlbrg);
  // }

  void pra_array_pegawai() {
    array_laporan_pegawai.clear();
    // array_laporan_pegawai.add(Pegawai_Json(
    //     'id', 'Nama Pegawai', 'Gaji', 'Absensi', 'Jumlah Kiriman'));
    for (int a = 0; a < _dataPegawai.length; a++) {
      int total_barang = 0;
      int total_pengiriman = 0;
      int bonus_barang_pesanan = 0;
      int bonus_absensi = 0;
      int absensi = 0;
      int kalkulasi = 0;
      int kalk = 0;
      int tokalk = 0;
      int jumlah_kiriman = 0;
      int gaji;
      pendapatan = 0;
      List<String> tanggal_satuan = [];
      for (int b = 0; b < _dataPengirimanSelesai.length; b++) {
        if (_dataPegawai[a].id_pegawai == _dataPengirimanSelesai[b].id_pegawai) {
          tanggal_satuan.add(_dataPengirimanSelesai[b].tanggal);
        }
      }

      // for (int c = 0; c < _null_filterdataPesanan.length; c++) {
      //   if (_dataPegawai[a].id_pegawai == _null_filterdataPesanan[c].id_pegawai) {
      //     for (int d = 0; d < _dataJumlahPesanan.length; d++) {
      //       if (_dataJumlahPesanan[d].id_pemesanan == _null_filterdataPesanan[c].id_pemesanan) {
      //         total_barang = total_barang + _dataJumlahPesanan[d].jumlah;
      //       }
      //     }
      //   }
      // }
      // for (int c = 0; c < _dataPengirimanSelesai.length; c++) {
      //   if (_dataPengirimanSelesai[c].id_pegawai == _dataPegawai[a].id_pegawai) {
      //     for (int d = 0; d < _null_filterdataPesanan.length; d++) {
      //       if (_dataPengirimanSelesai[c].id_pengiriman ==
      //           _null_filterdataPesanan[d].id_pengiriman) {
      //         for (int f = 0; f < _dataJumlahPesanan.length; f++) {
      //           if (_null_filterdataPesanan[c].id_pemesanan == _dataJumlahPesanan[f].id_pemesanan) {
      //             total_barang = total_barang + _dataJumlahPesanan[f].jumlah;
      //           }
      //         }
      //       }
      //     }
      //   }
      // }
      for (int f = 0; f < _dataLaporan.length; f++) {
        if (_dataLaporan[f].id_pegawai == _dataPegawai[a].id_pegawai &&
            _dataLaporan[f].tanggal.contains(date_sum)) {
          total_barang = total_barang + _dataLaporan[f].jumlah;
        }
      }
      for (int g = 0; g < _dataPengirimanSelesai.length; g++) {
        if (_dataPengirimanSelesai[g].id_pegawai == _dataPegawai[a].id_pegawai) {
          pendapatan = pendapatan + 1;
        }
      }
      tanggal_satuan = tanggal_satuan.toSet().toList();
      absensi = tanggal_satuan.length;
      print(total_barang);
      bonus_barang_pesanan = total_barang * _dataPegawai[a].bonus_barang;
      bonus_absensi = absensi * _dataPegawai[a].bonus_absensi;

      gaji = bonus_barang_pesanan + bonus_absensi;

      // var gaji = bonus_brg + bonus_absen;
      // final oCcy = new NumberFormat.currency(locale: 'id');
      // tot_gaji = oCcy.format(gaji);
      // var nama = _pekerja[a].Nama;
      // var id_pegawai = _pekerja[a].id_pegawai;
      // var absensi = Absensi[a];
      // var jmlkirim = _jmlkirim[a];
      array_laporan_pegawai.add(Pegawai_Json(_dataPegawai[a].nama_pegawai,
          _dataPegawai[a].nama_lengkap_pegawai, gaji, absensi, pendapatan));
    }
    // print(_dataBarang.length);
    for (int a = 0; a < _dataBarang.length; a++) {
      var nil = 0;
      for (int b = 0; b < _dataJumlahPesanan.length; b++) {
        if (_dataJumlahPesanan[b].id_barang == _dataBarang[a].id_barang) {
          nil = nil + _dataJumlahPesanan[b].jumlah;
        }
      }
      int tot = nil * _dataBarang[a].Harga_Tetap;
      array_barang.add(Barang_Json(_dataBarang[a].Nama, nil.toString(), tot));
    }
  }

  void _alterPengirimanSelesai(String query) {
    query = query.toLowerCase();
    List<DataPengiriman> dummySearchList = [];
    dummySearchList.addAll(_null_filterdataPesanan);
    if (query.isNotEmpty) {
      List<DataPengiriman> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.alamat.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filterdataPesanan.clear();
        _filterdataPesanan.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filterdataPesanan.clear();
        _filterdataPesanan.addAll(_null_filterdataPesanan);
      });
    }
  }

  Future<List> getdataPengirimanSelesai() async {
    String alamat, tanggal_kirim, waktu, pengirim;
    int total;
    final responseA = await http
        .get(Uri.parse("https://timothy.buzz/kios_epes/Laporan/get_laporan_date_sort.php"));
    final responseB = await http.get(Uri.parse(
        "https://timothy.buzz/kios_epes/Pengiriman/get_pengiriman_detail_join_pesanan.php"));
    final responseC = await http.get(
        Uri.parse("https://timothy.buzz/kios_epes/Pesanan/get_pesanan_join_pesanan_detail.php"));
    final responseD =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Stok/get_barang.php"));

    // final responseD = await http.get(Uri.parse(
    //     "https://timothy.buzz/kios_epes/Pengiirman/get_pengiriman_join_pengiriman_detail.php"));
    final responseJsonA = json.decode(responseA.body);
    final responseJsonB = json.decode(responseB.body);
    final responseJsonC = json.decode(responseC.body);
    final responseJsonD = json.decode(responseD.body);
    // final responseJsonD = json.decode(responseD.body);
    setState(() {
      tanggal_converter();
      for (Map Data in responseJsonA) {
        if (DataPengiriman.fromJson(Data).tanggal.contains(date_sum)) {
          _dataPengirimanSelesai.add(DataPengiriman.fromJson(Data));
        }
      }

      for (Map Data in responseJsonB) {
        for (int a = 0; a < _dataPengirimanSelesai.length; a++) {
          if (_dataPengirimanSelesai[a].id_pengiriman ==
                  DataPengiriman.fromJson(Data).id_pengiriman &&
              DataPengiriman.fromJson(Data).status == "Selesai") {
            // _dataPesanan.add(DataPengiriman.fromJson(Data));
            _filterdataPesanan.add(DataPengiriman.fromJson(Data));
            _null_filterdataPesanan.add(DataPengiriman.fromJson(Data));
            if (_dataPengirimanSelesai[a].id_pengiriman ==
                DataPengiriman.fromJson(Data).id_pengiriman) {
              alamat = DataPengiriman.fromJson(Data).alamat;
              tanggal_kirim = _dataPengirimanSelesai[a].tanggal;
              waktu = _dataPengirimanSelesai[a].waktu;
              pengirim = _dataPengirimanSelesai[a].nama_pegawai;
              total = DataPengiriman.fromJson(Data).total;
              detailsDataset.add(alamat);
              array_laporan_pengiriman
                  .add(Pengiriman_Json(alamat, tanggal_kirim, waktu, pengirim, total));
            }
          }
        }
      }

      for (Map Data in responseJsonC) {
        for (int a = 0; a < _null_filterdataPesanan.length; a++) {
          // print(_null_filterdataPesanan[a].waktu);
          if (_null_filterdataPesanan[a].id_pemesanan ==
              (DataPesananLengkap.fromJson(Data).id_pemesanan)) {
            _dataJumlahPesanan.add(DataPesananLengkap.fromJson(Data));
          }
        }
      }

      for (Map Data in responseJsonD) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }

      // for (int a = 0; a < _dataPengirimanSelesai.length; a++) {
      //   for (int b = 0; b < _null_filterdataPesanan.length; b++) {
      //     if (_dataPengirimanSelesai[a].id_pemesanan == _null_filterdataPesanan[b].id_pemesanan) {
      //       alamat = _null_filterdataPesanan[b].alamat;
      //       print(alamat);
      //       // tanggal_kirim = _dataPengirimanSelesai[a].tanggal;
      //       // waktu = _dataPengirimanSelesai[a].waktu;
      //       // pengirim = _dataPengirimanSelesai[a].nama_pegawai;
      //       // total = _null_filterdataPesanan[b].total;
      //       // array_laporan_pengiriman
      //       //     .add(Pengiriman_Json(alamat, tanggal_kirim, waktu, pengirim, total));
      //     }
      //   }
      // }
      for (int a = 0; a < _null_filterdataPesanan.length; a++) {
        pendapatan_bersih = pendapatan_bersih + _null_filterdataPesanan[a].total;
      }

      // konverter_barang();
    });
  }

  Future<List> getDataPesanan() async {
    final response = await http.get(Uri.parse(
        "https://timothy.buzz/kios_epes/Laporan/get_laporan_pengiriman_join_pengiriman_detail_join_pesanan_detail.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataLaporan.add(DataLaporan.fromJson(Data));
      }
    });
  }

  Future<List> getDataPegawai() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Pegawai/get_pegawai.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPegawai.add(DataPegawai.fromJson(Data));
      }
    });
  }

  Future<List> getdataPesananHutang() async {
    final response =
        await http.get(Uri.parse("http://timothy.buzz/kios_epes/Hutang/get_hutang.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataHutang.add(DataHutang.fromJson(Data));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
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
                      widget.tanggal,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 10),
                      child: TextField(
                        textAlign: TextAlign.left,
                        controller: search_pesanan_selesai,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          _alterPengirimanSelesai(value);
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            filled: true,
                            fillColor: Colors.white,
                            // prefixIcon: Icon(
                            //   Icons.qr_code_scanner,
                            //   color: Colors.black,
                            // ),
                            suffixIcon: Icon(Icons.search, color: Colors.black),
                            hintStyle: new TextStyle(color: Colors.black38),
                            hintText: "Search"),
                      ),
                    ),
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
                    itemCount: _filterdataPesanan.length,
                    itemBuilder: (context, i) {
                      return Container(
                          // padding: const EdgeInsets.all(10.0),
                          child: new Card(
                              child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: new Text(_filterdataPesanan[i].alamat,
                                  style: TextStyle(fontSize: 18)),
                              // subtitle: Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       oCcy.format(widget.data[i].Harga_Tetap),
                              //     ),
                              //     Text(
                              //       "Stok : ${widget.data[i].Stock.toString()}",
                              //     )
                              //   ],
                              // ),
                            ),
                          ),
                        ],
                      )));
                    },
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => _printDocument(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.print,
                          color: Colors.white,
                        ),
                        Text(
                          "Cetak",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    )),
              )),
        ],
      ),
    );
  }

  Future<void> _printDocument() async {
    pra_array_pegawai();

    // for (int a = 0; a < 5; a++) {
    //   _testJson.add(Test_JSON("apa", "ini", "itu"));
    // }
    // String encode = jsonEncode(_testJson);
    // print(encode);
    // http.Response response = await http.post(
    //   Uri.parse("http://timothy.buzz/pdf_generate.php"),
    //   // headers: <String, String>{
    //   //   'Content-Type': 'application/json',
    //   // },
    //   body: {"formname": encode},
    // );

    // debugPrint("Response: " + response.body);
    // debugPrint("Status: " + (response.statusCode).toString());
    // const url = 'http://timothy.buzz/pdf_generate.php';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    // print(array_laporan_pegawai.length);
    // print(array_laporan_pengiriman.length);
    // print(_dataJumlahPesanan.length);
    var list = array_laporan_pegawai
        .map((item) => pw.TableRow(children: [
              pw.Text(item.nama_lengkap.toString()),
              pw.Text(item.jmlkirim.toString()),
              pw.Text(item.absensi.toString()),
              pw.Text(oCcy.format(item.gaji)),
            ]))
        .toList();
    list.insert(
        0,
        pw.TableRow(children: [
          pw.Text("Nama Pegawai"),
          pw.Text("Jumlah pengiriman"),
          pw.Text("Absensi"),
          pw.Text("Gaji"),
        ]));

    var list_pengiriman = array_laporan_pengiriman
        .map((item) => pw.TableRow(children: [
              pw.Text(item.alamat.toString()),
              pw.Text(item.tanggal.toString()),
              pw.Text(item.waktu),
              pw.Text(item.pengirim),
              pw.Text(oCcy.format(item.total)),
            ]))
        .toList();
    list_pengiriman.insert(
        0,
        pw.TableRow(children: [
          pw.Text("Alamat"),
          pw.Text("Tanggal Pengiriman"),
          pw.Text("Waktu Selesai"),
          pw.Text("Pengirim"),
          pw.Text("Total"),
        ]));

    var list_pesanan = _dataJumlahPesanan
        .map((item) => pw.TableRow(children: [
              pw.Text(item.alamat.toString()),
              pw.Text(item.tanggal.toString()),
              pw.Text(item.nama_barang.toString()),
              pw.Text(item.jumlah.toString()),
              pw.Text(oCcy.format(item.harga)),
            ]))
        .toList();
    list_pesanan.insert(
        0,
        pw.TableRow(children: [
          pw.Text("Barang"),
          pw.Text("Terjual"),
          pw.Text("Total"),
        ]));

    var list_barang = array_barang
        .map((item) => pw.TableRow(children: [
              pw.Text(item.nama.toString()),
              pw.Text(item.terjual.toString()),
              pw.Text(oCcy.format(item.jual_total)),
            ]))
        .toList();
    list_barang.insert(
        0,
        pw.TableRow(children: [
          pw.Text("Barang"),
          pw.Text("Terjual"),
          pw.Text("Total"),
        ]));

    var list_hutang = _dataHutang
        .map((item) => pw.TableRow(children: [
              pw.Text(item.alamat.toString()),
              pw.Text(item.nama_pegawai.toString()),
              pw.Text(item.tanggal_pemesanan.toString()),
              pw.Text(item.tanggal_pengiriman.toString()),
              pw.Text(item.waktu_pengiriman.toString()),
              pw.Text(oCcy.format(item.total)),
            ]))
        .toList();
    list_hutang.insert(
        0,
        pw.TableRow(children: [
          pw.Text("Alamat"),
          pw.Text("Pengirim"),
          pw.Text("Tanggal Pemesanan"),
          pw.Text("Tanggal Pengiriman"),
          pw.Text("Waktu"),
          pw.Text("Total"),
        ]));
    // pra_laporan();
    Printing.layoutPdf(onLayout: (pageFormat) {
      final doc = pw.Document();
      doc.addPage(pw.MultiPage(
          maxPages: 100,
          build: (pw.Context context) => <pw.Widget>[
                pw.Header(
                    level: 0,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Text('Laporan ${widget.tanggal}', textScaleFactor: 2),
                        ])),
                pw.Paragraph(
                    text:
                        'Pada ${widget.tanggal}, berikut adalah rincian detail laporan khusus bulan secara detail'),
                pw.Container(height: 10),
                // pw.Paragraph(text: '${catatan.text}'),
                // pw.Header(level: 1, text: 'Rangkuman tahun $tahun'),
                pw.Header(level: 1, text: 'Rangkuman bulan $bulan'),
                pw.Paragraph(text: 'Jumlah Pesanan Masuk : ${_null_filterdataPesanan.length}'),
                pw.Paragraph(text: 'Jumlah Pendapatan Masuk : ${pendapatan_bersih}'),
                pw.Paragraph(text: 'Jumlah Pendapatan Tertahan : ${pendapatan_bersih}'),
                pw.Paragraph(text: 'Jumlah Pengiriman : ${list_pengiriman.length}'),
                pw.Container(height: 10),
                // pw.Paragraph(text: 'Pegawai Terbaik : ${widget.PegawaiTerbaik}'),
                pw.Header(level: 1, child: pw.Text('Laporan Pegawai')),
                pw.Wrap(children: [
                  pw.Column(children: <pw.Widget>[
                    pw.Table(
                      children: list,
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: pw.FractionColumnWidth(.4),
                        1: pw.FractionColumnWidth(.2),
                        2: pw.FractionColumnWidth(.1),
                        3: pw.FractionColumnWidth(.3)
                      },
                    )
                  ]),
                ]),
                pw.Container(height: 10),
                pw.Header(level: 1, child: pw.Text('Laporan Barang')),
                pw.Wrap(children: [
                  pw.Column(children: <pw.Widget>[
                    pw.Table(
                      children: list_barang,
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        // 0: pw.FractionColumnWidth(.3),
                        // 1: pw.FractionColumnWidth(.2),
                        // 2: pw.FractionColumnWidth(.2),
                        // 3: pw.FractionColumnWidth(.2),
                        // 4: pw.FractionColumnWidth(.2),
                        // 5: pw.FractionColumnWidth(.2)
                      },
                    )
                  ]),
                ]),
                // pw.Container(height: 10),
                // pw.Header(level: 1, child: pw.Text('Laporan Hutang')),
                // pw.Wrap(children: [
                //   pw.Table(
                //     children: list_hutang,
                //     border: pw.TableBorder.all(),
                //     columnWidths: {},
                //   )
                // ]),
                // pw.Header(level: 1, child: pw.Text('Laporan Detail Pesanan')),
                // pw.Wrap(children: [
                //   pw.Column(children: <pw.Widget>[
                //     pw.Table(
                //       children: list_pesanan,
                //       border: pw.TableBorder.all(),
                //       columnWidths: {
                //         0: pw.FractionColumnWidth(.4),
                //         1: pw.FractionColumnWidth(.2),
                //         2: pw.FractionColumnWidth(.4),
                //         // 3: pw.FractionColumnWidth(.1),
                //         4: pw.FractionColumnWidth(.2)
                //       },
                //     )
                //   ]),
                // ]),
                // pw.Container(height: 10),
                // pw.Header(level: 1, child: pw.Text('Laporan Hutang')),
                // pw.Wrap(children: [
                //   pw.Column(children: <pw.Widget>[
                //     pw.Table(
                //       children: list_hutang,
                //       border: pw.TableBorder.all(),
                //       columnWidths: {
                //         0: pw.FractionColumnWidth(.3),
                //         1: pw.FractionColumnWidth(.2),
                //         2: pw.FractionColumnWidth(.2),
                //         3: pw.FractionColumnWidth(.2),
                //         4: pw.FractionColumnWidth(.2),
                //         5: pw.FractionColumnWidth(.2)
                //       },
                //     )
                //   ]),
                // ]),
                // pw.Container(height: 10),
              ]));

      return doc.save();
    });
  }
}
