import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propel/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'dart:convert';
import 'package:propel/auth/login.dart';
import 'package:propel/auth/Person/Person.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:propel/Settings/Employee/EmployeeList.dart';



class EmployeeAdd extends StatefulWidget {
  @override
  _EmployeeAddState createState() => _EmployeeAddState();
}

class _EmployeeAddState extends State<EmployeeAdd> {
  final phoneNo = new TextEditingController();
  bool phoneVal = false;
  bool invalidphone = false;
  bool isButtonEnabled = false;
  BottomLoader bl;
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

    var person = true;
    if(person){
      bl.close();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeeEmailVerfication(
                      mobileno: mobile_no)));
    }
    // if (body['message'] == "SUCCESS") {
    //   if (body['data']['pId'] != '') {
    //     // if (body['data']['pHavingUser']) {
    //     //   var Name = body['data']['pFirstName'] + body['data']['pMiddleName'];
    //     //   bl.close();
    //     //   Navigator.push(
    //     //       context,
    //     //       MaterialPageRoute(
    //     //           builder: (context) => LoginPageTwo(
    //     //               mobileno: mobile_no,
    //     //               name: Name,
    //     //               user_id: body['data']['pPersonUserDetails']['id'],
    //     //               user_credentials: true,
    //     //               email: body['data']['pPersonEmailDetails']['email'])));
    //     // } else {
    //       bl.close();
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => EmailVerfication(
    //                   mobileno: mobile_no, user_credentials: true)));
    //     // }
    //   } else {
    //     bl.close();
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => EmployeeEmailVerfication(
    //                 mobileno: mobile_no, user_credentials: false)));
    //   }
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.grey[350],
      title: Text(
        "Add Workforce",
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
      body: Container(
        padding: EdgeInsets.only(left: 25, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    'Continue to Search',
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


          ],
        ),
      ),);
  }
}


class EmployeeEmailVerfication extends StatefulWidget {
  final String mobileno;
  final String email;
  const EmployeeEmailVerfication({Key key,this.mobileno,this.email}) : super(key: key);
  @override
  _EmployeeEmailVerficationState createState() => _EmployeeEmailVerficationState();
}

class _EmployeeEmailVerficationState extends State<EmployeeEmailVerfication> {

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

    // var res = await Network().postMethodWithOutToken(data, '/get_persondetails');
    // var body = json.decode(res.body);


      bl.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => EmployeeAccountVerfied(
                  personId:0,
                  mobileno:widget.mobileno,
                  email:email.text
              )));
    //
    // if(widget.user_credentials){
    //
    //   if(body['status'] == 1){
    //
    //     bl.close();
    //     Navigator.push(context,
    //         MaterialPageRoute(
    //             builder: (context) => loginCredtionalMsg(
    //                 personId:body['data']['id'],
    //                 mobileno:widget.mobileno,
    //                 user_credtional:widget.user_credentials,
    //                 email:email.text
    //             )));
    //   }else if(body['status'] == 2){
    //     bl.close();
    //     Fluttertoast.showToast(
    //         msg: "MobileNo and Email does not matched any persons",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         // timeInSecForIos: 1,
    //         backgroundColor: Colors.grey,
    //         textColor: Colors.black
    //     );
    //
    //   }else{
    //
    //     bl.close();
    //     Navigator.push(context,
    //         MaterialPageRoute(
    //             builder: (context) => distnictOTP(
    //                 mobileno:widget.mobileno,
    //                 email:email.text
    //             )));
    //
    //   }
    //
    // }else{
    //   bl.close();
    //   Navigator.push(context,
    //       MaterialPageRoute(
    //           builder: (context) => loginCredtionalMsg(
    //               personId:0,
    //               mobileno:widget.mobileno,
    //               user_credtional:widget.user_credentials,
    //               email:email.text
    //           )));
    // }



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
    // print(widget.user_credentials);
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



class EmployeeAccountVerfied extends StatefulWidget {
  final String mobileno;
  final String email;
  final int personId;
  const EmployeeAccountVerfied({Key key,this.mobileno,this.email,this.personId}) : super(key: key);
  @override
  _EmployeeAccountVerfiedState createState() => _EmployeeAccountVerfiedState();
}

class _EmployeeAccountVerfiedState extends State<EmployeeAccountVerfied> {
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
                  EmployeeCreate1(
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
                //               EmployeeCreate1(
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

class EmployeeCreate1 extends StatefulWidget {
  final String mobileno;
  final String email;
  final int personId;
  EmployeeCreate1({ Key key,this.mobileno,this.email,this.personId}): super(key: key);
  @override
  _EmployeeCreate1State createState() => _EmployeeCreate1State();
}

class _EmployeeCreate1State extends State<EmployeeCreate1> {

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
                                  EmployeeCreate2(
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

class EmployeeCreate2 extends StatefulWidget {
  final int personId;
  final int salution;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String alisas;
  final String mobileno;
  final String email;
  const EmployeeCreate2({Key key,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.mobileno,this.email,this.personId}) : super(key: key);
  @override
  _EmployeeCreate2State createState() => _EmployeeCreate2State();
}

class _EmployeeCreate2State extends State<EmployeeCreate2> {

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
              builder: (context) => EmployeeCreateOTP(
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

class EmployeeCreateOTP extends StatefulWidget {

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
  const EmployeeCreateOTP({Key key,this.mobileno,this.salution,this.first_name,this.middle_name,this.last_name,this.alisas,this.Dob,this.bloodgroup,this.gender,this.email,this.personId}) : super(key: key);
  @override
  _EmployeeCreateOTPState createState() => _EmployeeCreateOTPState();
}

class _EmployeeCreateOTPState extends State<EmployeeCreateOTP> {
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
                      Text('Add the Above Workforce',style: TextStyle(color: Colors.white,),),
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
      Fluttertoast.showToast(
          msg: "Workfocce added sucessfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black
      );
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => EmployeeList(

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
