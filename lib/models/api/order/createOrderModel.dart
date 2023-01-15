
import 'package:ecom/models/api/customer/customerBillingModel.dart';
import 'package:ecom/models/api/customer/customerShippingModel.dart';
import 'package:ecom/models/api/dashboard/getDashboardProducts.dart';

class CreateOrder{
  String payment_method;
  String payment_method_title;
  bool set_paid;
  Billing billing;
  Shipping shipping;
  List<Line_items> line_items;
  List<Map<String,String>> shipping_lines;

  CreateOrder(this.payment_method, this.payment_method_title, this.set_paid, this.billing, this.shipping, this.line_items, this.shipping_lines);

  Map<String, dynamic> toJson() =>
      {
        'payment_method': payment_method,
        'payment_method_title': payment_method_title,
        'set_paid': set_paid,
        'billing': billing,
        'shipping': shipping,
         'line_items': line_items.map((element) {
          return element.toJson();
        }).toList(),
        'shipping_lines': shipping_lines,
      };
}

class Line_items{
  int product_id;
  int variation_id=-1;
  int quantity;
  GetDashBoardProducts productDetail;// only for cart screen .
  Line_items(this.product_id, this.variation_id, this.quantity, this.productDetail){}

  Line_items.fromJson(Map<String, dynamic> json):
        product_id = json['product_id'],
        variation_id = json.containsKey("variation_id")?json['variation_id']:-1,
        quantity = json['quantity'],
        productDetail = GetDashBoardProducts.fromJson(json['productDetail'])
  {}

  Map<String, dynamic> toJson()
  {
    Map<String, dynamic> map={
        'product_id': product_id,
        'variation_id': variation_id,
        'quantity': quantity,
        'productDetail': productDetail.toJson(),
      };
    map.removeWhere((key, value) => (key=="variation_id"&& value == -1));
    return map;
  }
}
