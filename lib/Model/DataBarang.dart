class DataBarang {
  String id_barang;
  String Nama;
  int Harga;
  int Harga_Tetap;
  int Stock;
  int nilai_awal;
  String id_Brg;
  DataBarang(
      {this.id_barang,
      this.Nama,
      this.Harga,
      this.Harga_Tetap,
      this.Stock,
      this.nilai_awal,
      this.id_Brg});
  factory DataBarang.fromJson(Map<dynamic, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['nama'],
        Harga: int.parse(json['nilai_awal']),
        Harga_Tetap: int.parse(json['harga']),
        Stock: int.parse(json['stok']),
        nilai_awal: int.parse(json['nilai_awal']),
        id_Brg: json['id_Barang']);
  }
}
