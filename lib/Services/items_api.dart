class Item {
  final String? name;
  final String? itemName;
  final String? itemGroup;
  final String? part_no;
  final String? brand;
  final String? stock_uom;
  final String? gst_hsn_code;
  final String? image;

  Item({
    this.name,
    this.itemName,
    this.itemGroup,
    this.part_no,
    this.brand,
    this.stock_uom,
    this.gst_hsn_code,
    this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String?,
      itemName: json['item_name'] as String?,
      itemGroup: json['item_group'] as String?,
      part_no: json['part_no'] as String?,
      brand: json['brand'] as String?,
      stock_uom: json['stock_uom'] as String?,
      gst_hsn_code: json['gst_hsn_code'] as String?,
      image: json['image'] as String?,
    );
  }
}