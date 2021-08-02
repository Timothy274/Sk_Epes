class Pegawai_Json {
  String nama;
  String nama_lengkap;
  int gaji;
  int absensi;
  int jmlkirim;
  Pegawai_Json(this.nama, this.nama_lengkap, this.gaji, this.absensi, this.jmlkirim);
  Map<String, dynamic> toJson() => {
        'nama': nama,
        'nama_lengkap': nama_lengkap,
        'gaji': gaji,
        'absensi': absensi,
        'jmlkirim': jmlkirim
      };
}
