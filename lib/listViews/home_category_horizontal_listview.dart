import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/emuns/screenStatus.dart';
import 'package:ecom/holders/home_category_list_item.dart';
import 'package:ecom/screens/subProducts/subProduct_CategoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:ecom/models/api/dashboard/getDashboardCategory.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class CategoryButton {

  double itemHeight =100;
  double itemPadding=2;
  Widget getCategoryUI(BuildContext context, ScreenStatus status) {
    // bool isLoadingMoreCategory = totalCategories != null ? totalCategories!.length < totalCategoryCount : true;

    return Container(
        height: itemHeight,
        child: totalCategories!=null? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: totalCategories!.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                  children: [HomeCategoryListItem(context, totalCategories![index],itemHeight,itemPadding).getCategoryItem(),
                    if (status==ScreenStatus.bussy && index==totalCategories!.length-1)
                      Center(child: Container(child: JumpingDotsProgressIndicator(fontSize: 30.0,) , margin: EdgeInsets.only(right: 20),))
                    else if(index==totalCategories!.length-1)
                      Container(width: 40,)
                    else
                      Container()
                    // (isLoadingMoreCategory && index==totalCategories!.length-1) ? Container(child: JumpingDotsProgressIndicator(fontSize: 30.0,)) : Container(),
                  ]
              );
            }
        ): ListTileShimmer(isPurplishMode: false, hasBottomBox: false, isDarkMode: false,)
    );
  }

}