
// sample Api //

import 'dart:convert';
import 'package:http/http.dart'as http;
import '../Services/sample.dart';

Future<List<CategoryList>> fetchhes () async{
  final response = await http.get(Uri.parse("http://catodotest.elevadosoftwares.com/Category/GetAllCategories"));
  if(response.statusCode == 200){
    List<dynamic> categoryList = jsonDecode(response.body)['categoryList'];
    return categoryList.map((e) => CategoryList.fromJson(e)).toList();
  }
  else{
    throw Exception("Failed to load data : ${response.statusCode}");
  }
}