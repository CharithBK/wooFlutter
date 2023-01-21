import 'dart:convert';

import 'package:ecom/models/api/customer/customerGetModel.dart';
import 'package:ecom/screens/signInFragments/socialMediaWidget.dart';
import 'package:ecom/sharedWidgets/busyButton.dart';
import 'package:ecom/sharedWidgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ecom/main.dart';
import 'package:ecom/models/api/customer/customerCreateModel.dart';
import 'package:ecom/models/api/customer/cupdateCustomerUpdateModel.dart';
import 'package:ecom/models/api/customer/createCustomerResponceModel.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/consts.dart';
import 'package:ecom/utils/prefrences.dart';
import 'package:ecom/http/woohttprequest.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

import '../http/api_service.dart';
import '../models/api/customer/user_details_model.dart';


class LoginWidget extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserDetails? userDetails;
  APIService apiService = new APIService();
//  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   final emailController = TextEditingController();
  bool? isFreeShipment;
  double? amount;
  String? redirectTo;
  bool isLoading = false;
  dynamic squareAppToken ;
  dynamic payAmount ;
  dynamic currencyType ;
  void _pay(double amount,String currencyCode) async {
    payAmount = amount;
    currencyType = currencyCode;
    await InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-wDh9qCOC6PtHvOXVHc2i9g');
    InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardNonceRequestSuccess,
        onCardEntryCancel: _onCardEntryCancel);
  }
  void _onCardEntryCancel() {}
  void _onCardNonceRequestSuccess(CardDetails result) {
    squareAppToken = result.nonce;
    InAppPayments.completeCardEntry(onCardEntryComplete: _cardEntryComplete);
  }

  void _cardEntryComplete()  {
    WooHttpRequest result = new WooHttpRequest();
    result.paymentSquare(payAmount,currencyType);
    Navigator.pushReplacementNamed(context, "/home");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    amount = map['_amount'];
    isFreeShipment = map['_freeShipment'] ?? false;
    redirectTo = map['_nextToGo'];

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 30),
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
                    Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                    Container(),

                  ],
                ),
              )
          ),
          Expanded(
              flex: 13,
              child: Container(
                  child: ListView(
                    children: [
                      getBody(),
                    ],
                  )
              )
          )

        ],
      ),
    );
  }

  Widget getBody(){
    return Column(
      children: <Widget>[

        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: SocialMediaWidget(socialMediaAuthResponse),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Divider(),
                    SizedBox(height: 25.0),
                    InputField(
                      placeholder: 'Email',
                      controller: emailController,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
                child: InputField(
                  placeholder: 'Password',
                  password: true,
                  controller: passwordController,
                ),
              ),

              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Login',
                      //uncomment this==================
                      // onPressed: () {
                      //   addNewUser(emailController.text, passwordController.text);
                      // },


                      //just test create payment =======================================
                      onPressed: () { _pay(40.00, 'USD');},
                    )
                  ],
                ),
              ),
              isLoading
                  ? JumpingDotsProgressIndicator(fontSize: 30.0,)
                  : Container(),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Login Required .Signup with fb or google for continue to payment process.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Normal",
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: NormalColor,
                  ),
                ),
              ),
              Divider(),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "@Copyright :WooFlux Store.",
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: NormalColor,
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),

      ],
    );
  }


  String? userId;
  String? displayName;
  String? phoneNumber;
  socialMediaAuthResponse(String? displayName, String? email, String? phoneNumber) async {
    this.displayName = displayName;
    this.phoneNumber = phoneNumber;

    String user = await apiService.wooSocialLogin(email ?? "");
       var    userData = jsonDecode(user);
    if(email!=null){
      userId=email;
      prefs!.setInt(USERID, userData['data']!['id']);
      moveToNext();

    }
    else if(phoneNumber!=null) {
      userId = phoneNumber;
    } else{
      userId="not found";
    emailController.text= userId!;}
  }
  addNewUser( String? email, String? password) async {
    CreateCustomer customer = getCustomerDetailsPref();
    if(displayName!=null) {
      customer.billing.first_name = customer.first_name = displayName!.split(" ")[0];
      customer.billing.last_name = customer.last_name = displayName!.split(" ").length > 1 ? displayName!.split(" ")[1] : "";
    }
    customer.billing.email = customer.email = customer.billing.email = email!;

    customer.billing.phone = phoneNumber;
    // customer.username = displayName;
    customer.username = email;

    setState(() {
      isLoading = true;
    });
    if(await verifyUserLogin(email,password))
    {
       setCustomerDetailsPref(customer);
       await addToWoocommerce(customer,password);
    }

    else{
      final snackBar = SnackBar(content: Text("Login failed"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {isLoading = false;});
    }
  }

  Future<bool> verifyUserLogin(String? email, String? password) async {
    String jwtToken = await WooHttpRequest().getToken(email!,password!);
    if (jwtToken != "") {
      return true;
    }
    return false;
  }

  Future<void> addToWoocommerce(CreateCustomer _cCustomer, String? password) async {
    GetCustomer? customer = await WooHttpRequest().getCustomer(_cCustomer.email);
    print("customer==>$customer");
    print("_cCustomer==>$_cCustomer");
    //print("token==>${user}");
    setState(() {isLoading = false;});
    if (customer != null) {
      prefs!.setInt(USERID, customer.id);
      moveToNext();
    }
    else {
      final snackBar = SnackBar(content: Text("Login failed"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  Future<void> _addToWoocommerce(CreateCustomer _cCustomer, String? password) async {
    GetCustomer? customer = await WooHttpRequest().getCustomer(_cCustomer.email);
    if (customer != null) {
      UpdateCustomer updateCustomer = UpdateCustomer.fromJson(_cCustomer.toJson());
      CreateCustomerResponce? createCustomerResponce = await WooHttpRequest().updateNewUser(customer.id, updateCustomer);
      if (createCustomerResponce != null) {
        prefs!.setInt(USERID, createCustomerResponce.id);
        moveToNext();
      }
      print(createCustomerResponce);
    } else {
      CreateCustomer createCustomer = CreateCustomer.fromJson(_cCustomer.toJson());
      CreateCustomerResponce? createCustomerResponce = await WooHttpRequest().addCustomer(createCustomer);
      if (createCustomerResponce != null) {
        prefs!.setInt(USERID, createCustomerResponce.id);
        moveToNext();
      }
    }
  }

  Future<void> moveToNext() async {
    // orders =await WooHttpRequest().getOrders();
    prefs!.setBool(ISLOGIN, true);
    Navigator.pushReplacementNamed(context, redirectTo!, arguments: {'_amount': amount, '_freeShipment': isFreeShipment});
  }

}