class DataPegawai {
  String id_pegawai;
  String nama_lengkap_pegawai;
  String nama_pegawai;
  int bonus_thr;
  int bonus_tahunan;

  DataPegawai(
      {this.id_pegawai,
      this.nama_pegawai,
      this.nama_lengkap_pegawai,
      this.bonus_thr,
      this.bonus_tahunan});

  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(
        id_pegawai: json['id_pegawai'],
        nama_lengkap_pegawai: json['nama_lengkap_pegawai'],
        nama_pegawai: json['nama_pegawai'],
        bonus_thr: int.parse(json['bonus_thr']),
        bonus_tahunan: int.parse(json['bonus_tahunan']));
  }
}
