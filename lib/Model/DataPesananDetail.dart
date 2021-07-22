class DataPesananDetail {
  String id_pemesanan;
  String id_barang;
  String nama_barang;
  int harga;
  int jumlah;

  DataPesananDetail({this.id_pemesanan, this.id_barang, this.nama_barang, this.harga, this.jumlah});

  factory DataPesananDetail.fromJson(Map<dynamic, dynamic> json) {
    return DataPesananDetail(
      id_pemesanan: json['id_pemesanan'],
      id_barang: json['id_barang'],
      nama_barang: json['nama_barang'],
      harga: int.parse(json['harga']),
      jumlah: int.parse(json['jumlah']),
    );
  }
}
