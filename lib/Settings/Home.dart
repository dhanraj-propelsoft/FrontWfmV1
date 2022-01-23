import 'package:flutter/material.dart';
import 'package:propel/Settings/MySettings.dart';
import 'package:propel/Settings/OrganizationSettings.dart';
import 'package:propel/Settings/Profile.dart';
import 'package:propel/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:propel/main.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:propel/auth/Person/Person.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int selected;
  String Name;
  String MobileNo;
  String Email;


  get_userdata() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('personData');
    final res = jsonDecode(user);
    setState(() {
      Name = res['first_name'];
      MobileNo = res['person_mobile']['mobile_no'];
      Email = res['person_email']['email'];
    });
    return false;
  }
  @override
  void initState() {
    super.initState();
    get_userdata();

  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[350],
        title: Text(
          "Settings",
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 20.0,left: 10.0,right: 10.0),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                          )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/splash_img.jpg'),
                    ),
                    Container(

                      child: Text("$Name\n$MobileNo\n$Email"),

                    ),
                    Icon(Icons.arrow_forward_ios_sharp)
                  ],
                ),
              ),
              Divider(),
              ListTile(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => MySettings(
                          )));
                },
                title: Text("My Setting"),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(),
              ListTile(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => OrganizationSettings(
                          )));
                },
                title: Text("Organization"),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(),
              ListTile(
                title: Text("Inbox"),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(),
              ListTile(
                title: Text("Feedback and Support Ticket"),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(),
              ListTile(
                title: Text("Refer / invite friends"),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
              ),
              Divider(),
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.arrow_forward_ios_sharp),
                onTap: (){
                  logout();
                },
              ),
              Divider(),
              Image(width: 200,
                  height: 200,
                  image: AssetImage('assets/about_image.png'))

            ],
          ),
        ),
      ),
    );
  }
  void logout() async{

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height = MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return SingleChildScrollView(
                  child: Container(
                    padding: new EdgeInsets.only(top: 20.0,bottom: 20.0),
                    child: Column(
                      children: [
                        Center(child: Text("Are you sure want to logout?",style: TextStyle(fontSize: 20.0),)),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: <Widget>[
                                    Text('No',style: TextStyle(color: Colors.white,),),
                                    // Icon(Icons.close,color: Colors.white),
                                  ],
                                ),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                }
                            ),
                            RaisedButton(
                              color: Colors.orange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: <Widget>[
                                  Text('Yes',style: TextStyle(color: Colors.white,),),
                                ],
                              ),

                              onPressed:(){
                                Navigator.of(context).pop();
                                logout_conform();
                                         },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  void logout_conform() async{
    BottomLoader bl;

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var res = await Network().postMethodWithToken(false,'/logout');
    var body = json.decode(res.body);

    if(body['status'] == '1'){

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('token');
      localStorage.remove('personData');
      localStorage.remove('active_org');
      bl.close();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>CheckAuth()));

    }
  }
}
