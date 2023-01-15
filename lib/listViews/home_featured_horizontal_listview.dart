import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/holders/home_featured_list_item.dart';
import 'package:ecom/holders/home_recent_list_item.dart';
import 'package:ecom/models/api/product/getProductsParent.dart';
import 'package:ecom/screens/subProducts/subProduct_CategoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:ecom/models/api/dashboard/getDashboardCategory.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class FeaturedWidget {

  Widget getFeatured(BuildContext context, List<GetProductsParent> featured) {

    return Container(
        height: 120,
        child: featured!=null? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(5),
            itemCount: featured.length,
            itemBuilder: (BuildContext context, int index) {
              return HomeFeaturedListItem().getFeaturedItem(context, featured[index]);
            }
        ): ListTileShimmer(isPurplishMode: false, hasBottomBox: false, isDarkMode: false,)
    );
  }

}