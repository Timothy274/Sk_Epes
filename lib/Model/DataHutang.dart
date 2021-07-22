class DataHutang {
  String id_pemesanan;
  String id_hutang;
  String id_pegawai;
  String id_pengiriman;
  String nama_pegawai;
  String alamat;
  String tanggal_pemesanan;
  String tanggal_pengiriman;
  String waktu_pengiriman;
  String catatan;
  String status;
  int total;

  DataHutang({
    this.id_pemesanan,
    this.id_hutang,
    this.id_pegawai,
    this.id_pengiriman,
    this.nama_pegawai,
    this.alamat,
    this.tanggal_pemesanan,
    this.tanggal_pengiriman,
    this.waktu_pengiriman,
    this.catatan,
    this.status,
    this.total,
  });

  factory DataHutang.fromJson(Map<dynamic, dynamic> json) {
    return DataHutang(
      id_pemesanan: json['id_pemesanan'],
      id_hutang: json['id_hutang'],
      id_pegawai: json['id_pegawai'],
      id_pengiriman: json['id_pengiriman'],
      nama_pegawai: json['nama_pegawai'],
      alamat: json['alamat'],
      tanggal_pemesanan: json['tanggal_pemesanan'],
      tanggal_pengiriman: json['tanggal_pengiriman'],
      waktu_pengiriman: json['waktu_pengiriman'],
      catatan: json['catatan'],
      status: json['status'],
      total: int.parse(json['total']),
    );
  }
}
