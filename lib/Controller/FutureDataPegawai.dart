// import 'dart:convert';

// import 'package:kios_epes/Model/DataBarang.dart';
// import 'package:http/http.dart' as http;

// class futureDataBarang {
//   List<DataBarang> _dataBarang = [];

//   Future<List<DataBarang>> getPegawai() async {
//     final response =
//         await http.get(Uri.parse("http://timothy.buzz/juljol/get_pegawai_except_p.php"));
//     final responseJson = json.decode(response.body);
//     for (Map Data in responseJson) {
//       _dataBarang.add(DataBarang.fromJson(Data));
//     }
//   }

//   void initState() {
//     getBarang();
//   }
// }
