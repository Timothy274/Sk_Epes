import 'package:flutter/material.dart';

class finish_list extends StatefulWidget {
  String id_pemesanan, id_pengiriman, alamat, tanggal, catatan, status;
  int modal, total, kembalian;
  finish_list(
      {Key key,
      this.id_pemesanan,
      this.id_pengiriman,
      this.alamat,
      this.tanggal,
      this.catatan,
      this.status,
      this.kembalian,
      this.modal,
      this.total})
      : super(key: key);

  @override
  _finish_listState createState() => _finish_listState();
}

class _finish_listState extends State<finish_list> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
