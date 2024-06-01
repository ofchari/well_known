class PurchaseInvoice {
  final String? supplier;
  final String? supplierGstin;
  final String? postingDate;
  final String? taxId;
  final String? company;

  PurchaseInvoice({
    required this.supplier,
    required this.supplierGstin,
    required this.postingDate,
    required this.taxId,
    required this.company,
  });

  // Factory constructor to create a PurchaseInvoice from JSON
  factory PurchaseInvoice.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoice(
      supplier: json['supplier'] as String?,
      supplierGstin: json['supplier_gstin']as String?,
      postingDate: json['posting_date']as String?,
      taxId: json['tax_id']as String?,
      company: json['company']as String?,
    );
  }
}
