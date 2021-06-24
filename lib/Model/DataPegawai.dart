class DataPegawai {
  String id_pegawai;
  String Nama;

  DataPegawai({this.id_pegawai, this.Nama});
  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(id_pegawai: json['id_pegawai'], Nama: json['Nama']);
  }
}
