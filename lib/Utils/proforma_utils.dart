import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import '../Services/proforma_api.dart';


Future<List<SalesOrder>> fetchProforma({String searchTerm = ''}) async {
  HttpClient client = HttpClient();
  client.badCertificateCallback =
  ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(client);

  final response = await ioClient.get(
    Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Sales Order?fields=["name","billing_person","company","customer","customer_name","transaction_date","delivery_date","base_total"]&limit_page_length=50000&ord'),
    headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"},
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['data'];
    List<SalesOrder> salesOrders = data.map((e) => SalesOrder.fromJson(e)).toList();
    if (searchTerm.isNotEmpty) {
      salesOrders = salesOrders
          .where((order) =>
          order.name!.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }
    return salesOrders;
  } else {
    throw Exception("Failed to load data : ${response.statusCode}");
  }
}
