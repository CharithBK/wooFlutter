import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/WidgetHelper/CustomIcons.dart';
import 'package:ecom/models/api/blogPosts/getBlogPosts.dart';
import 'package:ecom/models/api/product/getProductsParent.dart';
import 'package:flutter/material.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/languages_local.dart';
import 'package:ecom/utils/prefrences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

class BlogPostDetailScreen extends StatefulWidget {
  String title;
  String link;
  BlogPostDetailScreen(this.title, this.link, {Key? key}) : super(key: key);


  @override
  _BlogPostDetailScreenState createState() => _BlogPostDetailScreenState();
}

class _BlogPostDetailScreenState extends State<BlogPostDetailScreen> {

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BackgroundColor,
        body: Container(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                  )
              ),
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
                              height: 40,
                              width: 40,

                              child: Icon(Icons.arrow_back,
                                color: MainHighlighter,
                                size: 25,),
                            )
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: MainHighlighter,
                            fontSize: 20.0,
                            fontFamily: "Header",
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(),

                      ],
                    ),
                  )
              ),
              Expanded(
                  flex: 13,
                  child: Stack(
                    children: [
                      WebView(
                        onPageStarted: (_){
                          isLoading=false;
                          setState(() {});
                        },
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl: widget.link,
                      ),
                      isLoading? ListTileShimmer(isPurplishMode: false, hasBottomBox: false, isDarkMode: false,):Container(),
                    ],
                  )
              )
            ],
          ),
        )
    );
  }

}
