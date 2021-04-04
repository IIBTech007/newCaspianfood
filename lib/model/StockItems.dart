import 'dart:convert';


class StockItems {
 static List<StockItems> StockItemsListFromJson(String str) => List<StockItems>.from(json.decode(str).map((x) => StockItems.fromJson(x)));
 static String StockItemsListToJson(List<StockItems> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
 static StockItems StockItemsFromJson(String str) => StockItems.fromJson(json.decode(str));
 static String StockItemsToJson(StockItems data) => json.encode(data.toJson());
 static String UpdatestockItemsToJson(StockItems data) => json.encode(data.toMap());
  StockItems({
    this.newQuantity,
    this.newCostPrice,
    this.stockDetailId,
    this.dailySession,
    this.stockDetailUnit,
    this.stockDetailQuantity,
    this.stockDetailCostPrice,
    this.vendorId,
    this.vendorName,
    this.stockItemDetails,
    this.id,
    this.name,
    this.totalStockQty,
    this.totalPrice,
    this.unit,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isVisible,
    this.storeId,
    this.restaurantId,
    this.restaurant,
  });

 double newQuantity;
 double newCostPrice;
 int stockDetailId;
 int dailySession;
 int stockDetailUnit;
 double stockDetailQuantity;
 double stockDetailCostPrice;
 int vendorId;
 int vendorName;
 List<dynamic> stockItemDetails;
 int id;
 String name;
 double totalStockQty;
 double totalPrice;
 int unit;
 int createdBy;
 DateTime createdOn;
 dynamic updatedBy;
 dynamic updatedOn;
 bool isVisible;
 int storeId;
 dynamic restaurantId;
 dynamic restaurant;

  factory StockItems.fromJson(Map<String, dynamic> json) => StockItems(
    newQuantity: json["newQuantity"] == null ? null : json["newQuantity"],
    newCostPrice: json["newCostPrice"] == null ? null : json["newCostPrice"],
    stockDetailId: json["stockDetailId"] == null ? null : json["stockDetailId"],
    dailySession: json["dailySession"] == null ? null : json["dailySession"],
    stockDetailUnit: json["stockDetailUnit"] == null ? null : json["stockDetailUnit"],
    stockDetailQuantity: json["stockDetailQuantity"] == null ? null : json["stockDetailQuantity"],
    stockDetailCostPrice: json["stockDetailCostPrice"] == null ? null : json["stockDetailCostPrice"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    vendorName: json["vendorName"] == null ? null : json["vendorName"],
    stockItemDetails: json["stockItemDetails"] == null ? null : List<dynamic>.from(json["stockItemDetails"].map((x) => x)),
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    totalStockQty: json["totalStockQty"] == null ? null : json["totalStockQty"],
    totalPrice: json["totalPrice"] == null ? null : json["totalPrice"],
    unit: json["unit"] == null ? null : json["unit"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    updatedBy: json["updatedBy"],
    updatedOn: json["updatedOn"],
    isVisible: json["isVisible"] == null ? null : json["isVisible"],
    storeId: json["storeId"] == null ? null : json["storeId"],
    restaurantId: json["restaurantId"],
    restaurant: json["restaurant"],
  );

  Map<String, dynamic> toJson() => {
    "NewQuantity": newQuantity == null ? null : newQuantity,
    "NewCostPrice": newCostPrice == null ? null : newCostPrice,
   // "stockDetailId": stockDetailId == null ? null : stockDetailId,
    "DailySession": dailySession == null ? null : dailySession,
    "VendorId": vendorId == null ? null : vendorId,
    "Name": name == null ? null : name,
    // "TotalStockQty": totalStockQty == null ? null : totalStockQty,
    // "TotalPrice": totalPrice == null ? null : totalPrice,
    "Unit": unit == null ? null : unit,
    "IsVisible": isVisible == null ? true : isVisible,
    "StoreId": storeId == null ? null : storeId,
  };
 Map<String, dynamic> toMap() => {
   "id": id,
   "NewQuantity": newQuantity == null ? null : newQuantity,
   "NewCostPrice": newCostPrice == null ? null : newCostPrice,
  // "stockDetailId": stockDetailId == null ? null : stockDetailId,
   "DailySession": dailySession == null ? null : dailySession,
   "VendorId": vendorId == null ? null : vendorId,
   "Name": name == null ? null : name,
   // "TotalStockQty": totalStockQty == null ? null : totalStockQty,
   // "TotalPrice": totalPrice == null ? null : totalPrice,
   "Unit": unit == null ? null : unit,
   "IsVisible": isVisible == null ? true : isVisible,
   "StoreId": storeId == null ? null : storeId,
 };
}
