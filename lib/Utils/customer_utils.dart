import 'dart:convert';

import 'package:http/http.dart'as http;

import '../Services/customer_api.dart';

Future<List<Datum>> fetchCustomer() async{
  final response = await http.get(Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Customer?fields=["customer_name","name","sales_person"]&limit_page_length=50000'),
  headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"}
  );
  if(response.statusCode == 200){
    List<dynamic> custome = jsonDecode(response.body)['data'];
    return custome.map((e) => Datum.fromJson(e)).toList();
  }
  else{
    throw Exception("Faile to load data ${response.statusCode}");
  }
}