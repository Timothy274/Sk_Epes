class Test_JSON {
  String nama;
  String username;
  String password;

  Test_JSON(this.nama, this.username, this.password);
  Map<String, dynamic> toJson() => {'alamat': nama, 'tanggal': username, 'waktu': password};
}
