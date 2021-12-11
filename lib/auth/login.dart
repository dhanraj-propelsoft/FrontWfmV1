import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:propel/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:propel/auth/Person/Person.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:propel/auth/ForgotPassword/forgot_password.dart';
import 'package:propel/auth/Person/distnict_data.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneNo = new TextEditingController();
  bool phoneVal = false;
  bool invalidphone = false;
  bool isButtonEnabled = false;
  BottomLoader bl;
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  @override
  void _mobile_no_check(mobile_no) async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();

    var res =
        await Network().getMethodWithOutToken('/getPersonByMobileNo/$mobile_no');
    var body = json.decode(res.body);

    if (body['message'] == "SUCCESS") {
      if (body['data']['pId'] != '') {
        if (body['data']['pHavingUser']) {
          var Name = body['data']['pFirstName'] + body['data']['pMiddleName'];
          bl.close();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPageTwo(
                      mobileno: mobile_no,
                      name: Name,
                      user_id: body['data']['pPersonUserDetails']['id'],
                      user_credentials: true,
                      email: body['data']['pPersonEmailDetails']['email'])));
        } else {
          bl.close();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmailVerfication(
                      mobileno: mobile_no, user_credentials: true)));
        }
      } else {
        bl.close();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmailVerfication(
                    mobileno: mobile_no, user_credentials: false)));
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 25, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Ado unbox",
              style: TextStyle(
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                  fontSize: 60.0),
            ),
            Text(
              "Version:beta",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 70.0,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged:(val){

                      if (val.trim().isEmpty || val.length != 10){
                        setState(() {
                          isButtonEnabled = false;
                        });
                      }else{
                        setState(() {
                          isButtonEnabled = true;
                        });
                      }

                    },
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                      hintText: "Enter your Mobile Number ",
                      labelText: "Mobile No",
                      prefixIcon: const Icon(
                        Icons.phone_android,
                        color: Colors.blue,
                      ),
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    controller: phoneNo,
                  ),
                  // InternationalPhoneNumberInput(
                  //   onInputChanged: (PhoneNumber number) {
                  //     if (number.phoneNumber.trim().isEmpty ||
                  //         number.phoneNumber.length != 13) {
                  //       setState(() {
                  //         isButtonEnabled = false;
                  //       });
                  //     } else {
                  //       setState(() {
                  //         isButtonEnabled = true;
                  //       });
                  //     }
                  //   },
                  //   onInputValidated: (bool value) {
                  //
                  //   },
                  //   selectorConfig: SelectorConfig(
                  //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  //   ),
                  //   ignoreBlank: false,
                  //   autoValidateMode: AutovalidateMode.disabled,
                  //   selectorTextStyle: TextStyle(color: Colors.black),
                  //   initialValue: number,
                  //   textFieldController: phoneNo,
                  //   formatInput: false,
                  //   keyboardType: TextInputType.numberWithOptions(
                  //       signed: true, decimal: true),
                  //   inputBorder: OutlineInputBorder(),
                  //   onSaved: (PhoneNumber number) {
                  //     print('On Saved: $number');
                  //   },
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: isButtonEnabled
                  ? () {
                      _mobile_no_check(phoneNo.text);
                    }
                  : null,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Don’t have a Login yet, Enter your Mobile Number and click Next to  Signup for a New Account",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginPageTwo extends StatefulWidget {
  final String name;
  final String mobileno;
  final int user_id;
  final bool user_credentials;
  final String email;
  const LoginPageTwo(
      {Key key,
      this.mobileno,
      this.name,
      this.user_id,
      this.user_credentials,
      this.email})
      : super(key: key);
  @override
  _LoginPageTwoState createState() => _LoginPageTwoState();
}

class _LoginPageTwoState extends State<LoginPageTwo> {
  final password = new TextEditingController();
  bool pwdVal = false;
  bool isButtonEnabled = false;
  bool _pwdDotSymbol = true;
  bool _isLoading = false;
  BottomLoader bl;

  void _login() async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();

    var data = {'mobile': widget.mobileno, 'password': password.text};

    var res = await Network().postMethodWithOutToken(data, '/wfmlogin');
    var body = json.decode(res.body);

    if (body['status'] == 1) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('personData', json.encode(body['PersonDetail']));
      localStorage.setInt('active_org', body['active_org']);
      bl.close();
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      bl.close();
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => WrongPassword(
                name: widget.name,
                mobileno: widget.mobileno,
                userid: widget.user_id,
                email: widget.email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var user_name = widget.name;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Ado unbox",
                  style: TextStyle(
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                      fontSize: 60.0),
                ),
                Text(
                  "Version:beta",
                  style: TextStyle(color: Colors.grey),
                ),

                SizedBox(
                  height: 70.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hi! $user_name",
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.right,
                  ),
                ),
                TextField(
                  onChanged: (val) {
                    if (val.trim().isEmpty) {
                      setState(() {
                        isButtonEnabled = false;
                      });
                    } else {
                      setState(() {
                        isButtonEnabled = true;
                      });
                    }
                  },
                  obscureText: _pwdDotSymbol,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: "Enter Password",
                    prefixIcon: const Icon(
                      Icons.security,
                      color: Colors.blue,
                    ),
                    suffixIcon: isButtonEnabled
                        ? IconButton(
                            icon: Icon(_pwdDotSymbol
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _pwdDotSymbol = !_pwdDotSymbol;
                              });
                            })
                        : null,
                  ),
                  controller: password,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Icon(Icons.login_outlined,color: Colors.white),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: isButtonEnabled
                      ? () {
                          _login();
                        }
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {},
                  child: Center(
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  30.0) //                 <--- border radius here
                              ),
                        ),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => distnictOTP(
                                          mobileno: widget.mobileno,
                                          email: widget.email)));
                            },
                            child: Text(
                              "I’m not $user_name, I don’t have a password yet Signup for a New Account",
                              style: TextStyle(color: Colors.orange),
                            ))),
                  ),
                ),

                // InkWell(child:  Align(
                //   alignment: Alignment.centerRight,
                //   child: Text("forgot password?",style: TextStyle(color: Colors.blue),),),
                //   onTap: (){
                //       forgot_password(widget.user_id,widget.mobileno);
                //   },
                // ),
                SizedBox(
                  height: 20,
                ),
                // RichText(
                //   text: TextSpan(
                //     text: "I'm not $user_name, I don't have a passoword yet'\n",
                //     style: TextStyle(
                //       color: Colors.grey,),
                //     children: <TextSpan>[
                //       TextSpan(
                //           text: 'Sign up for a New Account',
                //           style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue)),
                //     ],
                //   ),
                // ),

                // Text("I'm not $user_name, I don't have a passoword yet"),
                // InkWell(child: Center(child: Text("Sign up for a New Account",style: TextStyle(color: Colors.blue),),),
                //   onTap: (){
                //
                // },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
