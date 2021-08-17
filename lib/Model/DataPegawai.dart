class DataPegawai {
  String id_pegawai;
  String nama_lengkap_pegawai;
  String nama_pegawai;
  int bonus_thr;
  int bonus_bulanan;
  int bonus_barang;
  int bonus_absensi;

  DataPegawai(
      {this.id_pegawai,
      this.nama_pegawai,
      this.nama_lengkap_pegawai,
      this.bonus_barang,
      this.bonus_absensi});

  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(
        id_pegawai: json['id_pegawai'],
        nama_lengkap_pegawai: json['nama_lengkap_pegawai'],
        nama_pegawai: json['nama_pegawai'],
        bonus_barang: int.parse(json['bonus_barang']),
        bonus_absensi: int.parse(json['bonus_absensi']));
  }
}
