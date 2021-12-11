import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:propel/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:propel/network_utils/api.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:propel/auth/Person/distnict_data.dart';


class EmailVerfication extends StatefulWidget {
  final String mobileno;
  final bool user_credentials;
  const EmailVerfication({Key key,this.mobileno,this.user_credentials}) : super(key: key);
  @override
  _EmailVerficationState createState() => _EmailVerficationState();
}

class _EmailVerficationState extends State<EmailVerfication> {

  final email = new TextEditingController();
  String Mobile_hashed;
  bool emailVal = false;
  bool invalidphone = false;
  bool isButtonEnabled = false;
  BottomLoader bl;


  static getPayCardStr(String code) {
    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  void PartialData() async{

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();

    var data = {
      'mobileNo' : widget.mobileno,
      'email' : email.text
    };
    var res = await Network().postMethodWithOutToken(data, '/get_persondetails');
    var body = json.decode(res.body);


    if(widget.user_credentials){

      if(body['status'] == 1){

        bl.close();
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => loginCredtionalMsg(
                    personId:body['data']['id'],
                    mobileno:widget.mobileno,
                    user_credtional:widget.user_credentials,
                    email:email.text
                )));
      }else if(body['status'] == 2){
        bl.close();
        Fluttertoast.showToast(
            msg: "MobileNo and Email does not matched any persons",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black
        );

      }else{

        bl.close();
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => distnictOTP(
                    mobileno:widget.mobileno,
                    email:email.text
                )));

      }

    }else{
      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => loginCredtionalMsg(
                  personId:0,
                  mobileno:widget.mobileno,
                  user_credtional:widget.user_credentials,
                  email:email.text
              )));
    }



  }

  static emailmask(String code) {

    final String first_part = code.split("@")[0];

    final String hashed_text = "xxxx";

    final String remove_string = first_part.substring(0, first_part.length - 4);

    return remove_string+hashed_text+code.split("@")[1];
    // final int length = code.length;
    // final int replaceLength = length - 2;
    // final String replacement = List<String>.generate((length / 4).ceil(), (int _) => 'xxxx').join('');
    //
    // return code.replaceRange(0, replaceLength, replacement);
  }
  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    var email = emailmask("diwaharsrd@gmail.com");
    print(widget.user_credentials);
    // const String email = 'ka';
    // final bool isValid = EmailValidator.validate(email);
    //
    // print('Email is valid? ' + (isValid ? 'yes' : 'no'));

    setState(() {
      Mobile_hashed = number;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(left:25,right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text("No credentials are found, with your mobile number $Mobile_hashed, Kindly provide email for cross verification"),
              ),
              TextField(
                onChanged:(val){

                  if (val.trim().isEmpty){
                    setState(() {
                      isButtonEnabled = false;
                    });
                  }else{
                    setState(() {
                      isButtonEnabled = true;
                    });
                  }

                },
                obscureText: false,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  hintText: "Enter your Personal Email Only",
                  labelText: "Email",
                  // errorText: isemailValid ? "Invalid Email address":"a",
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                controller: email,
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Icon(Icons.direc,color: Colors.white),
                    Text('Next',style: TextStyle(color: Colors.white,),),
                  ],
                ),
                onPressed:  isButtonEnabled?() {
                  PartialData();
                }:null,
              ),
            ],
          ),
        )
    );
  }
}

class AccountCreateOTP extends StatefulWidget {

  final String mobileno;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final int gender;
  final String Dob;
  final int bloodgroup;


  const AccountCreateOTP({Key key,this.mobileno,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.Dob,this.bloodgroup,this.gender}) : super(key: key);
  @override
  _AccountCreateOTPState createState() => _AccountCreateOTPState();
}

class _AccountCreateOTPState extends State<AccountCreateOTP> {
  final otp = new TextEditingController();
  String Mobile_hashed;
  bool otp_validate = false;
  BottomLoader bl;


  static getPayCardStr(String code) {
    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    setState(() {
      Mobile_hashed = number;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged:(val){

                if (val.trim().isEmpty || val.length != 4){
                  setState(() {
                    otp_validate = false;
                  });
                }else{
                  setState(() {
                    otp_validate = true;
                  });
                }

              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // labelText: 'Password',
                hintText: "OTP Received on your Mobile $Mobile_hashed",
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),


              ),
              controller: otp,
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Validate',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: otp_validate?(){

                // OTP_Validate(otp.text,widget.userid);
              }:null,
            ),

          ],
        ),
      ),
    );
  }
  void OTP_Validate (OTP,user_id)async{
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var data = {
      'userId' : user_id,
      'otp' : OTP
    };
    var res = await Network().postMethodWithOutToken(data, '/OTPVerification');
    var body = json.decode(res.body);

    // if(body['message'] == "SUCCESS") {
    //   bl.close();
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) => Forgot_Password(userid: user_id)
    //     ),
    //   );
    //
    // }else{
    //   bl.close();
    //   Fluttertoast.showToast(
    //       msg: "OTP is Invalid",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       // timeInSecForIos: 1,
    //       backgroundColor: Colors.grey,
    //       textColor: Colors.black
    //   );
    // }
  }
}

class loginCredtionalMsg extends StatefulWidget {
  final String mobileno;
  final String email;
  final bool user_credtional;
  final int personId;
  const loginCredtionalMsg({Key key,this.mobileno,this.user_credtional,this.email,this.personId}) : super(key: key);
  @override
  _loginCredtionalMsgState createState() => _loginCredtionalMsgState();
}

class _loginCredtionalMsgState extends State<loginCredtionalMsg> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.user_credtional?Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orangeAccent,fontSize: 50.0,fontStyle: FontStyle.italic),),
            SizedBox(height: 50.0,),
            Align(alignment: Alignment.centerLeft,
                child: Text("No user information was found on Our System,")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("to continue further kindly signup for a new account by fill the following details.")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Its our Pleasure to have you as user")),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Continue',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: (){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountVerfied(
                            personId:widget.personId,
                            mobileno:widget.mobileno,
                            email:widget.email
                        )));
              },
            ),

          ],
        ),
      ):Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orangeAccent,fontSize: 50.0,fontStyle: FontStyle.italic),),
            SizedBox(height: 50.0,),
            Align(alignment: Alignment.centerLeft,
                child: Text("No user login information was found,")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("kindly fill the missing details and signup for a new account.")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Its our Pleasure to have you as user")),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Continue',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: (){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountVerfied(
                            personId:widget.personId,
                            mobileno:widget.mobileno,
                            email:widget.email
                        )));
              },
            ),

          ],
        ),
      ),
    );
  }
}

class AccountConformationMsg extends StatefulWidget {
  final String mobileno;
  final String email;
  const AccountConformationMsg({Key key,this.mobileno,this.email}) : super(key: key);
  @override
  _AccountConformationMsgState createState() => _AccountConformationMsgState();
}

class _AccountConformationMsgState extends State<AccountConformationMsg> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orangeAccent,fontSize: 50.0,fontStyle: FontStyle.italic),),
            SizedBox(height: 50.0,),
            Align(alignment: Alignment.centerLeft,
                child: Text("No user login information was found,")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("kindly fill the missing details and signup for a new account.")),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Its our Pleasure to have you as user")),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Continue',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: (){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => AccountVerfied(
                            mobileno:widget.mobileno,
                            email:widget.email
                        )));
              },
            ),

          ],
        ),
      ),
    );
  }
}

class AccountVerfied extends StatefulWidget {
  final String mobileno;
  final String email;
  final int personId;
  const AccountVerfied({Key key,this.mobileno,this.email,this.personId}) : super(key: key);
  @override
  _AccountVerfiedState createState() => _AccountVerfiedState();
}

class _AccountVerfiedState extends State<AccountVerfied> {
  final mobileno = new TextEditingController();
  final email = new TextEditingController();
  bool selectradio = false;
  int msg;
  BottomLoader bl;

  void Account_conform() async{

    if(msg == 1) {
      bl = new BottomLoader(
        context,
        showLogs: true,
        isDismissible: true,
      );
      bl.style(
        message: 'Please wait...',
      );
      bl.display();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  NewAccountCreate1(
                    personId:widget.personId,
                      mobileno: widget.mobileno,
                      email: widget.email
                  )));
    }else{
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  Inconvenience(
                  )));
    }

  }
  @override
  void initState() {
    super.initState();
    setState(() {
      mobileno.text = widget.mobileno;
      email.text = widget.email;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text("Create a Account",style: TextStyle(color: Colors.grey),),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.grey,),onPressed: (){
            Navigator.of(context).pop();
          },
            ),
        ),
        body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TextField(
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     labelText: 'My Mobile No',
            //     // hintText: "OTP Received on your Mobile $Mobile_hashed",
            //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
            //   ),
            //   controller: mobileno,
            // ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'My MobileNo',
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(widget.mobileno),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'My Email',
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(widget.email),
                ],
              ),
            ),
            // TextField(
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     labelText: 'My email',
            //     // hintText: "OTP Received on your Mobile $Mobile_hashed",
            //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
            //   ),
            //   controller: email,
            // ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text('The above details are my personal mobile number and email'),
                leading: Radio(
                  value: 1,
                  groupValue: msg,
                  onChanged: (int value) {

                    setState(() {
                      msg = value;
                      selectradio = true;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text('The above details are  not mine, I use one or both the information of  my family member or it’s a official, which I may hand over on my exit'),
                leading: Radio(
                  value: 2,
                  groupValue: msg,
                  onChanged: (int value) {
                    setState(() {
                      msg = value;
                      selectradio = true;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Next',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: selectradio ?(){

                Account_conform();
                // if(msg == 1) {
                //   Navigator.push(context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               NewAccountCreate1(
                //                   mobileno: widget.mobileno,
                //                   email: widget.email
                //               )));
                // }else{
                //   Navigator.push(context,
                //       MaterialPageRoute(
                //           builder: (context) =>
                //               Inconvenience(
                //               )));
                // }
              }: null,
            ),

          ],
        ),
      ),
    );
  }
}

class NewAccountCreate1 extends StatefulWidget {
  final String mobileno;
  final String email;
  final int personId;
  NewAccountCreate1({ Key key,this.mobileno,this.email,this.personId}): super(key: key);
  @override
  _NewAccountCreate1State createState() => _NewAccountCreate1State();
}

class _NewAccountCreate1State extends State<NewAccountCreate1> {

  List SalutionList;
  final FirstName = new TextEditingController();
  final MiddleName = new TextEditingController();
  final LastName = new TextEditingController();
  final Alias = new TextEditingController();
  int SalutionId;
  bool isButtonEnabled = false;
  bool _isLoading = false;


  void get_data(personid) async {

    setState(() {
      _isLoading = true;
    });
    var res = await Network().getMethodWithOutToken('/finddataByPersonId/$personid');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      var result = body['data'];

      setState(() {


        SalutionList = result['pSalutionList'];

        if(result['pSalutionId'] != ""){
          SalutionId = int.parse(result['pSalutionId']);
        }


        FirstName.text = result['pFirstName'];

        if(FirstName.text != ""){
          isButtonEnabled = true;
        }
        MiddleName.text = result['pMiddleName'];
        LastName.text = result['pLastName'];
        Alias.text = result['pAlias'];
        _isLoading = false;
      });
      return result;
    }
  }

  @override
  void initState() {
    super.initState();
    get_data(widget.personId);

  }
  @override

  Widget build(BuildContext context) {
    if(_isLoading){
      return Scaffold(
        body: Container(
          child: Center(
            child: AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader3,
              color: Colors.orangeAccent,
            ),
          ),
        ),
      );
    }else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text(
            "Create a Account", style: TextStyle(color: Colors.grey),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey,), onPressed: () {
            Navigator.of(context).pop();
          },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Salution',
                          style: TextStyle(),
                        ),
                        DropdownButton(
                          hint: Text('Select Salution'),
                          items: SalutionList?.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['name']),
                              value: item['id'],
                            );
                          })?.toList() ?? [],
                          value: SalutionId,
                          onChanged: (value) {
                            setState(() {
                              SalutionId = value;
                            });
                          },
                        ),
                      ],
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
                    obscureText: false,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                      hintText: "Enter your First Name",
                      labelText: "First Name*",
                      labelStyle: TextStyle(color: Colors.red)
                      // errorText: phoneVal ? "Mobile Number is required":null,
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    controller: FirstName,
                  ),
                  TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                      hintText: "Enter your Middle Name",
                      labelText: "Middle Name",
                      // errorText: phoneVal ? "Mobile Number is required":null,
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    controller: MiddleName,
                  ),
                  TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                      hintText: "Enter your Last Name",
                      labelText: "Last Name",
                      // errorText: phoneVal ? "Mobile Number is required":null,
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    controller: LastName,
                  ),
                  TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                      hintText: "Enter your Nick Name",
                      labelText: "Nick Name or Alias",
                      // errorText: phoneVal ? "Mobile Number is required":null,
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    controller: Alias,
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Icon(Icons.direc,color: Colors.white),
                        Text('Next', style: TextStyle(color: Colors.white,),),
                      ],
                    ),
                    onPressed: isButtonEnabled ? () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewAccountCreate2(
                                    personId:widget.personId,
                                    mobileno: widget.mobileno,
                                    email: widget.email,
                                    salution: SalutionId,
                                    first_name: FirstName.text,
                                    middle_name: MiddleName.text,
                                    alisas: Alias.text,
                                    last_name: LastName.text,
                                  )));
                    } : null,
                  ),
                ],
              ),
            ),
          ),
        ),

      );
    }
  }
}

class NewAccountCreate2 extends StatefulWidget {
  final int personId;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final String mobileno;
  final String email;
  const NewAccountCreate2({Key key,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.mobileno,this.email,this.personId}) : super(key: key);
  @override
  _NewAccountCreate2State createState() => _NewAccountCreate2State();
}

class _NewAccountCreate2State extends State<NewAccountCreate2> {

  List Gender;
  List BloodGroup;
  BottomLoader bl;
  final DOB = new TextEditingController();
  int GenderId;
  int BloodGroupId;
  bool isButtonEnabled = false;
  bool _isLoading = false;


  void get_data(personid) async {
    setState(() {
      _isLoading = true;
    });
    var res = await Network().getMethodWithOutToken('/finddataByPersonId/$personid');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      var result = body['data'];

      setState(() {
        Gender = result['pGenderList'];

        BloodGroup = result['pBloodGroupsList'];

        if(result['pGender'] != ""){
          GenderId = int.parse(result['pGender']);
        }
        if(result['pBloodGroup'] != ""){
          BloodGroupId = int.parse(result['pBloodGroup']);
        }
        DOB.text = result['pDob'];

        _isLoading = false;
      });
      return result;
    }
  }

  void OTP_send() async{
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var data = {
      'pId' : "",
      'first_name' : widget.first_name,
      'pMiddleName':widget.middle_name,
      'pLastName':widget.last_name,
      'pAlias':widget.alisas,
      'pDob':DOB.text,
      'pGender':GenderId,
      'pBloodGroup':BloodGroupId,
      'pPersonEmail':widget.email,
      'mobile_no':widget.mobileno
    };
    print(data);
    var res = await Network().postMethodWithOutToken(data, '/createPersonTmpFile');
    var body = json.decode(res.body);

    if(body['message'] == "SUCCESS") {
      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => NewAccountCreateOTP(
                personId :widget.personId,
                  mobileno:widget.mobileno,email:widget.email,
                  salution:widget.salution,first_name:widget.first_name,middle_name:widget.middle_name,last_name:widget.last_name,alisas:widget.alisas,gender:GenderId,Dob:DOB.text,bloodgroup:BloodGroupId
              )));
    }

  }




  @override
  void initState() {
    super.initState();
      get_data(widget.personId);
      if(widget.personId != 0){
        isButtonEnabled = true;
      }

  }
  Widget build(BuildContext context) {

    if(_isLoading){
      return Scaffold(
        body: Container(
          child: Center(
            child: AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader3,
              color: Colors.orangeAccent,
            ),
          ),
        ),
      );
    }else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text(
            "Create a Account", style: TextStyle(color: Colors.grey),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey,), onPressed: () {
            Navigator.of(context).pop();
          },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Gender',
                          style: TextStyle(),
                        ),
                        DropdownButton(
                          hint: Text('Select'),
                          items: Gender?.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['name']),
                              value: item['id'],
                            );
                          })?.toList() ?? [],
                          value: GenderId,
                          onChanged: (value) {
                            setState(() {
                              GenderId = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    controller: DOB,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Pick Date',
                      labelText: 'DOB*',
                      labelStyle: TextStyle(fontSize: 14.0,color: Colors.red),
                      hintStyle: TextStyle(fontSize: 14.0),
                      // suffixIcon: Icon(Icons.calendar_today_rounded,size: 18.0)
                    ),
                    onTap: () async {
                      // final DateTime now = DateTime.now();
                      final DateFormat formatter = DateFormat('dd-MM-yyyy');
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100)
                      );
                      DOB.text = date.toString().substring(0, 10);
                      setState(() {
                        isButtonEnabled = true;
                      });

                    },),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Blood Group',
                          style: TextStyle(),
                        ),
                        DropdownButton(
                          hint: Text('Select'),
                          items: BloodGroup?.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['name']),
                              value: item['id'],
                            );
                          })?.toList() ?? [],
                          value: BloodGroupId,
                          onChanged: (value) {
                            setState(() {
                              BloodGroupId = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Icon(Icons.direc,color: Colors.white),
                        Text('Next', style: TextStyle(color: Colors.white,),),
                      ],
                    ),
                    onPressed: isButtonEnabled?() {
                      OTP_send();
                    }:null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class NewAccountCreateOTP extends StatefulWidget {

  final String mobileno;
  final int personId;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final int gender;
  final String Dob;
  final int bloodgroup;
  final String email;
  const NewAccountCreateOTP({Key key,this.mobileno,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.Dob,this.bloodgroup,this.gender,this.email,this.personId}) : super(key: key);
  @override
  _NewAccountCreateOTPState createState() => _NewAccountCreateOTPState();
}

class _NewAccountCreateOTPState extends State<NewAccountCreateOTP> {
  final otp = new TextEditingController();
  String Mobile_hashed;
  bool otp_validate = false;
  BottomLoader bl;


  static getPayCardStr(String code) {
    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    setState(() {
      Mobile_hashed = number;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left:25,right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  onChanged:(val){

                    if (val.trim().isEmpty || val.length != 4){
                      setState(() {
                        otp_validate = false;
                      });
                    }else{
                      setState(() {
                        otp_validate = true;
                      });
                    }

                  },
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // labelText: 'Password',
                    hintText: "OTP Received on your Mobile $Mobile_hashed",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),


                  ),
                  controller: otp,
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Icon(Icons.direc,color: Colors.white),
                      Text('Validate',style: TextStyle(color: Colors.white,),),
                    ],
                  ),
                  onPressed: otp_validate?(){
                    OTP_Validate();
                  }:null,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void OTP_Validate ()async{

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();

    var data = {
      'pId' : widget.personId != 0?widget.personId:false,
      'first_name' : widget.first_name,
      'middle_name':widget.middle_name,
      'last_name':widget.last_name,
      'alias':widget.alisas,
      'dob':widget.Dob,
      'gender_id':widget.gender,
      'blood_group_id':widget.bloodgroup,
      'salutation':widget.salution,
      'otp':otp.text,
      'email':widget.email,
      'mobile_no':widget.mobileno,
    };


    var res = await Network().postMethodWithOutToken(data, '/SignUp');
    var body = json.decode(res.body);


    if(body['message'] == "SUCCESS") {


      bl.close();
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => AccountCreatePasswordSet(
              personId:body['data']['id'],
                mobileno:widget.mobileno,email:widget.email,salution:widget.salution,first_name:widget.first_name,
              middle_name:widget.middle_name,last_name:widget.last_name,alisas:widget.alisas,gender:widget.gender,Dob:widget.Dob,bloodgroup:widget.bloodgroup,
              otp:otp.text
            )
        ),
      );
    }else{
      bl.close();
      Fluttertoast.showToast(
          msg: "OTP is Invalid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black
      );
    }
  }


}

class AccountCreatePasswordSet extends StatefulWidget {

  final String mobileno;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final int gender;
  final String Dob;
  final int bloodgroup;
  final int personId;
  final String email;
  final String otp;
  const AccountCreatePasswordSet({Key key,this.mobileno,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.Dob,this.bloodgroup,this.gender,this.email,this.otp,this.personId}) : super(key: key);
  @override
  _AccountCreatePasswordSetState createState() => _AccountCreatePasswordSetState();
}

class _AccountCreatePasswordSetState extends State<AccountCreatePasswordSet> {

  final forgot_password = new TextEditingController();
  final conform_password = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure_conform = true;
  bool _valforgot_pwd = false;
  bool _valconform_pwd = false;
  bool pwd_length = false;
  bool match = false;
  bool msg = false;
  bool validpwd = false;
  bool pwdmatch = false;
  BottomLoader bl;


  void signup_and_signin() async{

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();

    var data = {
      'pId' : widget.personId != 0?widget.personId:false,
      'first_name' : widget.first_name,
      'middle_name':widget.middle_name,
      'last_name':widget.last_name,
      'alias':widget.alisas,
      'dob':widget.Dob,
      'gender_id':widget.gender,
      'blood_group_id':widget.bloodgroup,
      'salutation':widget.salution,
      'otp':widget.otp,
      'password':conform_password.text,
      'email':widget.email,
      'mobile_no':widget.mobileno,
    };


    var res = await Network().postMethodWithOutToken(data, '/SignUp');

    var body = json.decode(res.body);
    if(body['status'] == 1){

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('personData', json.encode(body['PersonDetail']));
      localStorage.setInt('active_org', body['active_org']);

      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MainPage()
        ),
      );
    }else{

      bl.close();
      Fluttertoast.showToast(
          msg: "Server error,Contact admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left:25,right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (val){

                    if (val.length <= 5){


                      setState(() {
                        validpwd = false;
                      });
                    }else{

                      setState(() {
                        validpwd = true;
                      });
                    }
                  },
                  obscureText: _isObscure,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // labelText: 'Password',
                    errorText: validpwd?null:"Password atleast 6 digit must",
                    hintText: "Enter New Password",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    suffixIcon: IconButton(
                        icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                  ),
                  controller: forgot_password,
                ),
                SizedBox(height: 20,),
                Visibility(
                  visible: validpwd,
                  child: TextField(
                    onChanged: (val){

                      if (val != forgot_password.text){


                        setState(() {
                          pwdmatch = false;
                        });
                      }else{

                        setState(() {
                          pwdmatch = true;
                        });
                      }
                    },
                    obscureText: _isObscure_conform,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // labelText: 'Password',
                      // errorText: pwdmatch ? "PassWord does not match":null,
                      hintText: "Retype Password for Confirmation",
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                      suffixIcon: IconButton(
                          icon: Icon(
                              _isObscure_conform ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure_conform = !_isObscure_conform;
                            });
                          }),
                    ),
                    controller: conform_password,
                  ),
                ),
                SizedBox(height: 30.0,),
                RaisedButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Icon(Icons.direc,color: Colors.white),
                      Text('Sign Up',style: TextStyle(color: Colors.white,),),
                    ],
                  ),
                  onPressed: pwdmatch?(){

                    signup_and_signin();

                  }:null,
                ),
                SizedBox(height: 20.0,),
                Visibility(
                  visible: pwdmatch,
                  child: RichText(
                    text: TextSpan(
                    style: defaultStyle,
                    children: <TextSpan>[
                  TextSpan(text: 'By clicking Sign Up, you agree to our '),
                  TextSpan(
                      text: 'Term,',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Terms of Service"');
                        }),
                      TextSpan(
                          text: 'Data Policy',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Terms of Service"');
                            }),
                  TextSpan(text: ' and  '),
                  TextSpan(
                      text: 'Cookie Policy',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Privacy Policy"');
                        }),
                      TextSpan(text: ' Also you agree to send and receive SMS and Email notification from us.'),
              ],
            ),
          ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Inconvenience extends StatefulWidget {
  @override
  _InconvenienceState createState() => _InconvenienceState();
}

class _InconvenienceState extends State<Inconvenience> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ado unbox",style: TextStyle(color: Colors.orangeAccent,fontSize: 50.0,fontStyle: FontStyle.italic),),
            SizedBox(height: 50.0,),
            Align(alignment: Alignment.centerLeft,
                child: Text("Sorry for the inconvenience caused, we need a unique mobile number owned by you to signup our system.")),
            SizedBox(height: 50.0,),
            RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(Icons.direc,color: Colors.white),
                  Text('Continue',style: TextStyle(color: Colors.white,),),
                ],
              ),
              onPressed: (){

                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}





