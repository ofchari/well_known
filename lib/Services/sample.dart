class Welcome {
  Welcome({
    required this.success,
    required this.categoryList,
  });

   bool? success;
  List<CategoryList> categoryList;

  factory Welcome.fromJson(Map<String, dynamic> json){
    return Welcome(
      success: json["success"],
      categoryList: json["categoryList"] == null ? [] : List<CategoryList>.from(json["categoryList"]!.map((x) => CategoryList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "categoryList": categoryList.map((x) => x.toJson()).toList(),
  };

}

class CategoryList {

  final int? categoryId;
  final String? category;
  final String? description;
  final dynamic deletedOn;
  final dynamic removedRemarks;
  final int? createdBy;


  CategoryList({
    required this.categoryId,
    required this.category,
    required this.description,
    required this.deletedOn,
    required this.removedRemarks,
    required this.createdBy,
  });


  factory CategoryList.fromJson(Map<String, dynamic> json){
    return CategoryList(
      categoryId: json["categoryId"],
      category: json["category"],
      description: json["description"],
      deletedOn: json["deletedOn"],
      removedRemarks: json["removedRemarks"],
      createdBy: json["createdBy"],
    );
  }

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "category": category,
    "description": description,
    "deletedOn": deletedOn,
    "removedRemarks": removedRemarks,
    "createdBy": createdBy,
  };

}
