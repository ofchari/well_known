import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart'as http;
import 'package:http/io_client.dart';

import '../Services/proforma_api.dart';


Future<List<SalesOrder>> fetchProforma() async{
  HttpClient client = HttpClient();
  client.badCertificateCallback =
  ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(client);
  final response = await http.get(
      Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Sales Order?fields=["name","billing_person","company","customer","customer_name","transaction_date","delivery_date"]'),
      headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
  if(response.statusCode == 200){
    // print(response.body);
    List<dynamic> data  = jsonDecode(response.body)['data'];
    return  data.map((e) => SalesOrder.fromJson(e)).toList();
  }
  else{
    // error showing status code ("400 Client error","500 Server error")
    throw Exception("Failed to load data : ${response.statusCode}");
  }
}
