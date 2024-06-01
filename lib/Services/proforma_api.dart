class SalesOrder {
  final String? salesPerson;
  final String? billingPerson;
  final String? company;
  final String? customerName;
  final String? postingdate;
  final String? deliveryDate;

  SalesOrder({
    required this.salesPerson,
    required this.billingPerson,
    required this.company,
    required this.customerName,
    required this.postingdate,
    required this.deliveryDate,
  });

  // Factory constructor to create a SalesOrder from JSON
  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      salesPerson: json['sales_person'] as String?,
      billingPerson: json['billing_person']as String?,
      company: json['company']as String?,
      customerName: json['customer_name']as String?,
      postingdate: json['posting_date']as String?,
      deliveryDate: json['delivery_date']as String?,
    );
  }

}
