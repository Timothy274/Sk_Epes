class DataLaporan {
  String id_pengiriman;
  String id_pemesanan;
  String id_pegawai;
  String id_barang;
  String nama_pegawai;
  String nama_barang;
  String tanggal;
  String alamat;
  String waktu;
  String catatan;
  int jumlah;
  int harga;
  int total;
  int kembalian;
  int modal;
  String status;

  DataLaporan({
    this.id_pemesanan,
    this.id_pengiriman,
    this.id_pegawai,
    this.id_barang,
    this.nama_pegawai,
    this.nama_barang,
    this.jumlah,
    this.harga,
    this.alamat,
    this.tanggal,
    this.catatan,
    this.waktu,
    this.status,
    this.total,
    this.kembalian,
    this.modal,
  });

  factory DataLaporan.fromJson(Map<dynamic, dynamic> json) {
    return DataLaporan(
      id_pemesanan: json['id_pemesanan'],
      id_pengiriman: json['id_pengiriman'],
      id_pegawai: json['id_pegawai'],
      id_barang: json['id_barang'],
      nama_pegawai: json['nama_pegawai'],
      nama_barang: json['nama_barang'],
      jumlah: int.parse(json['jumlah']),
      harga: int.parse(json['harga']),
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
