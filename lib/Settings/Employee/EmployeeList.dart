import 'package:flutter/material.dart';
import 'package:propel/Settings/Employee/EmployeeAdd.dart';
import 'package:propel/network_utils/api.dart';
import 'dart:convert';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  int prorityid = 2;
  Future myFuture;
  bool firstorg = false;
  String Name;
  String MobileNo;
  String Email;

  get_orgId() async{
    int org_id = await Network().GetActiveOrg();

    if(org_id != 0){
      setState(() {
        firstorg = true;
      });
    }
    return org_id;
  }

  Future employeeData() async {
    final orgId = await get_orgId();

    var res = await Network().getMethodWithToken('/taskCreate/$orgId');
    var body = json.decode(res.body);

    if(body['status'] == 1){
      var res = body['data'];

      return res['pAssignedbyList'];
    }else{

      Fluttertoast.showToast(
          msg: "Server Error,Contact Admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
    }

  }
  @override
  void initState() {
    myFuture = employeeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[350],
        title: Text(
          "Manage Workforce",
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
      body: new FutureBuilder(
          future: myFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasError){
              print('Error in Loading'+snapshot.error.toString());
            }
            if(snapshot.hasData){
             // var Name ;
             // var MobileNo;
             // var Email;
                return Scaffold(
                  body: Container(
                    padding: EdgeInsets.all(05),
                    child: Column(
                      children: [
                        Expanded(
                          child: snapshot.data.length != 0 ? SingleChildScrollView(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              // padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i){

                                var res = snapshot.data[i];
                                var first_name = snapshot.data[i]['pFirstName'];
                                var middle_name = snapshot.data[i]['pMiddleName'];
                                var last_name = snapshot.data[i]['pLastName'];


                              var name = res['person']['first_name'];
                                return Column(children: [
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     CircleAvatar(
                                  //       radius: 30,
                                  //       backgroundImage: AssetImage('assets/splash_img.jpg'),
                                  //     ),
                                  //
                                  //     Container(
                                  //       child:
                                  //       Text(res['person']['first_name']),
                                  //     ),
                                  //
                                  //   ],
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //   children: [
                                  //     Container(),
                                  //     CircleAvatar(
                                  //       radius: 40,
                                  //       backgroundImage: AssetImage('assets/splash_img.jpg'),
                                  //     ),
                                  //     Container(),
                                  //     Container(
                                  //
                                  //       child: Text("$name\n$MobileNo$Email"),
                                  //
                                  //     ),
                                  //     Container()
                                  //   ],
                                  // ),
                                  ListTile(
                                    leading: CircleAvatar(
                                      // backgroundImage: AssetImage(widget.image),
                                      child: Text(
                                          "A"),
                                      maxRadius: 50,
                                    ),
                                    title: Text('Ajith'),
                                    subtitle: Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text("Designations")),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text("8489324,shdfsdfgf")),
                                      ],
                                    ),

                                  ),
                                  Divider()
                                ],);

                              },
                            ),
                          ):Center(
                            child: Center(child: Text("Employee is Empty",style: TextStyle(fontSize: 20.0),),),
                          ),
                        ),
                        RaisedButton(
                            color: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add, color: Colors.white),
                                Text(
                                  'Add Workforce',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EmployeeAdd()));
                            }),
                      ],
                    ),
                  ),
                );
            }else{
              return Container(
                child: Center(
                  child: AwesomeLoader(
                    loaderType: AwesomeLoader.AwesomeLoader3,
                    color: Colors.orange,
                  ),
                ),
              );
            }
          }),
    );
  }
}
