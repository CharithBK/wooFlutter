import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ecom/WidgetHelper/CustomIcons.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/languages_local.dart';

class AboutusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: body(context)
    );
  }
  Widget body(BuildContext context)
  {
    return Container(
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
                        onTap: (){
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
                      LocalLanguageString().aboutus,
                      style: TextStyle(color: MainHighlighter,
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
            child: aboutUsbody(context),
          )

        ],
      ),
    );
  }

  Widget aboutUsbody(BuildContext context){
    return Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Landing page logo.
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Container(
                    height:  150,
                    child: Image.asset(
                      // Replace with your landing page logo here.
                      "assets/logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Landing page website title.
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 10),
                  child: SelectableText(
                    // Replace with your landing page website title.
                    "Flutter Applipie",
                    style: TextStyle(
                        fontFamily: "Header",
                        color: MainHighlighter,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(height: 1, width: MediaQuery.of(context).size.width * 0.5, color: NormalColor,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.only(top: 8),
                  child: SelectableText(
                    // Replace with your business or personal website description.
                    LocalLanguageString().aboutusshortdesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: NormalColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "#flutter #flutterdev ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: NormalColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    LocalLanguageString().contactus,
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: NormalColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    "--@--.com",
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: NormalColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Supported by Applipie",
                          style: TextStyle(
                              fontFamily: "Normal",
                              color: NormalColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}