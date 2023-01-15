import 'package:ecom/models/api/customer/customerBillingModel.dart';
import 'package:ecom/models/api/shippingZone/getShippingZone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecom/models/api/customer/customerCreateModel.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/languages_local.dart';
import 'package:ecom/utils/prefrences.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:collection/collection.dart';

class ProfileInfo extends StatefulWidget {
  final Function? onTap;
  final List<GetShippingZone>? shippingZones;
  const ProfileInfo({Key? key, this.onTap, this.shippingZones}) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {

  final String REQUIRED="__ *";
  GetShippingZone? selectedShippingZone;

  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController primaryAddressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController postalcodeController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  void initState() { 
    super.initState();

    Billing billing=getCustomerDetailsPref().billing;
    firstnameController.text=billing.first_name!;
    lastController.text=billing.last_name!;
    emailController.text=billing.email!;
    companyController.text=billing.company!;
    primaryAddressController.text=billing.address_1!;
    cityController.text=billing.city!;
    // countrySelected=billing.country;
    stateController.text=billing.state!;
    postalcodeController.text=billing.postcode!;
    phoneController.text=billing.phone!;
  }

  @override
  Widget build(BuildContext context) {
    selectedShippingZone = selectedShippingZone != null ? selectedShippingZone :
    (widget.shippingZones != null && widget.shippingZones!.length > 0) ? widget.shippingZones!.first : null;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 25, right: 25, top: 30),
          child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocalLanguageString().firstname,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: "Header",
                          fontSize: 16,
                          color: MainHighlighter,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(isDense: true),
                        controller: firstnameController,
                        style: TextStyle(
                          fontFamily: "Header",
                          color: NormalColor,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalLanguageString().lastname,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(isDense: true),
                          controller: lastController,
                          style: TextStyle(
                            fontFamily: "Header",
                            color: NormalColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalLanguageString().email,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(isDense: true),
                          controller: emailController,
                          style: TextStyle(
                            fontFamily: "Header",
                            color: NormalColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalLanguageString().company,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(isDense: true),
                          controller: companyController,
                          style: TextStyle(
                            fontFamily: "Header",
                            color: NormalColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalLanguageString().address,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(isDense: true),
                          controller: primaryAddressController,
                          style: TextStyle(
                            fontFamily: "Header",
                            color: NormalColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalLanguageString().city,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(isDense: true),
                          controller: cityController,
                          style: TextStyle(
                            fontFamily: "Header",
                            color: NormalColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalLanguageString().state,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(isDense: true),
                          controller: stateController,
                          style: TextStyle(
                            fontFamily: "Header",
                            color: NormalColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalLanguageString().postalcode,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(isDense: true),
                          controller: postalcodeController,
                          style: TextStyle(
                            fontFamily: "Header",
                            color: NormalColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalLanguageString().phone,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontSize: 16,
                            color: MainHighlighter,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(isDense: true),
                          controller: phoneController,
                          style: TextStyle(
                            fontFamily: "Header",
                            color: NormalColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Shipping Zones",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: "Header",
                      fontSize: 16,
                      color: MainHighlighter,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  color: Colors.transparent,
                    child: (widget.shippingZones != null && widget.shippingZones!.length > 0) ? DropdownButtonHideUnderline(
                      child: DropdownButton<GetShippingZone>(
                        isExpanded: true,
                        value: widget.shippingZones!.firstWhereOrNull((element) => element.id == selectedShippingZone!.id),
                        onChanged: (GetShippingZone? newValue) {
                          setState(() {
                            selectedShippingZone = newValue;
                          });
                        },
                        items: widget.shippingZones!.map((GetShippingZone item) {
                          return DropdownMenuItem<GetShippingZone>(
                            value: item,
                            child: Text(item.name),
                          );
                        }).toList(),
                      ),
                    ) : Container(child: JumpingDotsProgressIndicator(fontSize: 30.0,)),

                ),

              ]),
        ),
        SaveButton(),
      ],
    );
  }

  SaveButton( ) {
    return GestureDetector(
      onTap: () {
        CreateCustomer customer = getCustomerDetailsPref();
        customer.shipping.first_name = customer.billing.first_name = customer.first_name = firstnameController.text;
        customer.shipping.last_name = customer.billing.last_name = customer.last_name = lastController.text;
        customer.shipping.company = customer.billing.company = companyController.text;
        customer.shipping.address_2 = customer.shipping.address_1 = customer.billing.address_1 = primaryAddressController.text;
        customer.shipping.city = customer.billing.city = cityController.text;
        customer.shipping.state = customer.billing.state = stateController.text;
        customer.shipping.postcode = customer.billing.postcode = postalcodeController.text;
        customer.shipping.country = customer.billing.country = "";
        customer.billing.email = customer.email = emailController.text;
        customer.billing.phone = phoneController.text;
        setCustomerDetailsPref(customer);
        widget.onTap!(selectedShippingZone);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        color: MainHighlighter,
        child: Text(
          LocalLanguageString().save,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "Normal",
              color: BackgroundColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }
  // String countrySelected;
  // void _openCountryPicker() => showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CountryPickerCupertino(
  //         pickerSheetHeight: 300.0,
  //         onValuePicked: (Country country) => setState(() => countrySelected = country.name),
  //       );
  //     });
}