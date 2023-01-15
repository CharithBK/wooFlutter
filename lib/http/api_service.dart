import 'package:http/http.dart' as http;
class APIService {
  static var client = http.Client();
  Future<dynamic> wooSocialLogin(String userName) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    //add your WOOCOMM_URL with https
    var url = new Uri.http("192.168.1.12:8080","/wordpress/wp-json/jwt-auth/v1/token");
    var response = await client.post(url,headers: requestHeaders,body: {"username": userName, "social_login": "true"});
    if (response.statusCode == 200){
      print('response.body==>${response.body}');
      return response.body;
    }
    else {
      return false;
    }
  }
}