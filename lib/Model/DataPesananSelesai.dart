class DataPesananSelesai {
  String id_pemesanan;
  String id_pengiriman;
  String id_user;
  String alamat;
  String tanggal;
  String catatan;
  String status;
  int total;
  int kembalian;
  int modal;

  DataPesananSelesai({
    this.id_pengiriman,
    this.id_user,
    this.id_pemesanan,
    this.alamat,
    this.tanggal,
    this.catatan,
    this.status,
    this.total,
    this.kembalian,
    this.modal,
  });

  factory DataPesananSelesai.fromJson(Map<dynamic, dynamic> json) {
    return DataPesananSelesai(
      id_pemesanan: json['id_pemesanan'],
      id_user: json['id_user'],
      id_pengiriman: json['id_pengiriman'],
      alamat: json['alamat'],
      tanggal: json['tanggal'],
      catatan: json['catatan'],
      status: json['status'],
      total: int.parse(json['total']),
      kembalian: int.parse(json['kembalian']),
      modal: int.parse(json['modal']),
    );
  }
}
