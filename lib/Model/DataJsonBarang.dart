class Barang_Json {
  String nama;
  String terjual;
  int jual_total;
  Barang_Json(this.nama, this.terjual, this.jual_total);
  Map<String, dynamic> toJson() => {
        'nama': nama,
        'total_terjual': terjual,
        'Total_jual_harga': jual_total,
      };
}
