class Sales{
  final String? name;
  final String? sales_person;
  final String? billing_person;
  final String? billing_address_gstin;
  final String? attended_by;
  final String? attended_person;
  final String? base_total;
  final String? company;
  final String? branch;
  final String? customer;
  final String? customer_name;
  final String? delivery_mode;
  final String? customer_address;
  final String? posting_date;
  final String? due_date;
  final String? selling_price_list;
  final String? mobile_no;
  final List? items;
  final List? taxes;
  final List? ts_tax_breakup_table;
  final List? payment_schedule;

  Sales({
    this.name,
    this.sales_person,
    this.billing_person,
    this.billing_address_gstin,
    this.attended_by,
    this.attended_person,
    this.base_total,
    this.company,
    this.branch,
    this.customer,
    this.customer_name,
    this.delivery_mode,
    this.customer_address,
    this.posting_date,
    this.due_date,
    this.selling_price_list,
    this.mobile_no,
    this.items,
    this.taxes,
    this.ts_tax_breakup_table,
    this.payment_schedule,
  });
  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      name: json['name'] as String?,
      sales_person: json['sales_person'] as String?,
      billing_person: json['billing_person'] as String?,
      billing_address_gstin: json['billing_address_gstin'] as String?,
      attended_by: json['attended_by'] as String?,
      attended_person: json['attended_person'] as String?,
      base_total: json['base_total'].toString(),
      company: json['company'] as String?,
      branch: json['branch'] as String?,
      customer: json['customer'] as String?,
      customer_name: json['customer_name'] as String?,
      delivery_mode: json['delivery_mode'] as String?,
      customer_address: json['customer_address'] as String?,
      posting_date: json['posting_date'] as String?,
      due_date: json['due_date'] as String?,
      selling_price_list: json['selling_price_list'] as String?,
      mobile_no: json['mobile_no'] as String?,
      items: json['items']as List?,
      taxes: json['taxes']as List?,
      ts_tax_breakup_table: json['ts_tax_breakup_table']as List?,
      payment_schedule: json['payment_schedule']as List?,
    );
  }
}