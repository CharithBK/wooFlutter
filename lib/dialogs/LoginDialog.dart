import 'package:flutter/material.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/utils/prefrences.dart';

class LoginDialog extends StatefulWidget {
  Function refresh;
  LoginDialog(this.refresh);
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(),
            ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Column(
                  children: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        // _dialogService.dialogComplete(DialogResponse(confirmed: false, fieldOne: '', fieldTwo: ''));
                      },
                    ),
                    TextButton(
                      child: Text("Button title"),
                      onPressed: () {
                        // _dialogService.dialogComplete(DialogResponse(confirmed: true, fieldOne: '', fieldTwo: ''));
                      },
                    ),
                  ],
                )
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}