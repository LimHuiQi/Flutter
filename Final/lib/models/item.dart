class Item {
  String? itemId;
  String? userId;
  String? userPhone;
  String? itemBrand;
  String? itemName;
  String? itemType;
  String? itemDesc;
  String? itemPrice;
  String? itemInterest;
  String? itemLat;
  String? itemLong;
  String? itemState;
  String? itemLocality;
  String? itemDate;

  Item(
      {this.itemId,
      this.userId,
      this.userPhone,
      this.itemBrand,
      this.itemName,
      this.itemType,
      this.itemDesc,
      this.itemPrice,
      this.itemInterest,
      this.itemLat,
      this.itemLong,
      this.itemState,
      this.itemLocality,
      this.itemDate});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    userPhone = json['user_phone'];
    itemBrand = json['item_brand'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    itemDesc = json['item_desc'];
    itemPrice = json['item_price'];
    itemInterest = json['item_interest'];
    itemLat = json['item_lat'];
    itemLong = json['item_long'];
    itemState = json['item_state'];
    itemLocality = json['item_locality'];
    itemDate = json['item_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['user_phone'] = userPhone;
    data['item_brand'] = itemBrand;
    data['item_name'] = itemName;
    data['item_type'] = itemType;
    data['item_desc'] = itemDesc;
    data['item_price'] = itemPrice;
    data['item_interest'] = itemInterest;
    data['item_lat'] = itemLat;
    data['item_long'] = itemLong;
    data['item_state'] = itemState;
    data['item_locality'] = itemLocality;
    data['item_date'] = itemDate;
    return data;
  }
}
