import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/emuns/apptheme.dart';
import 'package:ecom/models/api/dashboard/getDashboardCategory.dart';
import 'package:ecom/models/api/dashboard/getDashboardProducts.dart';
import 'package:ecom/models/api/product/getProductsParent.dart';
import 'package:ecom/screens/subProducts/subProduct_CategoryWidget.dart';
import 'package:ecom/utils/commonMethod.dart';
import 'package:ecom/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:ecom/WidgetHelper/CustomIcons.dart';
import 'package:ecom/models/api/order/createOrderModel.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/languages_local.dart';
import 'package:ecom/utils/prefrences.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomeRecentListItem {
  BuildContext context;
  GetProductsParent recent;
  double itemHeight;
  double itemPadding;

  HomeRecentListItem(this.context,this.recent, this.itemHeight,this.itemPadding);

  Widget getRecentItem() {
    return Container(
        margin: EdgeInsets.only(right: itemPadding,left: itemPadding),
        child: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/homeproductdetail', arguments: {'_product': recent});
            },
            child: //mainTheme_RecentItem()
            AppTHEME== AppTheme.main? mainTheme_RecentItem():
            AppTHEME== AppTheme.food? foodTheme_RecentItem(): mainTheme_RecentItem()
        )
    );
  }

  mainTheme_RecentItem(){
    return Flex(
      direction: Axis.vertical,
      children: [
        recent.images!=null&&recent.images.length>0?
        ClipOval(
            child: CachedNetworkImage(
              imageUrl: recent.images[0].src,
              imageBuilder: (context, imageProvider) => Container(
                width: itemHeight-30,
                height: itemHeight-30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Center(child: JumpingDotsProgressIndicator(fontSize: 20.0,)),
              errorWidget: (context, url, error) => Center(child:Icon(Icons.filter_b_and_w),),
            )

        ):Container( child: Icon(Icons.workspaces_outline),width: itemHeight, height: itemHeight,),
        Expanded(
            flex: 1,
            child: Container(
              width: itemHeight,
              child: Text(
                recent.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontFamily: "Normal",
                  color: NormalColor,
                ),
              ),
            )
        ),
      ],
    );
  }
  foodTheme_RecentItem( ){
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        recent.images!=null&&recent.images.length>0?
        CachedNetworkImage(
          imageUrl: recent.images[0].src,
          imageBuilder: (context, imageProvider) => Container(
            width: itemHeight,
            height: itemHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Center(child: JumpingDotsProgressIndicator(fontSize: 20.0,)),
          errorWidget: (context, url, error) => Center(child:Icon(Icons.filter_b_and_w),),
        ):Container( child: Icon(Icons.workspaces_outline),width: itemHeight, height: itemHeight,),
        Image.asset(
          'assets/gradient.png',
          width: itemHeight,
          height: itemHeight,
          fit: BoxFit.fitHeight,
        ),
        Container(
          width: itemHeight,
          padding: EdgeInsets.all(5),
          child: Text(
            recent.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: "header",
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
