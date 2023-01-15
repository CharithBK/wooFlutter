import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/models/api/dashboard/getDashboardCategory.dart';
import 'package:ecom/models/api/dashboard/getDashboardProducts.dart';
import 'package:ecom/models/api/product/getProductsParent.dart';
import 'package:ecom/screens/subProducts/subProduct_CategoryWidget.dart';
import 'package:ecom/utils/commonMethod.dart';
import 'package:flutter/material.dart';
import 'package:ecom/WidgetHelper/CustomIcons.dart';
import 'package:ecom/models/api/order/createOrderModel.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/languages_local.dart';
import 'package:ecom/utils/prefrences.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomeFeaturedListItem {

  Widget getFeaturedItem(BuildContext context, GetProductsParent featured) {
    double widthSize=100;
    return Container(
        width: widthSize,
        margin: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, '/homeproductdetail', arguments: {'_product': featured});
          },
          child: Flex(
            direction: Axis.vertical,
            children: [
              featured !=null?
              ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: (featured.images!=null && featured.images.length>0)? featured.images[0].src:"",
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80,
                      height: 80,
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

              ):Container( color :Colors.transparent,width: 50, height: 50,),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      featured.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
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
          ),
        )
    );

  }
}
