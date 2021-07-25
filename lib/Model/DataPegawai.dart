class DataPegawai {
  String id_pegawai;
  String nama_lengkap_pegawai;
  String nama_pegawai;
  int bonus_thr;
  int bonus_bulanan;
  int bonus_barang;
  int bonus_pengiriman;

  DataPegawai(
      {this.id_pegawai,
      this.nama_pegawai,
      this.nama_lengkap_pegawai,
      this.bonus_thr,
      this.bonus_bulanan,
      this.bonus_barang,
      this.bonus_pengiriman});

  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(
        id_pegawai: json['id_pegawai'],
        nama_lengkap_pegawai: json['nama_lengkap_pegawai'],
        nama_pegawai: json['nama_pegawai'],
        bonus_thr: int.parse(json['bonus_thr']),
        bonus_bulanan: int.parse(json['bonus_bulanan']),
        bonus_barang: int.parse(json['bonus_barang']),
        bonus_pengiriman: int.parse(json['bonus_pengiriman']));
  }
}
