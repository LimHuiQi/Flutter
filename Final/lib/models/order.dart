class Order {
  String? orderId;
  String? itemId;
  String? itemBrand;
  String? itemName;
  String? itemPrice;
  String? itemInterest;
  String? userId;
  String? userPhone;
  String? sellerId;
  String? orderDate;

  Order(
      {this.orderId,
      this.itemId,
      this.itemBrand,
      this.itemName,
      this.itemPrice,
      this.itemInterest,
      this.userId,
      this.userPhone,
      this.sellerId,
      this.orderDate});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    itemId = json['item_id'];
    itemBrand = json['item_brand'];
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    itemInterest = json['item_interest'];
    userId = json['user_id'];
    userPhone = json['user_phone'];
    sellerId = json['seller_id'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['item_id'] = itemId;
    data['item_brand'] = itemBrand;
    data['item_name'] = itemName;
    data['item_price'] = itemPrice;
    data['item_interest'] = itemInterest;
    data['user_id'] = userId;
    data['user_phone'] = userPhone;
    data['seller_id'] = sellerId;
    data['order_date'] = orderDate;
    return data;
  }
}
