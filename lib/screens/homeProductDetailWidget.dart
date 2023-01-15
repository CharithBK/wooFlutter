
import 'package:ecom/models/api/dashboard/getDashboardProducts.dart';
import 'package:ecom/models/api/product/getProductsParent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecom/WidgetHelper/CustomIcons.dart';
import 'package:ecom/WidgetHelper/productImageSlider.dart';
import 'package:ecom/models/api/order/createOrderModel.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/languages_local.dart';
import 'package:ecom/utils/prefrences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:collection/collection.dart';

class HomeProdcutDetailScreen extends StatefulWidget {
  @override
  _ProductItemDetailState createState() => _ProductItemDetailState();
}

class _ProductItemDetailState extends State<HomeProdcutDetailScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, String> optionSelected = Map();
  Variations? variation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute.of(context)!.settings.arguments as Map;
    GetProductsParent? thisProduct = map['_product'];

    addRecentViewedPref(thisProduct as GetDashBoardProducts);

    variation = null;
    thisProduct.variations.forEach((variant) {
      if (variant.visible) {
        bool attrOptionMatches = true;
        variant.attributes.forEach((attr) {
          if (optionSelected.containsKey(attr.name) &&
              (optionSelected[attr.name]!.toLowerCase() == attr.option.toLowerCase())||(attr.option.toLowerCase() == "")) {
            print(variant.price+"");
          }
          else {
            attrOptionMatches = false;
          }
        });
        if (attrOptionMatches) {
          variation = variant;
        }
      }
    });

    return Scaffold(
        backgroundColor: BackgroundColor,
        key: _scaffoldKey,
        body: screen(thisProduct),
    );
  }


  Widget screen(GetProductsParent? thisProduct) {
    List cartList = getCartProductsPref();
    bool isCartItem=getCartProductsPref().firstWhereOrNull((element) => element.product_id==thisProduct!.id )!=null;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      getImageProductSlider(
                          context,
                          (variation == null ? thisProduct!.images : (variation!.images ==
                              null ? "" : variation!.images) )as List<Images>
                      ),

                    ],
                  ),
                  body(thisProduct!),

                  GestureDetector(
                    onTap: () {
                      if (variation != null && (!variation!.in_stock || !variation!.purchaseable))
                      {
                        final snackBar = SnackBar(
                          content: Text(LocalLanguageString().notavailable),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else
                      {
                        if(isCartItem)
                          delCartProductsPref(thisProduct.id);
                        else
                          addORupdateCartProductsPref(Line_items(thisProduct.id, variation == null ? -1 : variation!.id, 1,thisProduct as GetDashBoardProducts));
                      }
                      setState(() {});
                    },
                    child: Center(
                      child: Container(
                        height: 50,
                          color: SecondaryHighlighter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                isCartItem ?"Remove":LocalLanguageString().addtocart,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Normal",
                                    color:BackgroundColor,//isCartItem?NormalColor:MainHighlighter,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Image.asset(
                                isCartItem?"assets/removecart.png":"assets/addcart.png",width: 25,height: 25,color:BackgroundColor//isCartItem?NormalColor:MainHighlighter,
                              ),
                            ],
                          )
                      ),
                    ),
                  )
                ],
              ),
          ),
        ),
        Container(
          height: 90,
          alignment: Alignment.topCenter,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(top: 40,left: 10,right: 10,bottom: 10),
                    child: Stack(
                      children: [
                        Icon(Icons.circle, color: MainHighlighter, size: 30,),
                        Icon(Icons.cancel, color: BackgroundColor, size: 30,)
                      ],
                    ),
                  )
              ),
              cartList.length > 0 ? Container(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/cart', arguments: {'_showAppBar': true});
                      },
                      child:
                      Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(top: 40,left: 10,right: 10,bottom: 10),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Icon(Icons.circle, color: MainHighlighter, size: 30,),
                                  Container(
                                    width: 30,
                                    child: Text(
                                      cartList.length.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: BackgroundColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.shopping_cart_outlined, color: MainHighlighter, size: 30,),
                             ],
                          )
                      )
                  )
              ) : Container(),

            ],
          ),
        ),
      ],
    ) ;
  }


  Widget body(GetProductsParent thisProduct) {
     return Container(
        padding: EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            thisProduct.featured?Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     Text(
                      "Featured Product ",
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SecondaryHighlighter,
                      ),
                    ),
                    Icon(Icons.api, color: SecondaryHighlighter, size: 22,),
                  ],
                )
            ):Container(),
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text(
                thisProduct.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: NormalColor,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      "${currencyCode==null?"":currencyCode} ${variation == null ? thisProduct.price : variation!.price}.00  ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: NormalColor,
                      ),
                    ),

                    thisProduct.on_sale  ?Text(
                      "${currencyCode==null?"":currencyCode} ${variation == null ? thisProduct.regular_price : variation!.regular_price}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Header",
                        decoration: TextDecoration.lineThrough,
                        fontSize: 20,
                        color: NormalColor,
                      ),
                    )
                        : Container()
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      "OnSale ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: NormalColor,
                      ),
                    ),
                    Text(
                      thisProduct.on_sale?" Yes":" No",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SecondaryHighlighter,
                      ),
                    )

                  ],
                )
            ),
            Container(
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      "Availabiliy ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: NormalColor,
                      ),
                    ),

                    thisProduct.on_sale ?Text(
                      thisProduct.in_stock?" In stock":" Out of stock",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SecondaryHighlighter,
                      ),
                    )
                        : Container()
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      "Rating  ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: NormalColor,
                      ),
                    ),
                    Container(
                      child: getReviews(thisProduct.average_rating,thisProduct.rating_count),
                    ),
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      "Sales  ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: NormalColor,
                      ),
                    ),
                    Container(
                      child: Text(
                        thisProduct.total_sales.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Normal",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SecondaryHighlighter,
                        ),
                      ),
                    ),
                  ],
                )
            ),
            thisProduct.attributes.length>0?Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Variants",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: SecondaryHighlighter,
                ),
              ),
            ):Container(),
            Container(
              child: getAttributes(thisProduct),
            ),
            thisProduct.short_description==""?Container():Container(
              child: Text(
                "Short Description",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: SecondaryHighlighter,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only( bottom: 10),
              child: Text(
                thisProduct.short_description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "Header",
                  fontSize: 14,
                  color: NormalColor,
                ),
              ),
            ),
            thisProduct.description==""?Container():Container(
              child: Text(
                "Description",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: SecondaryHighlighter,
                ),
              ),
            ),
            Container(
              child: Text(
                thisProduct.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: "Header",
                  fontSize: 14,
                  color: NormalColor,
                ),
              ),
            ),

            // Container(
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: Html(
            //               style: {
            //                 "body": Style(
            //                   fontFamily: "Normal",
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: FontSize(18),
            //                   color: NormalColor,
            //                 ),
            //               },
            //               data: thisProduct.description
            //           )
            //       ),
            //     ],
            //   )
            // ),



          ],
        )
    );
  }

  Widget getAttributes(GetProductsParent thisProduct) {
    List<ProductAttributes> attributes = thisProduct.attributes;


    return (attributes != null && attributes.length > 0) ? Card(
      child: Container(
          color: NormalColor.withOpacity(0.1),
          padding: EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: []
                ..addAll(attributes.map((attr) {
                  return attr.visible ?
                  Container(
                    child: Wrap(
                        direction: Axis.vertical,
                        children: []..add(
                          Text(
                            attr.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Header",
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: NormalColor,
                            ),
                          ),
                        )..add(
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: attr.options.map((options) {

                                  var foundOptionInVariant = false;
                                  if (optionSelected.length > 0 && !optionSelected.containsKey(attr.name)) {
                                    thisProduct.variations.forEach((variant) {

                                      var attributeFound = true;
                                      variant.attributes.forEach((varAttr) {

                                        var viewMatchVarAttr=(attr.name.toLowerCase()==varAttr.name.toLowerCase()&& (options.toLowerCase()==varAttr.option.toLowerCase()||varAttr.option==""));
                                        var selectedMatchVarAttr=(optionSelected.containsKey(varAttr.name)&& (varAttr.option.toLowerCase()== optionSelected[varAttr.name]!.toLowerCase()||varAttr.option==""));
                                        var nonSelectedVarAttr=!optionSelected.containsKey(varAttr.name)&& attr.name.toLowerCase()!= varAttr.name.toLowerCase();
                                        print("");
                                        if(!viewMatchVarAttr&&!selectedMatchVarAttr&& !nonSelectedVarAttr){
                                          attributeFound=false;
                                        }
                                        else
                                          print("");

                                      });
                                      if(attributeFound)
                                        foundOptionInVariant=true;
                                      else
                                        print("");

                                    });

                                  }
                                  else  if ( optionSelected.containsKey(attr.name)) {
                                    var selectedMatchView=(optionSelected.containsKey(attr.name)&& (options.toLowerCase()== optionSelected[attr.name]!.toLowerCase() ));
                                    print("");
                                    if(selectedMatchView){
                                      foundOptionInVariant=true;
                                    }
                                  }
                                  else
                                    foundOptionInVariant = true;

                                  print("");
                                  return foundOptionInVariant ? GestureDetector(
                                    onTap: () {
                                      optionSelected[attr.name] = options;
                                      setState(() {});
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(minWidth: 60),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color: SecondaryHighlighter, width: 1),
                                          color: (optionSelected.containsKey(attr.name) && optionSelected[attr.name] == options)
                                              ?  NormalColor.withAlpha(20)
                                              : transparent
                                      ),
                                      child: Text(
                                        options,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Normal",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: (optionSelected.containsKey(
                                              attr.name) &&
                                              optionSelected[attr.name] ==
                                                  options)
                                              ? MainHighlighter
                                              : NormalColor,
                                        ),
                                      ),
                                    ),
                                  ) : Container();
                                }).toList(),
                              ),
                            )
                        )
                    ),
                  ) : Container();
                }).toList()
                )
                ..add(
                    GestureDetector(
                      onTap: () {
                        optionSelected = Map();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(5),
                        child: Text(
                          LocalLanguageString().clear,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: "Header",
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                      ),
                    )
                )
          )
      ),
    ) : Container();
  }
}
