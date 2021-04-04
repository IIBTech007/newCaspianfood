
import 'dart:convert';

class Products {
  static List<Products> listProductFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

  static String listProductToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  static Products ProductFromJson(String str) => Products.fromJson(json.decode(str));

  static String ProductToJson(Products data) => json.encode(data.toJson());
  Products({
    // this.productIngredients,
    this.id,
    this.name,
    this.description,
    this.image,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isVisible,
    this.storeId,
    this.categoryId,
    this.subCategoryId,
    this.productSizes,
    this.productPictures
    // this.additionalItems,
    // this.baseSections,
    // this.orderItems,
  });

//  List<dynamic> productIngredients;
  int id;
  String name;
  String description;
  String image;
  int createdBy;
  DateTime createdOn;
  int updatedBy;
  DateTime updatedOn;
  bool isVisible;
  int storeId;
  int categoryId;
  int subCategoryId;
  List<dynamic> productSizes;
  List<dynamic> productPictures;

  // List<dynamic> additionalItems;
  // List<dynamic> baseSections;
  // List<dynamic> orderItems;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    // productIngredients: List<dynamic>.from(json["productIngredients"].map((x) => x)),
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    createdBy: json["createdBy"],
    createdOn: DateTime.parse(json["createdOn"]),
    updatedBy: json["updatedBy"],
    updatedOn: DateTime.parse(json["updatedOn"]),
    isVisible: json["isVisible"],
    storeId: json["storeId"],
    categoryId: json["categoryId"],
    subCategoryId: json["subCategoryId"],
    productSizes: json["productSizes"],
    productPictures: json["productPictures"] == null ? null : List<dynamic>.from(json["productPictures"].map((x) => x)),


    //productSizes: List<ProductSize>.from(json["productSizes"].map((x) => ProductSize.fromJson(x))),
    // additionalItems: List<dynamic>.from(json["additionalItems"].map((x) => x)),
    // baseSections: List<dynamic>.from(json["baseSections"].map((x) => x)),
    // orderItems: List<dynamic>.from(json["orderItems"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    //"productIngredients": List<dynamic>.from(productIngredients.map((x) => x)),
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "createdBy": createdBy,
    "createdOn": createdOn.toIso8601String(),
    "updatedBy": updatedBy,
    "updatedOn": updatedOn.toIso8601String(),
    "isVisible": isVisible,
    "storeId": storeId,
    "categoryId": categoryId,
    "subCategoryId": subCategoryId,
    "productSizes": productSizes,
    "productPictures": productPictures == null ? null : List<dynamic>.from(productPictures.map((x) => x)),

    // "productSizes": List<dynamic>.from(productSizes.map((x) => x.toJson())),

  };
}
