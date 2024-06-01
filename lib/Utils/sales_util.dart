
// Sales Invoice//
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../Services/sales_api.dart';

Future<List<Sales>> fetch() async{
  HttpClient client = HttpClient();
  client.badCertificateCallback =
  ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(client);
  final response = await http.get(
      Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Sales Invoice?fields=["sales_person","billing_person","attended_by","attended_person","company","branch","customer","attended_person","customer_address","posting_date","due_date"]'),headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
  if(response.statusCode == 200){
    print(response.body);
    List<dynamic> data = jsonDecode(response.body)['data'];
    return data.map((e) => Sales.fromJson(e)).toList();
  }
  else{
    // error status code (404,500) //
    throw Exception("Failed to load data : ${response.statusCode}");
  }
}
