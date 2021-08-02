class Pengiriman_Json {
  String alamat;
  String tanggal;
  String waktu;
  String pengirim;
  int total;
  Pengiriman_Json(this.alamat, this.tanggal, this.waktu, this.pengirim, this.total);
  Map<String, dynamic> toJson() =>
      {'alamat': alamat, 'tanggal': tanggal, 'waktu': waktu, 'pengirim': pengirim, 'total': total};
}
