import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:propel/auth/Person/Person.dart';
import 'package:propel/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:propel/network_utils/api.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';


class distnictOTP extends StatefulWidget {
  final String mobileno;
  final String email;
  const distnictOTP({Key key,this.mobileno,this.email}) : super(key: key);
  @override
  _distnictOTPState createState() => _distnictOTPState();
}

class _distnictOTPState extends State<distnictOTP> {

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

  void send_otp()async{

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
      'mobile_no' : widget.mobileno,
      'first_name': "text"
    };
    var res = await Network().postMethodWithOutToken(data, '/sendOtpPerson');
    var body = json.decode(res.body);

    if(body['message'] != "SUCCESS"){

      Fluttertoast.showToast(
          msg: "OTP did not send Server error,contact Admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );

    }


  }

  void OTP_Validate()async{

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
      'mobile_no' : widget.mobileno,
      'otp':otp.text
    };
    print(otp.text);
    var res = await Network().postMethodWithOutToken(data, '/getTmpPersonFile');
    var body = json.decode(res.body);

    if(body['message'] == "SUCCESS"){
      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => AccountList(
                  otp:int.parse(otp.text),
                  mobileno:widget.mobileno,
                  email:widget.email
              )));

    }else{
      bl.close();
      Fluttertoast.showToast(
          msg: "OTP MisMatched",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );

    }


  }

  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    setState(() {
      Mobile_hashed = number;
    });
    send_otp();
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
    );
  }
}

class AccountList extends StatefulWidget {
  final String mobileno;
  final String email;
  final int otp;
  const AccountList({Key key,this.mobileno,this.email,this.otp}) : super(key: key);
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {

  bool selectradio = false;
  String noneofabove;
  BottomLoader bl;
  int SelectPersonId;
  int initialValue;
  Future myFuture;
  String email;
  String Name;
  List  Accountlist;


  Future<List> get_AccountList() async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var mobile_no = widget.mobileno;
    var res = await Network().getMethodWithOutToken('/get_account_list/$mobile_no');
    var body = json.decode(res.body);
    print(body);
    if(body['status'] == 1){
      var result = body['data'];
      Accountlist = body['data'];

      Accountlist.removeWhere((item) => item['pHavingUser'] == true);

      return Accountlist;
    }


  }

  void choose_person()async{

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    if(SelectPersonId == 0){
      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  EmailVerfication(
                      mobileno: widget.mobileno,
                      user_credentials : false
                  )));
    }else{
      bl.close();

      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  EmailOTP(
                      otp:widget.otp,
                      personId:SelectPersonId,
                      mobileno: widget.mobileno,
                      email : email,
                      name:Name
                  )));



    }
  }

  @override
  void initState() {
    myFuture = get_AccountList();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var mobileno = widget.mobileno;

    return Scaffold(
      body: new FutureBuilder<List>(
          future: myFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasError){
              print('Error in Loading'+snapshot.error.toString());
            }
            if(snapshot.hasData){
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.grey[350],
                    title: Text("Choose Account",style: TextStyle(color: Colors.black),),
                    leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
                      Navigator.of(context).pop();
                    },),
                  ),
                   body: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: Text("This mobile number $mobileno has these record on our system")),
                          SizedBox(height: 20.0,),
                          Center(child: Text("By selecting one of them you ensure its your record and also you can edit and update spelling errors once you’re login")),
                          Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context,i) {
                              var first_name = snapshot.data[i]['pFirstName'];
                              var middle_name = snapshot.data[i]['pMiddleName'];
                              var last_name = snapshot.data[i]['pLastName'];
                                initialValue = snapshot.data[i]['pId'];

                                return Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        // backgroundImage: AssetImage(widget.image),
                                        child: Text(
                                            snapshot.data[i]['pFirstName'].toString()
                                                .substring(0, 1)
                                                .toUpperCase()),
                                        maxRadius: 20,
                                      ),
                                      title: Text('$first_name'+' '+'$middle_name'+' '+'$last_name'),
                                      subtitle: Text(snapshot.data[i]['pPersonEmailDetails']['email']),
                                      trailing: Radio(
                                        value: initialValue,
                                        groupValue: SelectPersonId,
                                        onChanged: (int value) {
                                          setState(() {
                                            email = snapshot.data[i]['pPersonEmailDetails']['email'];
                                            SelectPersonId = value;
                                            selectradio = true;
                                            Name = snapshot.data[i]['pFirstName'];
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                            }),
                          ),
                          ListTile(
                            title: Text("None of the above record is mine create a new account for me"),
                            trailing: Radio(
                              value: 0,
                              groupValue: SelectPersonId,
                              onChanged: (int value) {
                                setState(() {
                                  SelectPersonId = value;
                                  selectradio = true;
                                });
                              },
                            ),
                          ),
                          Divider(),
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
                            onPressed: selectradio?(){
                             choose_person();
                            }:null,
                          ),

                        ],
                      ),
                    )

                );
            }else{
              return Container(
                child: Center(
                  child: AwesomeLoader(
                    loaderType: AwesomeLoader.AwesomeLoader3,
                    // color: Colors.blue,
                  ),
                ),
              );
            }
          }),
    );

  }
}

class EmailOTP extends StatefulWidget {
  final String mobileno;
  final String email;
  final int personId;
  final String name;
  final int otp;
  EmailOTP({ Key key,this.mobileno,this.email,this.personId,this.name,this.otp}): super(key: key);
  @override
  _EmailOTPState createState() => _EmailOTPState();
}

class _EmailOTPState extends State<EmailOTP> {
  bool otp_validate = false;
  BottomLoader bl;
  final otp = new TextEditingController();

  static getPayCardStr(String code) {

    final int length = code.length;
    final int replaceLength = length - 2;
    final String replacement = List<String>.generate((replaceLength / 4).ceil(), (int _) => 'xxxx').join('');
    return code.replaceRange(0, replaceLength, replacement);
  }

  void send_otp_email() async{
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
      'email_id' : widget.email,
      'personId':widget.personId,
      'name':widget.name
    };

    var res = await Network().postMethodWithOutToken(data, '/sendotp_email');
    var body = json.decode(res.body);


    if(body['status'] != 1){

      bl = new BottomLoader(
        context,
        showLogs: true,
        isDismissible: true,
      );
      bl.style(
        message: 'Please wait...',
      );
      bl.display();
    }



  }

  void otp_verfiy() async{

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
      'email_id' : widget.email,
      'otp':otp.text
    };

    var res = await Network().postMethodWithOutToken(data, '/verifiy_email_otp');
    var body = json.decode(res.body);
    if(body['message'] == "SUCCESS"){

    bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => distnictAccountVerfied(otp:widget.otp,mobileno:widget.mobileno,email:widget.email,personId: widget.personId)));

    }else{

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

  @override
  void initState() {
    var number = getPayCardStr(widget.mobileno);
    send_otp_email();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var email = widget.email;

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
                hintText: "OTP Received on your Email $email",
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

                otp_verfiy();

              }:null,
            ),
          ],
        ),
      ),
    );
  }
}

class distnictAccountVerfied extends StatefulWidget {
  final String mobileno;
  final String email;
  final int personId;
  final int otp;
  const distnictAccountVerfied({Key key,this.mobileno,this.email,this.personId,this.otp}) : super(key: key);
  @override
  _distnictAccountVerfiedState createState() => _distnictAccountVerfiedState();
}

class _distnictAccountVerfiedState extends State<distnictAccountVerfied> {
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
                  distinictAccountCreate1(
                      otp:widget.otp,
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

class distinictAccountCreate1 extends StatefulWidget {
  final String mobileno;
  final String email;
  final int personId;
  final int otp;
  distinictAccountCreate1({ Key key,this.mobileno,this.email,this.personId,this.otp}): super(key: key);
  @override
  _distinictAccountCreate1State createState() => _distinictAccountCreate1State();
}

class _distinictAccountCreate1State extends State<distinictAccountCreate1> {

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
    if(widget.personId != 0){
      get_data(widget.personId);
      setState(() {
        isButtonEnabled = true;
      });
    }

  }
  @override

  Widget build(BuildContext context) {
    if(_isLoading){
      return Scaffold(
        body: Container(
          child: Center(
            child: AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader3,
              color: Colors.blue,
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
        body: Container(
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
                  if (val
                      .trim()
                      .isEmpty) {
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
                  labelText: "First Name",
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
                              distinictAccountCreate2(
                                otp:widget.otp,
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

      );
    }
  }
}

class distinictAccountCreate2 extends StatefulWidget {
  final int personId;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final String mobileno;
  final String email;
  final int otp;
  const distinictAccountCreate2({Key key,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.mobileno,this.email,this.personId,this.otp}) : super(key: key);
  @override
  _distinictAccountCreate2State createState() => _distinictAccountCreate2State();
}

class _distinictAccountCreate2State extends State<distinictAccountCreate2> {
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

    var res = await Network().postMethodWithOutToken(data, '/createPersonTmpFile');
    var body = json.decode(res.body);

    if(body['message'] == "SUCCESS") {
      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => distnictAccountCreatePasswordSet(
                  otp:widget.otp,
                  personId :widget.personId,
                  mobileno:widget.mobileno,email:widget.email,
                  salution:widget.salution,first_name:widget.first_name,middle_name:widget.middle_name,last_name:widget.last_name,alisas:widget.alisas,gender:GenderId,Dob:DOB.text,bloodgroup:BloodGroupId
              )));
    }

  }




  @override
  void initState() {
    super.initState();
    if(widget.personId != 0){
      get_data(widget.personId);

    }
  }
  Widget build(BuildContext context) {
    if(_isLoading){
      return Scaffold(
        body: Container(
          child: Center(
            child: AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader3,
              color: Colors.blue,
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
        body: Container(
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
                  labelText: 'DOB',
                  labelStyle: TextStyle(fontSize: 14.0),
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
                onPressed: () {
                  // OTP_send();
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => distnictAccountCreatePasswordSet(
                              otp:widget.otp,
                              personId :widget.personId,
                              mobileno:widget.mobileno,email:widget.email,
                              salution:widget.salution,first_name:widget.first_name,middle_name:widget.middle_name,last_name:widget.last_name,alisas:widget.alisas,gender:GenderId,Dob:DOB.text,bloodgroup:BloodGroupId
                          )));
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}

class distnictAccountCreatePasswordSet extends StatefulWidget {

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
  final int otp;
  const distnictAccountCreatePasswordSet({Key key,this.mobileno,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.Dob,this.bloodgroup,this.gender,this.email,this.otp,this.personId}) : super(key: key);
  @override
  _distnictAccountCreatePasswordSetState createState() => _distnictAccountCreatePasswordSetState();
}

class _distnictAccountCreatePasswordSetState extends State<distnictAccountCreatePasswordSet> {

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

    print(data);
    var res = await Network().postMethodWithOutToken(data, '/SignUp');

    var body = json.decode(res.body);
    print(body);
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
    print(widget.otp);
    return Scaffold(
      body: Container(
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
    );
  }
}