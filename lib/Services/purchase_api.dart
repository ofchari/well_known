class PurchaseInvoice {
  final String? name;
  final String? supplier;
  final String? supplierGstin;
  final String? postingDate;
  final String? taxId;
  final String? gst_category;
  final String? contact;
  final String? status;
  final String? company;
  final double? grand_total;
  final double? rounding_adjustment;
  final double? rounded_total;
  final String? in_words;
  final List? items;
  final List? taxes;
  final List? payment_schedule;


  PurchaseInvoice({
    required this.name,
    required this.supplier,
    required this.supplierGstin,
    required this.postingDate,
    required this.taxId,
    required this.gst_category,
    required this.contact,
    required this.status,
    required this.company,
    required this.grand_total,
    required this.rounding_adjustment,
    required this.rounded_total,
    required this.in_words,
    required this.items,
    required this.taxes,
    required this.payment_schedule,
  });

  // Factory constructor to create a PurchaseInvoice from JSON
  factory PurchaseInvoice.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoice(
      name: json['name'] as String?,
      supplier: json['supplier'] as String?,
      supplierGstin: json['supplier_gstin']as String?,
      postingDate: json['posting_date']as String?,
      taxId: json['tax_id']as String?,
      gst_category: json['gst_category']as String?,
      contact: json['contact']as String?,
      status: json['status']as String?,
      company: json['company']as String?,
      grand_total: json['grand_total']as double?,
      rounding_adjustment: json['rounding_adjustment']as double?,
      rounded_total: json['rounded_total']as double?,
      in_words: json['in_words']as String?,
      items: json['items']as List?,
      taxes: json['taxes']as List?,
      payment_schedule: json['payment_schedule']as List?,

    );
  }
}
