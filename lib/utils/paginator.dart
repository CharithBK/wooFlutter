import 'package:ecom/bloc/bloc_blogpost.dart';
import 'package:ecom/bloc/bloc_dashboard.dart';
import 'package:ecom/http/customhttprequest.dart';
import 'package:ecom/http/woohttprequest.dart';
import 'package:ecom/models/api/blogPosts/getBlogPosts.dart';
import 'package:ecom/models/api/coupon/getCoupons.dart';
import 'package:ecom/models/api/dashboard/getDashboard.dart';
import 'package:ecom/models/api/dashboard/getDashboardProducts.dart';
import 'package:ecom/models/api/dashboard/getDashboardCategory.dart';
import 'package:ecom/screens/blogPostListWidget.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/dokan/screens/dokanVendorsWidget.dart';
import 'package:ecom/dokan/woohttprequest.dart';
import 'package:collection/collection.dart';

//------------------------------DASHBOARD------------------------------//
int dashboard_page=1;
Future<void> loadNewDashboardData() async {
  GetDashboard? value= await CustomHttpRequest().getDashboard(dashboard_page);
  if (value != null) {
    refreshNewDashboardData(value);
    dashboardBloc.refreshDashboards(true);
  }
}
refreshNewDashboardData(GetDashboard _dashboard){
  if(totalProducts==null)
    totalProducts=[];
  if(totalCategories==null)
    totalCategories=[];

  currencyCode=_dashboard.currency_code;
  // currencySymbol=_dashboard.currency_symbol;

  // totalCategoryCount=_dashboard.total_categories;

  featured_products=_dashboard.featured_products;
  top_selling_products=_dashboard.top_selling_products;

  _dashboard.products.forEach((item) {
    var alreadyExistItem= totalProducts!.firstWhereOrNull((element) => element.id==item.id );
    if (alreadyExistItem==null)
      totalProducts!.add(item);
  });
  _dashboard.categories.forEach((item) {
    var alreadyExistItem= totalCategories!.firstWhereOrNull((element) => element.id==item.id );
    if (alreadyExistItem==null)
      totalCategories!.add(item);
  });
  dashboardBloc.refreshDashboards(true);
}


//------------------------------DASHBOARD------------------------------//
int blogpost_page=1;
Future<void> loadNewBlogsData() async {
  List<GetBlogPosts>? value= await WooHttpRequest().getBlogPosts();
  if (value != null) {
    refreshNewBlogPostData(value);
  }
}
refreshNewBlogPostData(List<GetBlogPosts> _blogPostList){
  if(blogPostList==null)
    blogPostList=[];

  _blogPostList.forEach((item) {
    var alreadyExistItem= blogPostList!.firstWhereOrNull((element) => element.id==item.id );
    if (alreadyExistItem==null)
      blogPostList!.add(item);
  });
}
