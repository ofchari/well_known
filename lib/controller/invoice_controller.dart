import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceController extends GetxController {
  List<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  List<TextEditingController> quantityControllers = <TextEditingController>[].obs;
  List<TextEditingController> rateControllers = <TextEditingController>[].obs;
  List<TextEditingController> totalControllers = <TextEditingController>[].obs;
  TextEditingController netTotalController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (items.isNotEmpty) {
      quantityControllers = List.generate(items.length, (index) => TextEditingController());
      rateControllers = List.generate(items.length, (index) => TextEditingController());
      totalControllers = List.generate(items.length, (index) => TextEditingController());

      for (int index = 0; index < items.length; index++) {
        var item = items[index];
        quantityControllers[index].text = item['total_quantity'].toString();
        rateControllers[index].text = item['rate'].toString();
        totalControllers[index].text = item['total'].toString();
      }
    }
  }

  void calculateNetTotal() {
    double netTotal = 0.0;
    for (var totalController in totalControllers) {
      double total = double.tryParse(totalController.text) ?? 0.0;
      netTotal += total;
    }
    netTotalController.text = netTotal.toStringAsFixed(2);
  }

  void addItem(Map<String, dynamic> item) {
    items.add(item);
    quantityControllers.add(TextEditingController(text: item['total_quantity'].toString()));
    rateControllers.add(TextEditingController(text: item['rate'].toString()));
    totalControllers.add(TextEditingController(text: item['total'].toString()));
    calculateNetTotal();
  }

  void removeItem(int index) {
    items.removeAt(index);
    quantityControllers.removeAt(index);
    rateControllers.removeAt(index);
    totalControllers.removeAt(index);
    calculateNetTotal();
  }
}
