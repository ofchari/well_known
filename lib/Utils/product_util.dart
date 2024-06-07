import 'dart:convert';

import 'package:http/http.dart'as http;

import '../Services/product_api.dart';

Future<List<Product>> fetchProducts() async{
  final response = await http.get(Uri.parse("https://server-e82i.onrender.com/products"),headers: {"Authorization" :"token dve786salman:6326hari"});
  if(response.statusCode == 200){
    print(response.body);
    // Handle resonses //
    List<dynamic> product = jsonDecode(response.body)['product'];
    return product.map((e)=>Product.fromJson(e)).toList();
  }
  else{
    // Error through status code (404,500)
    throw Exception("Failed to load data ${response.statusCode}");
  }
}