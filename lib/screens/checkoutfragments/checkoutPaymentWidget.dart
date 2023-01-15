
import 'package:ecom/bloc/bloc_paymentGateway.dart';
import 'package:ecom/models/api/paymentMethod/getPaymentMethods.dart';
import 'package:ecom/models/checkoutSteps.dart';
import 'package:flutter/material.dart';
import 'package:ecom/payments/paypal.dart';
import 'package:ecom/payments/tap.dart';
import 'package:ecom/screens/splashWidget.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/languages_local.dart';
import 'package:ecom/http/woohttprequest.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';


class CheckOutPaymentScreen extends StatefulWidget {

  double amount;
  CheckOutStep checkOutStep;
  CheckOutPaymentScreen(this.checkOutStep, this.amount);
  @override
  _CheckOutPaymentScreenState createState() => new _CheckOutPaymentScreenState();
}

List<GetPaymentGateway>? paymentGateways;
class _CheckOutPaymentScreenState extends State<CheckOutPaymentScreen>  {

  final String REQUIRED="__ *";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Razorpay _razorpay ;

  Future<void> _pay() async {
    var data = await InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-wDh9qCOC6PtHvOXVHc2i9g');
    InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardNonceRequestSuccess,
        onCardEntryCancel: _onCardEntryCancel);
  }


  void _onCardEntryCancel() {}
  void _onCardNonceRequestSuccess(CardDetails result) {

    InAppPayments.completeCardEntry(onCardEntryComplete: _cardEntryComplete);
  }

  void _cardEntryComplete() {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => WebViewPaypal(tokenpaypal, urls["approval_url"], urls["execute"], widget.checkOutStep.stepTwo!)),
    //     );
    Navigator.pushReplacementNamed(context, "/home");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WooHttpRequest().getPaymentGatways().then((value) {
      paymentGateways =value;
      paymentGatewayBloc.refreshPaymentGateways(paymentGateways!);
    });
    // _razorpay = Razorpay();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: BackgroundColor,
        body: StreamBuilder(
          stream: paymentGatewayBloc.getPaymentGatewayStreamController.stream,
          initialData: paymentGateways,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.data!=null?_buildBody(context):
            Center(child: JumpingDotsProgressIndicator(fontSize: 40.0, ));
          },
        )
    );
  }

  Widget _buildBody(BuildContext context) {

    bool tap=false;
    bool paypal=false;
    bool razorpay=false;
    bool cod=false;
    bool cheque=false;
    bool bacs=false;

    paymentGateways!.forEach((element) {
      if(element.id=="tap"&&element.enabled){
        tap=true;
      }
      else if(element.id=="paypal"&&element.enabled){
        paypal=true;
      }
      else if(element.id=="razorpay"&&element.enabled){
        razorpay=true;
      }
      else if(element.id=="cod"&&element.enabled){
        cod=true;
      }
      else if(element.id=="cheque"&&element.enabled){
        cheque=true;
      }
      else if(element.id=="bacs"&&element.enabled){
        bacs=true;
      }
    });


    ProgressDialog pr = ProgressDialog(context: context);
    // pr.style(
    //     message: LocalLanguageString().processingorderrequest+'...',
    //     borderRadius: 10.0,
    //     backgroundColor: BackgroundColor,
    //     progressWidget: CircularProgressIndicator(),
    //     elevation: 10.0,
    //     insetAnimCurve: Curves.easeInOut,
    //     progress: 0.0,
    //     maxProgress: 100.0,
    //     progressTextStyle: TextStyle(color: NormalColor, fontSize: 13.0, fontWeight: FontWeight.w400),
    //     messageTextStyle: TextStyle(color: NormalColor, fontSize: 19.0, fontWeight: FontWeight.w600)
    // );

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(

            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 30,top: 60),
            child:  Text(
              LocalLanguageString().paymentdescription,
              textAlign:TextAlign.center,
              style: TextStyle(
                fontFamily: "Normal",
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: NormalColor,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                LocalLanguageString().total,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: NormalColor,
                ),
              ),
              Text(
                "${widget.amount+widget.checkOutStep.stepTwo!.shippmentCost} ${currencyCode==null?"":currencyCode}",
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: NormalColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          tap? Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              // color: MainHighlighter,
              onPressed: () async {
                pr.show(max: 100, msg: LocalLanguageString().processingorderrequest+'...',);
                String? url=await WooHttpRequest().getTapUrl(widget.amount,widget.checkOutStep.stepTwo!.shippmentCost,currencyCode);
                pr.close();
                if(url!=null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewTap(url, widget.checkOutStep.stepTwo!)
                    ),
                  );
                }
              },
              child: Text(
                "pay via Tap",
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: BackgroundColor,
                ),
              ),
            ),
          ):Container(),
          paypal?Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              // color: MainHighlighter,
              onPressed: () async {
                pr.show(max: 100, msg: LocalLanguageString().processingorderrequest+'...',);

                // String? tokenpaypal =await WooHttpRequest().getAuthPaypal();
                // if(tokenpaypal!=null) {
                //   Map? urls = await WooHttpRequest().paymentPaypal(tokenpaypal, widget.amount, widget.checkOutStep.stepTwo!.shippmentCost, currencyCode);
                //   pr.close();
                //   if (urls != null)
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => WebViewPaypal(tokenpaypal, urls["approval_url"], urls["execute"], widget.checkOutStep.stepTwo!)),
                //     );
                // }

                _pay();
              },
              child: Text(
                "Pay via Square",
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: BackgroundColor,
                ),
              ),
            ),
          ):Container(),
          cod?Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              // color: MainHighlighter,
              onPressed: () async {
                pr.show(max: 100, msg: LocalLanguageString().processingorderrequest+'...',);

                Map<String,String> shippmentLineDetail= {
                  "method_id":widget.checkOutStep.stepTwo!.id.toString(),
                  "method_title":widget.checkOutStep.stepTwo!.title,
                  "total":widget.checkOutStep.stepTwo!.shippmentCost.toString(),
                };
                WooHttpRequest().putNewOrder(context,"cod","Cash on delivery",shippmentLineDetail).then((value) {
                  pr.close();
                  Navigator.pushReplacementNamed(context, "/home");
                });

              },
              child: Text(
                "Cash on delivery",
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: BackgroundColor,
                ),
              ),
            ),
          ):Container(),
//          razorpay?Container(
//            padding: EdgeInsets.all(10),
//            width: double.infinity,
//            child: RaisedButton(
//              color: MainHighlighter,
//              onPressed: () async {
//                _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
//                  WooHttpRequest().putNewOrder("razorpay","Razorpay").then((value) {
//                    Navigator.pushReplacementNamed(context, "/home");
//                  });
//                });
//                _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
//                  print("");
//                });
//                var config=getRazorPayConfig(widget.amount,shippingCost,currencyCode);
//                _razorpay.open(config);
//              },
//              child: Text(
//                "Pay via RazorPay",
//                style: TextStyle(
//                  fontFamily: "Normal",
//                  fontWeight: FontWeight.w600,
//                  fontSize: 20,
//                  color: BackgroundColor,
//                ),
//              ),
//            ),
//          ):Container()
        ],
      ),
    );
  }

}