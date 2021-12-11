import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://127.0.0.1:8000/api';

  //final String _url = 'http://wfm.mypropelsoft.com/api';
  var token;
  var alldata;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  GetActiveOrg() async {
    var fullUrl = _url + "/getActiveOrg";
    await _getToken();
    var response = await http.get(fullUrl, headers: _setHeaders());
    var body = json.decode(response.body);

    if (body['data'] != null) {
      var res = body['data']['organization_id'];
      return int.parse(res);
    } else {
      return 0;
    }
  }

  postMethodWithToken(data, apiUrl) async {
    await _getToken();
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  postMethodWithOutToken(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getMethodWithToken(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  getMethodWithOutToken(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl, headers: _setHeaders());
  }
}
