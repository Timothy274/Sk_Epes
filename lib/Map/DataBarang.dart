class DataBarang {
  String id_barang;
  String Nama;
  String Harga;
  String Stock;
  String Berat;
  String nilai_awal;
  String id_Brg;
  DataBarang(
      {this.id_barang,
      this.Nama,
      this.Harga,
      this.Stock,
      this.Berat,
      this.nilai_awal,
      this.id_Brg});
  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['Nama'],
        Harga: json['Harga'],
        Stock: json['Stok'],
        Berat: json['Berat'],
        nilai_awal: json['nilai_awal'],
        id_Brg: json['id_Barang']);
  }
}
