import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart'as http;
import 'package:http/io_client.dart';

import '../Services/purchase_api.dart';
                               // Purchase Invoice //
Future<List<PurchaseInvoice>> fetching() async{
  HttpClient client = HttpClient();
  client.badCertificateCallback =
  ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(client);
  final response = await http.get(Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Purchase Invoice?fields=["supplier","supplier_gstin","posting_date","tax_id","company"]'),headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
  if(response.statusCode == 200){
    List<dynamic> data = jsonDecode(response.body)['data'];
    return data.map((e) => PurchaseInvoice.fromJson(e)).toList();
  }
  else{
    throw Exception("Failed to throw data");
  }
}