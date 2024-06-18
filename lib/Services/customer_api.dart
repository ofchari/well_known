class Welcom {
  Welcom({
    required this.data,
  });

  final List<Datum> data;

  factory Welcom.fromJson(Map<String, dynamic> json){
    return Welcom(
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x.toJson()).toList(),
  };

}

class Datum {
  Datum({
    required this.customerName,
    required this.name,
    required this.salesperson,
  });

  final String? customerName;
  final String? name;
  final String? salesperson;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      customerName: json["customer_name"].toString(),
      name: json["name"].toString(),
      salesperson: json["sales_person"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "name": name,
    "sales_person": salesperson,
  };

}
