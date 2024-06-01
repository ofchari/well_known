class Sales{
  final String? sales_person;
  final String? billing_person;
  final String? attended_by;
  final String? attended_person;
  final String? company;
  final String? branch;
  final String? customer;
  final String? customer_address;
  final String? posting_date;
  final String? due_date;

  Sales({
    this.sales_person,
    this.billing_person,
    this.attended_by,
    this.attended_person,
    this.company,
    this.branch,
    this.customer,
    this.customer_address,
    this.posting_date,
    this.due_date,
  });
  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      sales_person: json['sales_person'] as String?,
      billing_person: json['billing_person'] as String?,
      attended_by: json['attended_by'] as String?,
      attended_person: json['attended_person'] as String?,
      company: json['company'] as String?,
      branch: json['branch'] as String?,
      customer: json['customer'] as String?,
      customer_address: json['customer_address'] as String?,
      posting_date: json['posting_date'] as String?,
      due_date: json['due_date'] as String?,
    );
  }
}