import 'dart:convert';

import 'package:http/http.dart'as http;

import '../Services/taxbreakup_api.dart';


Future<List<TaxBreakup>> fetchTaxBreakup() async{
  final response = await http.get(Uri.parse("https://erp.wellknownssyndicate.com/api/resource/Sales Order/WKS-PI-0624-00185}"),
      headers: {
    "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
  }
  );
  if(response.statusCode == 200){
    // Handle the responses //
    List<dynamic> breakup = jsonDecode(response.body);
    return breakup.map((e)=> TaxBreakup.fromJson(e)).toList();

  }
  else{
    // Error statsu code shows (404 client error ,500 Server error );
    throw Exception("Failed to load data");
  }
}