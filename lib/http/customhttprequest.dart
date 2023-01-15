import 'package:ecom/models/api/dashboard/getDashboard.dart';
import 'package:ecom/models/api/dashboard/getDashboardProducts.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/consts.dart';
import 'package:ecom/utils/paginator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class CustomHttpRequest {

//-----------------------------------WOOCOMMERCE CUSTOM API-----------------------------------------------------//

   //CUSTOM : DASHBOARD
  Future<GetDashboard?> getDashboard(int page) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    final response = await http.get(Uri.parse(WOOCOMM_URL+"dashboard-api/?paged=$page"),headers: headers);//filter[limit] =-1

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      dashboard_page++;
      var responseJson = json.decode(response.body);
      return GetDashboard.fromJson(responseJson);
     } else {
      return null;
    }
  }
  //CUSTOM : PRODUCT FROM ID
  Future<List<GetDashBoardProducts>> getProductsFromId(List<int> ids) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    String idsList="";
    ids.forEach((element) { idsList= idsList+"$element,";});
    if(idsList.length>0)
      idsList=idsList.substring(0, idsList.length - 1);
    final response = await http.get(Uri.parse(WOOCOMM_URL+"product-by-id/?id=$idsList"),headers: headers);

    print(json.decode(response.body));
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return List<GetDashBoardProducts>.from(responseJson.map((data) => GetDashBoardProducts.fromJson(data)));
    } else {
      return [];

    }
  }
  //CUSTOM : PRODUCTS_BY_CATEGORY
  Future<List<GetDashBoardProducts>> getProductFromCategoryId(int id) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    final response = await http.get(Uri.parse(WOOCOMM_URL+"category-products-api/?id=$id"),headers: headers);//filter[limit] =-1

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return List<GetDashBoardProducts>.from(responseJson.map((data) => GetDashBoardProducts.fromJson(data)));
    } else {
      return [];
    }
  }
  //CUSTOM : TOP_SELLING_PRODUCT
  Future<List<GetDashBoardProducts>> getTopSellingProducts() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    final response = await http.get(Uri.parse(WOOCOMM_URL+"top-selling-products/"),headers: headers);//filter[limit] =-1

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return List<GetDashBoardProducts>.from(responseJson.map((data) => GetDashBoardProducts.fromJson(data)));
    } else {
      return [];
    }
  }
  //CUSTOM : SEARCH_PRODUCT
  Future<List<GetDashBoardProducts>> getSearchProducts(String searchKeyWord) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    final response = await http.get(Uri.parse(WOOCOMM_URL+"product-search-api/?search=$searchKeyWord"),headers: headers);//filter[limit] =-1

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return List<GetDashBoardProducts>.from(responseJson.map((data) => GetDashBoardProducts.fromJson(data)));
    } else {
      return [];
    }
  }
}