class Item {
  final String? name;
  final String? itemName;
  final String? itemGroup;
  final String? salesPerson;
  final String? rackName;
  final String? itemSubGroup;
  final String? binNo;

  Item({
    this.name,
    this.itemName,
    this.itemGroup,
    this.salesPerson,
    this.rackName,
    this.itemSubGroup,
    this.binNo,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String?,
      itemName: json['item_name'] as String?,
      itemGroup: json['item_group'] as String?,
      salesPerson: json['sales_person'] as String?,
      rackName: json['rack_name'] as String?,
      itemSubGroup: json['item_sub_group'] as String?,
      binNo: json['bin_no'] as String?,
    );
  }
}