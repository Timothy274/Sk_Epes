class DataPesananLengkap {
  String id_pemesanan;
  String id_barang;
  String alamat;
  String nama_barang;
  String tanggal;
  String catatan;
  String status;
  int total;
  int kembalian;
  int modal;
  int jumlah;

  DataPesananLengkap(
      {this.id_pemesanan,
      this.id_barang,
      this.alamat,
      this.nama_barang,
      this.tanggal,
      this.catatan,
      this.status,
      this.total,
      this.kembalian,
      this.modal,
      this.jumlah});

  factory DataPesananLengkap.fromJson(Map<dynamic, dynamic> json) {
    return DataPesananLengkap(
      id_pemesanan: json['id_pemesanan'],
      id_barang: json['id_barang'],
      alamat: json['alamat'],
      nama_barang: json['nama_barang'],
      tanggal: json['tanggal'],
      catatan: json['catatan'],
      status: json['status'],
      total: int.parse(json['total']),
      kembalian: int.parse(json['kembalian']),
      modal: int.parse(json['modal']),
      jumlah: int.parse(json['jumlah']),
    );
  }
}
