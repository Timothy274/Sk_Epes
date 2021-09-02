class DataPengiriman {
  String id_pengiriman;
  String id_pemesanan;
  String id_pegawai;
  String id_user;
  String nama_pegawai;
  String tanggal;
  String alamat;
  String waktu;
  String catatan;
  int total;
  int kembalian;
  int modal;
  String status;

  DataPengiriman({
    this.id_pemesanan,
    this.id_pengiriman,
    this.id_pegawai,
    this.id_user,
    this.nama_pegawai,
    this.alamat,
    this.tanggal,
    this.catatan,
    this.waktu,
    this.status,
    this.total,
    this.kembalian,
    this.modal,
  });

  factory DataPengiriman.fromJson(Map<dynamic, dynamic> json) {
    return DataPengiriman(
      id_pemesanan: json['id_pemesanan'],
      id_pengiriman: json['id_pengiriman'],
      id_pegawai: json['id_pegawai'],
      id_user: json['id_user'],
      nama_pegawai: json['nama_pegawai'],
      catatan: json['catatan'],
      alamat: json['alamat'],
      tanggal: json['tanggal'],
      waktu: json['waktu'],
      status: json['status'],
      total: int.parse(json['total']),
      kembalian: int.parse(json['kembalian']),
      modal: int.parse(json['modal']),
    );
  }
}
