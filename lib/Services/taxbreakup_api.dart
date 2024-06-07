import 'dart:convert';
class TaxBreakup {
  String name;
  String owner;
  DateTime creation;
  DateTime modified;
  String modifiedBy;
  String parent;
  String parentfield;
  String parenttype;
  int idx;
  int docstatus;
  String tsGstHsn;
  int tsGstRate;
  double tsTaxableValues;
  int tsCentralTax;
  double tsCentralAmount;
  int tsStateTax;
  double tsStateAmount;
  double tsTotalTaxAmount;
  int tsIgstTax;
  double tsIgstAmount;
  String doctype;

  TaxBreakup({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.parent,
    required this.parentfield,
    required this.parenttype,
    required this.idx,
    required this.docstatus,
    required this.tsGstHsn,
    required this.tsGstRate,
    required this.tsTaxableValues,
    required this.tsCentralTax,
    required this.tsCentralAmount,
    required this.tsStateTax,
    required this.tsStateAmount,
    required this.tsTotalTaxAmount,
    required this.tsIgstTax,
    required this.tsIgstAmount,
    required this.doctype,
  });

  factory TaxBreakup.fromJson(Map<String, dynamic> json) {
    return TaxBreakup(
      name: json['name'],
      owner: json['owner'],
      creation: DateTime.parse(json['creation']),
      modified: DateTime.parse(json['modified']),
      modifiedBy: json['modified_by'],
      parent: json['parent'],
      parentfield: json['parentfield'],
      parenttype: json['parenttype'],
      idx: json['idx'],
      docstatus: json['docstatus'],
      tsGstHsn: json['ts_gst_hsn'],
      tsGstRate: json['ts_gst_rate'],
      tsTaxableValues: json['ts_taxable_values'],
      tsCentralTax: json['ts_central_tax'],
      tsCentralAmount: json['ts_central_amount'],
      tsStateTax: json['ts_state_tax'],
      tsStateAmount: json['ts_state_amount'],
      tsTotalTaxAmount: json['ts_total_tax_amount'],
      tsIgstTax: json['ts_igst_tax'],
      tsIgstAmount: json['ts_igst_amount'],
      doctype: json['doctype'],
    );
  }
}


