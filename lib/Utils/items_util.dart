import 'dart:convert';
import 'dart:io';
import '../Services/items_api.dart';
import 'package:http/io_client.dart';


                             // Items_api //
Future<List<Item>> fetchItems() async {
  HttpClient client = HttpClient();
  client.badCertificateCallback =
  ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(client);
  final response = await ioClient.get(
    Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Item?fields=["name","item_name","item_group","part_no","brand","stock_uom","gst_hsn_code","image"]'),
    headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"},
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['data'];
    print(response.body);
    return data.map((item) => Item.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load items');
  }
}
//


