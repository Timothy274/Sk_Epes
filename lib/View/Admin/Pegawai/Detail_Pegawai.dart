import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kios_epes/Model/DataLaporan.dart';
import 'package:kios_epes/Model/DataPegawai.dart';
import 'package:kios_epes/Model/DataPengiriman.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kios_epes/View/Admin/Home.dart';
import 'package:kios_epes/View/Admin/Pegawai/Bonus_Pegawai.dart';
import 'package:intl/intl.dart';
import 'package:kios_epes/View/Admin/Pegawai/Edit_Profil_Pegawai.dart';

class Detail_Pegawai extends StatefulWidget {
  String id_pegawai, nama, nama_lengkap;
  Detail_Pegawai({Key key, this.id_pegawai, this.nama, this.nama_lengkap}) : super(key: key);

  @override
  _Detail_PegawaiState createState() => _Detail_PegawaiState();
}

class _Detail_PegawaiState extends State<Detail_Pegawai> {
  String _mySelection2;
  String date_sum;
  int bonus_barang = 0;
  int bonus_absensi = 0;
  List<String> pendapatan = [];
  int absensi = 0;
  String gaji = "0";
  List<DataPegawai> _dataPegawai = [];
  List<DataPengiriman> _dataPengiriman = [];
  List<DataPengiriman> _dataPengirimanOnlyProses = [];
  List<DataLaporan> _dataLaporan = [];
  List<String> tanggal = [];
  List<String> tanggal_list = [];
  List<String> tanggal_satuan = [];
  final oCcy = new NumberFormat.currency(locale: 'id');

  void initState() {
    super.initState();
    getDataPengirimanOnlyProses();
    getDataPesanan();
    getDataPengiriman();
    getPegawai();
  }

  Future<List> getDataPesanan() async {
    final response = await http.get(Uri.parse(
        "https://timothy.buzz/kios_epes/Laporan/get_laporan_pengiriman_join_pengiriman_detail_join_pesanan_detail.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        if (DataLaporan.fromJson(Data).id_pegawai == widget.id_pegawai) {
          _dataLaporan.add(DataLaporan.fromJson(Data));
        }
      }
    });
  }

  Future<List> getDataPengirimanOnlyProses() async {
    final response = await http
        .get(Uri.parse("https://timothy.buzz/kios_epes/Pengiriman/get_pengiriman_only_proses.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        if (DataPengiriman.fromJson(Data).id_pegawai == widget.id_pegawai) {
          _dataPengirimanOnlyProses.add(DataPengiriman.fromJson(Data));
        }
      }
    });
  }

  Future<List> getPegawai() async {
    final response =
        await http.get(Uri.parse("https://timothy.buzz/kios_epes/Pegawai/get_pegawai.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        if (DataPegawai.fromJson(Data).id_pegawai == widget.id_pegawai) {
          _dataPegawai.add(DataPegawai.fromJson(Data));
        }
      }
      for (int a = 0; a < _dataPegawai.length; a++) {
        bonus_barang = _dataPegawai[a].bonus_barang;
        bonus_absensi = _dataPegawai[a].bonus_absensi;
      }
    });
  }

  Future<List> getDataPengiriman() async {
    String date, tahunan, bulanan, date_sum, bulanan_name;
    final response = await http
        .get(Uri.parse("https://timothy.buzz/kios_epes/Laporan/get_laporan_date_sort.php"));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataPengiriman.add(DataPengiriman.fromJson(Data));
        tanggal_list.add(DataPengiriman.fromJson(Data).tanggal);
        date = DataPengiriman.fromJson(Data).tanggal;
        tahunan = date.substring(0, 4);
        bulanan = date.substring(5, 7);

        if (bulanan == '01') {
          bulanan_name = 'Januari';
        } else if (bulanan == '02') {
          bulanan_name = 'Februari';
        } else if (bulanan == '03') {
          bulanan_name = 'Maret';
        } else if (bulanan == '04') {
          bulanan_name = 'April';
        } else if (bulanan == '05') {
          bulanan_name = 'Mei';
        } else if (bulanan == '06') {
          bulanan_name = 'Juni';
        } else if (bulanan == '07') {
          bulanan_name = 'Juli';
        } else if (bulanan == '08') {
          bulanan_name = 'Agustus';
        } else if (bulanan == '09') {
          bulanan_name = 'September';
        } else if (bulanan == '10') {
          bulanan_name = 'Oktober';
        } else if (bulanan == '11') {
          bulanan_name = 'November';
        } else if (bulanan == '12') {
          bulanan_name = 'Desember';
        }

        tanggal.add(tahunan + " " + bulanan_name);
      }
      tanggal_list = tanggal_list.toSet().toList();
      tanggal = tanggal.toSet().toList();
    });
  }

  void tanggalan(selection2) {
    String tahunan, bulanan, bulanan_name;
    tahunan = selection2.substring(0, 4);
    bulanan = selection2.substring(5);
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

  void absen(selection2) {
    setState(() {
      absensi = 0;
      tanggal_satuan.clear();
      for (int a = 0; a < _dataPengiriman.length; a++) {
        if (_dataPengiriman[a].tanggal.contains(date_sum)) {
          if (_dataPengiriman[a].id_pegawai == widget.id_pegawai) {
            tanggal_satuan.add(_dataPengiriman[a].tanggal);
            tanggal_satuan = tanggal_satuan.toSet().toList();
            absensi = tanggal_satuan.length;
          }
        }
      }
    });
  }

  void order(selection2) {
    setState(() {
      pendapatan.clear();
      for (int a = 0; a < _dataPengiriman.length; a++) {
        if (_dataPengiriman[a].tanggal.contains(date_sum)) {
          if (_dataPengiriman[a].id_pegawai == widget.id_pegawai) {
            pendapatan.add(_dataPengiriman[a].id_pegawai);
          }
        }
      }
    });
  }

  void gaji_pegawai(selection2) {
    int kalkulasi = 0;
    int kalk = 0;
    int tokalk = 0;
    int jumlah_kiriman = 0;
    setState(() {
      for (int a = 0; a < _dataLaporan.length; a++) {
        if (_dataLaporan[a].tanggal.contains(date_sum)) {
          jumlah_kiriman = jumlah_kiriman + _dataLaporan[a].jumlah;
        }
      }
      kalk = jumlah_kiriman * bonus_barang;
      tokalk = (absensi * bonus_absensi) + kalk;
      final oCcy = new NumberFormat.currency(locale: 'id');
      gaji = oCcy.format(tokalk);
    });
  }

  void validasihapus() {
    if (_dataPengirimanOnlyProses.isEmpty) {
      _showdialogkonfirmasihapus();
    } else {
      _showDialogerror();
    }
  }

  void _showDialogerror() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Pengahapusan Error"),
          content: new Text(
              "Data belum bisa dihapus dikarenakan pegawai masih memiliki aktivitas, mohon periksa kembali dan selesaikan semua aktivitas"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
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

  void _showdialogkonfirmasihapus() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Konfirmasi Penghapusan"),
          content: new Text(
              "Apakah anda yakin ingin menghapus pegawai, Jika anda menghapus pegawai maka semua data pegawai akan hilang"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Hapus"),
              onPressed: () {
                hapuspegawai();
              },
            ),
          ],
        );
      },
    );
  }

  void hapuspegawai() {
    var url = Uri.parse("http://timothy.buzz/kios_epes/Pegawai/delete_pegawai.php");
    http.post(url, body: {
      "id_pegawai": widget.id_pegawai,
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new Home_Admin()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pegawai'),
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.blue, width: 2.0)),
              child: Container(
                // margin: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Icon(
                          Icons.account_circle,
                          size: 100,
                        ),
                      ),
                    ),
                    Center(
                        child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 25),
                        child: Text(
                          widget.nama_lengkap,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 20),
                margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.blue, width: 2.0)),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 20),
                          alignment: Alignment(-1.0, -1.0),
                          child: Text(
                            'Informasi Pegawai',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          width: screenWidth,
                          margin:
                              const EdgeInsets.only(top: 10, bottom: 20, left: 40.0, right: 40.0),
                          child: DropdownButton<String>(
                            items: tanggal.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String newValueSelected) {
                              setState(() {
                                this._mySelection2 = newValueSelected;
                                date_sum = "";
                                tanggalan(_mySelection2);
                                absen(_mySelection2);
                                order(_mySelection2);
                                gaji_pegawai(_mySelection2);
                              });
                            },
                            hint: Text('Pilih Bulan'),
                            value: _mySelection2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Orderan',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    pendapatan.length.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Absensi',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    absensi.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top: 30, left: 40),
                              alignment: Alignment(-1.0, -1.0),
                              child: Text(
                                'Gaji',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              padding: const EdgeInsets.only(left: 40),
                              alignment: Alignment(-1.0, -1.0),
                              child: Text(
                                gaji,
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
                padding: const EdgeInsets.only(top: 20),
                margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.blue, width: 2.0)),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      alignment: Alignment(-1.0, -1.0),
                      child: Text(
                        'Data Diri Pegawai',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Container(
                        // margin: const EdgeInsets.only(top: 20, bottom: 20),
                        // padding: const EdgeInsets.only(left: 40),
                        alignment: Alignment(-1.0, -1.0),
                        child: Column(
                          children: [
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top: 20, left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    'Nama Lengkap',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  padding: const EdgeInsets.only(left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    widget.nama_lengkap,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top: 20, left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    'Nama',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                                  padding: const EdgeInsets.only(left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    widget.nama,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new Edit_Profil_Pegawai(
                                      id_pegawai: widget.id_pegawai,
                                      nama: widget.nama,
                                      nama_lengkap: widget.nama_lengkap,
                                    )));
                          },
                          child: Text(
                            "Ubah",
                            style: TextStyle(fontSize: 18),
                          ),
                        )),
                    Container(height: 20)
                  ],
                )),
            Container(
                padding: const EdgeInsets.only(top: 20),
                margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.blue, width: 2.0)),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 30, bottom: 20),
                      alignment: Alignment(-1.0, -1.0),
                      child: Text(
                        'Bonus Pegawai',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Container(
                        // margin: const EdgeInsets.only(top: 20, bottom: 20),
                        // padding: const EdgeInsets.only(left: 40, right: 40),
                        alignment: Alignment(-1.0, -1.0),
                        child: Column(
                          children: [
                            // Column(
                            //   children: <Widget>[
                            //     Container(
                            //       padding: const EdgeInsets.only(top: 20, left: 40),
                            //       alignment: Alignment(-1.0, -1.0),
                            //       child: Text(
                            //         'Bonus Bulanan',
                            //         style: TextStyle(fontSize: 20),
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: const EdgeInsets.only(top: 20, bottom: 10),
                            //       padding: const EdgeInsets.only(left: 40),
                            //       alignment: Alignment(-1.0, -1.0),
                            //       child: Text(
                            //         oCcy.format(bonus_bulanan),
                            //         style: TextStyle(fontSize: 18),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // Column(
                            //   children: <Widget>[
                            //     Container(
                            //       padding: const EdgeInsets.only(top: 20, left: 40),
                            //       alignment: Alignment(-1.0, -1.0),
                            //       child: Text(
                            //         'Bonus THR',
                            //         style: TextStyle(fontSize: 20),
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: const EdgeInsets.only(top: 20, bottom: 10),
                            //       padding: const EdgeInsets.only(left: 40),
                            //       alignment: Alignment(-1.0, -1.0),
                            //       child: Text(
                            //         oCcy.format(bonus_thr),
                            //         style: TextStyle(fontSize: 18),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top: 20, left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    'Bonus Barang',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                                  padding: const EdgeInsets.only(left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    oCcy.format(bonus_barang),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top: 20, left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    'Bonus Absensi',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                                  padding: const EdgeInsets.only(left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    oCcy.format(bonus_absensi),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new Bonus_Pegawai(
                                      id_pegawai: widget.id_pegawai,
                                      bonus_barang: bonus_barang,
                                      bonus_bulanan: bonus_absensi,
                                    )));
                          },
                          child: Text(
                            "Ubah",
                            style: TextStyle(fontSize: 18),
                          ),
                        )),
                    Container(height: 20)
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: new SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () {
                        validasihapus();
                      },
                      child: const Text('Hapus Akun', style: TextStyle(fontSize: 30)),
                    ))),
          ],
        ),
      )),
    );
  }
}
