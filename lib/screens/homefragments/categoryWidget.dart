import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/bloc/bloc_dashboard.dart';
import 'package:ecom/emuns/screenStatus.dart';
import 'package:ecom/holders/category_list_item.dart';
import 'package:ecom/screens/subProducts/subProduct_CategoryWidget.dart';
import 'package:ecom/utils/commonMethod.dart';
import 'package:ecom/utils/paginator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:ecom/models/api/dashboard/getDashboardCategory.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/languages_local.dart';
import 'package:progress_indicators/progress_indicators.dart';


class CategoryScreen extends StatefulWidget {

  @override
  _CategoryScreenState createState() => new _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  ScreenStatus status = ScreenStatus.active;

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;
      if (before == max &&  status==ScreenStatus.active) {
        print("scroll_end");
        status=ScreenStatus.bussy;
        dashboardBloc.refreshDashboards(true);
        loadNewDashboardData().then((value) {
          status=ScreenStatus.active;
          dashboardBloc.refreshDashboards(true);
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // bool isLoadingMoreCategory = totalCategories != null ? totalCategories!.length < totalCategoryCount : true;

    return Scaffold(
        backgroundColor: BackgroundColor,
        body: Container(
          child: NotificationListener(
              onNotification: _onScrollNotification,
              child: StreamBuilder(
                stream: dashboardBloc.getDashboardStreamController.stream,
                initialData: true,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> widgetList = []
                    ..add(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            Divider(),
                            Row(children: [Container(margin: EdgeInsets.all(7), color: MainHighlighter, width: 7, height: 25,), Text(LocalLanguageString().categories, style: TextStyle(color: MainHighlighter, fontSize: 16, fontWeight: FontWeight.bold))],),

                          ],
                        )
                    )
                    ..addAll(
                      allCategoriesWidget(),
                    )
                    ..add(
                      status==ScreenStatus.bussy?Center(child:JumpingDotsProgressIndicator(fontSize: 30.0,) ):Container(height: 40,)
                    );
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: widgetList.length,
                    itemBuilder: (context, index) {
                      return widgetList[index];
                    },
                  );
                },
              )
          ),
        )
    );
  }

  List<Widget> allCategoriesWidget() {
    return totalCategories != null ? totalCategories!.map((element) {
      return CategoryListItem().itemView(context, element);
    }).toList() : [ListTileShimmer()];
  }
}
