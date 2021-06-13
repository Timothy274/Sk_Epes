class DataTahun {
  String Tahun;

  DataTahun({this.Tahun});
  factory DataTahun.fromJson(Map<String, dynamic> json) {
    return DataTahun(Tahun: json['Tanggal']);
  }
}
