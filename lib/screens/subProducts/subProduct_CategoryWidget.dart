import 'package:ecom/http/customhttprequest.dart';
import 'package:ecom/listViews/home_product_grid_view.dart';
import 'package:ecom/models/api/dashboard/getDashboardProducts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

class SubProduct_FromCategoryScreen extends StatefulWidget {
  int id;
  String title;
  SubProduct_FromCategoryScreen(this.id, this.title);
  @override
  _SubProduct_FromCategoryScreenState createState() => _SubProduct_FromCategoryScreenState();
}

class _SubProduct_FromCategoryScreenState extends State<SubProduct_FromCategoryScreen>   {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<GetDashBoardProducts>? subscreenProducts;

  @override
  void initState() {
    super.initState();

    CustomHttpRequest().getProductFromCategoryId(widget.id).then((value) {
      if (value != null) {
        subscreenProducts=value;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: BackgroundColor,
        key: _scaffoldKey,
        body: SafeArea(
          child: screen(),
        )
    );
  }


  Widget screen( ) {

    return Container(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: BackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.arrow_back,
                            color: MainHighlighter,
                            size: 25,
                          ),
                        )
                    ),
                   Container(
                     width: MediaQuery.of(context).size.width*0.6,
                     child: Text(
                       widget.title,
                       maxLines: 1,
                       overflow: TextOverflow.visible,
                       textAlign: TextAlign.center,
                       style: TextStyle(color: MainHighlighter,
                         fontSize: 20.0,
                         fontFamily: "Header",
                         letterSpacing: 1.2,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                   Container(),

                  ],
                ),
              )
          ),
          Expanded(
            flex: 10,
            child: subscreenProducts!=null?Container(
                child: ProductGridView().getGridView(context, subscreenProducts!, (){setState(() {});})
            ):Column(children: [ListTileShimmer(),ListTileShimmer(),ListTileShimmer()],)
          )

        ],
      ),
    );
  }


}
