class SalesOrder {
  final String? name;
  final String? billingPerson;
  final String? company;
  final String? status;
  final String? gstcategory;
  final String? owner;
  final String? customer;
  final String? customerName;
  final String? customeraddress;
  final String? contactnumber;
  final String? transactiondate;
  final String? billingaddressgstin;
  final String? customeremail;
  final String? ordertype;
  final String? customer_group;
  final String? sellingpricelist;
  final String? pricelistcurrency;
  final String? currency;
  final String? deliveryDate;
  final List? items;
  final List? taxes;
  final List? ts_tax_breakup_table;
  final List? payment_schedule;

  SalesOrder({
    required this.name,
    required this.billingPerson,
    required this.company,
    required this.status,
    required this.gstcategory,
    required this.owner,
    required this.customer,
    required this.customerName,
    required this.customeraddress,
    required this.contactnumber,
    required this.transactiondate,
    required this.billingaddressgstin,
    required this.customeremail,
    required this.customer_group,
    required this.sellingpricelist,
    required this.pricelistcurrency,
    required this.currency,
    required this.ordertype,
    required this.deliveryDate,
    required this.items,
    required this.taxes,
    required this.ts_tax_breakup_table,
    required this.payment_schedule,
  });

  // Factory constructor to create a SalesOrder from JSON
  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      name: json['name'] as String?,
      billingPerson: json['billing_person']as String?,
      status: json['status']as String?,
      gstcategory: json['gst_category']as String?,
      owner: json['owner']as String?,
      company: json['company']as String?,
      customer: json['customer']as String?,
      customerName: json['customer_name']as String?,
      customeraddress: json['customer_address']as String?,
      contactnumber: json['contact_number']as String?,
      transactiondate: json['transaction_date']as String?,
      billingaddressgstin: json['billing_address_gstin']as String?,
      pricelistcurrency: json['price_list_currency']as String?,
      customeremail: json['customer_email']as String?,
      customer_group: json['customer_group']as String?,
      currency: json['currency']as String?,
      sellingpricelist: json['selling_price_list']as String?,
      ordertype: json['order_type']as String?,
      deliveryDate: json['delivery_date']as String?,
      items: json['items']as List?,
      taxes: json['taxes']as List?,
      ts_tax_breakup_table: json['ts_tax_breakup_table']as List?,
      payment_schedule: json['payment_schedule']as List?,
    );
  }

}
