import 'package:muskan_chef_app/item.dart';

class Order {
  List<dynamic>? items;
  String? orderKey;
  String? orderTime;
  String? orderedBy;
  String? shopAddress;
  double? totalPrice;
  String? orderId;

  Order(
      {this.items,
      this.orderKey,
      this.orderTime,
      this.orderedBy,
      this.shopAddress,
      this.orderId,
      this.totalPrice});
}
