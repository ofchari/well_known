import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;

import '../Services/salesorder_item.dart';

Future<List<SalesOrderItem>> fetchSalesItem() async{
  final response = await http.get(Uri.parse("https://erp.wellknownssyndicate.com/api/resource/Sales Order/WKS-PI-0624-00185}"),
      headers: {
        "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
      }
      );
  if(response.statusCode == 200){
    print(response.body);
    // Handle responses //
    List<dynamic> data = jsonDecode(response.body)['data'];
    return data.map((e) =>SalesOrderItem.fromJson(e)).toList();
  }
  else{
    // Error statuscode (404 client error , 500 Internal server error )
    throw Exception("Failed to load data ${response.statusCode}");
  }
}