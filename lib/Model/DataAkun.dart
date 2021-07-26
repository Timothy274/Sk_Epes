class DataAkun {
  String id_user;
  String nama_lengkap;
  String nama;
  String no_telp;
  String username;
  String password;
  String akses;

  DataAkun(
      {this.id_user,
      this.nama_lengkap,
      this.nama,
      this.no_telp,
      this.username,
      this.password,
      this.akses});

  factory DataAkun.fromJson(Map<String, dynamic> json) {
    return DataAkun(
      id_user: json['id_user'],
      nama_lengkap: json['nama_lengkap'],
      nama: json['nama'],
      no_telp: json['no_telp'],
      username: json['username'],
      password: json['password'],
      akses: json['akses'],
    );
  }
}
