import 'dart:io';
import 'dart:math';
import 'package:ecom/http/api_service.dart';
import 'package:ecom/models/api/customer/user_details_model.dart';
import 'package:flutter/material.dart';import 'dart:convert';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/widgets.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

class SocialMediaWidget extends StatefulWidget {
  Function callBack;
  SocialMediaWidget(this.callBack);

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SocialMediaWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserDetails? userDetails;
  APIService apiService = new APIService();
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  _checkIfisLoggedIn() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    setState(() {
      _checking = false;
    });

    if (accessToken != null) {
      print(accessToken.toJson());
      final userData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    } else {
      _login();
    }
  }
  _login() async {
    final LoginResult result = await FacebookAuth.instance.login();
    print('accessToken==============>${result}');
    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
      print('_userData===>$_userData');
    } else {
      print(result.status);
      print(result.message);
    }
    setState(() {
      _checking = false;
    });
  }

  _logout() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 5,),
        FlutterSocialButton(
          // mini: true,
          onTap: () {
            initiateGoogleLogin();
          },
          buttonType: ButtonType.google, // Button type for different type buttons
        ),
        SizedBox(width: 5,),
        FlutterSocialButton(
          // mini: true,
          onTap: () {
            initiateFacebookLogin();
          },
          buttonType: ButtonType.facebook, // Button type for different type buttons
        ),
        SizedBox(width: 5,),
        Platform.isAndroid ? Container() :FlutterSocialButton(
          // mini: true,
          onTap: () {
            signInWithApple();
          },
          buttonType: ButtonType.apple, // Button type for different type buttons
        ),
      ],
    );
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //
        //     Container(
        //         margin: EdgeInsets.all(5),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(5),
        //           color: NormalColor,
        //         ),
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             // Image.asset(
        //             //   'assets/google.png',
        //             //   width: 30,
        //             //   height: 30,
        //             // ),
        //             SizedBox(
        //               width: MediaQuery.of(context).size.width * 0.7,
        //               child: TextField(
        //                 textAlign: TextAlign.center,
        //                 decoration: InputDecoration(
        //                     border: OutlineInputBorder(
        //                       borderRadius: BorderRadius.circular(10.0),
        //                     ),
        //                     filled: true,
        //                     hintStyle: TextStyle(
        //                       fontFamily: "Normal",
        //                       fontWeight: FontWeight.w600,
        //                       fontSize: 20,
        //                       color: BackgroundColor,
        //                     ),
        //                     hintText: "Sign in with email",
        //                     fillColor: Colors.black87),
        //               ),
        //             )
        //           ],
        //         )
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         initiateGoogleLogin();
        //       },
        //       child: Container(
        //           margin: EdgeInsets.all(5),
        //           padding: EdgeInsets.all(10),
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(5),
        //             color: NormalColor,
        //           ),
        //           width: MediaQuery.of(context).size.width * 0.8,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               // Image.asset(
        //               //   'assets/google.png',
        //               //   width: 30,
        //               //   height: 30,
        //               // ),
        //               Text(
        //                 'Sign in with Google',
        //                 style: TextStyle(
        //                   fontFamily: "Normal",
        //                   fontWeight: FontWeight.w600,
        //                   fontSize: 20,
        //                   color: BackgroundColor,
        //                 ),
        //               ),
        //
        //             ],
        //           )
        //       ),
        //     ),
        //     SizedBox(height: 5,),
        //     GestureDetector(
        //       onTap: () {
        //         initiateFacebookLogin();
        //       },
        //       child: Container(
        //           margin: EdgeInsets.all(5),
        //           padding: EdgeInsets.all(10),
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(5),
        //             color: NormalColor,
        //           ),
        //           width: MediaQuery.of(context).size.width * 0.8,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               // Image.asset(
        //               //   'assets/fb.png',
        //               //   width: 30,
        //               //   height: 30,
        //               // ),
        //               Text(
        //                 'Sign in with FaceBook',
        //                 style: TextStyle(
        //                   fontFamily: "Normal",
        //                   fontWeight: FontWeight.w600,
        //                   fontSize: 20,
        //                   color: BackgroundColor,
        //                 ),
        //               ),
        //
        //             ],
        //           )
        //       ),
        //     ),
        //     SizedBox(height: 5,),
        //     Container(width: MediaQuery.of(context).size.width * 0.8,
        //       child:
        //       SignInWithAppleButton(
        //         onPressed: () {
        //           signInWithApple();
        //         },
        //         style: isDarkTheme() ? SignInWithAppleButtonStyle.white : SignInWithAppleButtonStyle.black,
        //       ),
        //     ),
        //     Divider(),
        //
        //   ],
        // )

  }

  //-------------------Login With Social Media------ -----------//
  void initiateFacebookLogin() async {
   // _checkIfisLoggedIn();
    _accessToken = (await FacebookAuth.instance.accessToken);
    print('_accessToken====>$_accessToken');
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );
    if(result.status == LoginStatus.success) {
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture",
      );
      this.userDetails = new UserDetails(
        displayName: requestData["name"],
        email: requestData["email"],
        photoUrl: requestData["picture"]["data"]["url"] ?? "",
      );

      print('result====>${requestData["name"]}');
      print('result====>${requestData["email"]}');
     var fbData =  await apiService.wooSocialLogin(this.userDetails!.email ?? "");
    }
    // Trigger the sign-in flow
    // final LoginResult result = await FacebookAuth.instance.login();
    //final FacebookAuth auth = await FacebookAuth.instance;
    //LoginResult result = await auth.expressLogin();
    final accessToken = await FacebookAuth.instance.accessToken;
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);

    // Once signed in, return the UserCredential
    //UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    //widget.callBack(userCredential.user!.displayName, userCredential.user!.email, userCredential.user!.phoneNumber);
    //return userCredential;
  }


  initiateGoogleLogin() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();


    if (googleUser != null) {

      //wooSocialLogin======>start
      this.userDetails = new UserDetails(
        displayName: googleUser?.displayName,
        email: googleUser?.email,
        photoUrl: googleUser?.photoUrl,
      );
      await apiService.wooSocialLogin(this.userDetails!.email ?? "");
      //UserCredential userCredential = (await apiService.wooSocialLogin(this.userDetails!.email ?? "")) as UserCredential;
      //wooSocialLogin======>end

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Create a lib credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      widget.callBack(userCredential.user!.displayName, userCredential.user!.email, userCredential.user!.phoneNumber);

      return userCredential;
    }
  }

  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print("apple_appleCredential " + appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken!,
        rawNonce: rawNonce,
      );
      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      print("apple_authResult " + authResult.additionalUserInfo.toString());

      final firebaseUser = authResult.user;
      widget.callBack(firebaseUser!.displayName, firebaseUser.email, firebaseUser.phoneNumber);
    } catch (exception) {
      print(exception);
    }
  }
}
