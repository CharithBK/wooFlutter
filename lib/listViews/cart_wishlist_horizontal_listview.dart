import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/holders/cart_wishlist_list_item.dart';
import 'package:ecom/models/api/dashboard/getDashboardProducts.dart';
import 'package:ecom/models/api/product/getProductsParent.dart';
import 'package:ecom/utils/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class WishListWidget {

  Widget getWishListView(BuildContext context, bool showWishList, Function refresh) {

    List<GetDashBoardProducts> wishList = getWishlistPref();
    return showWishList ? Container(
        color: NormalColor.withAlpha(20),
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: wishList != null ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(5),
            itemCount: wishList.length,
            itemBuilder: (BuildContext context, int index) {
              return CartWishList_ListItem().getWishItem(context, wishList[index], refresh);
            }
        ) : ListTileShimmer(isPurplishMode: false, hasBottomBox: false, isDarkMode: false,)
    ) : Container();
  }

}