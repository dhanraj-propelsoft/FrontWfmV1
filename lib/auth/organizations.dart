import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'dart:convert';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_loader/bottom_loader.dart';
class Organizations extends StatefulWidget {
  @override
  _OrganizationsState createState() => _OrganizationsState();
}

class _OrganizationsState extends State<Organizations> {
  BottomLoader bl;
  bool isSwitched = false;
  bool frstorg = true;
  List switchList;
  Future myFuture;
  int seletedOrg;
  int OrganizationId;
  bool firstorg = false;

  get_orgId() async{
    final prefs = await SharedPreferences.getInstance();
    seletedOrg = prefs.getInt('orgid') ?? 0;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var Data = jsonDecode(localStorage.getString('allData'));
    if(seletedOrg == 0){
      // if(Data['firstOrg'] == 0){
      //   setState(() {
      //     firstorg = false;
      //   });
      // }else{
      //   setState(() {
      //     firstorg = true;
      //   });
      // }
      OrganizationId = Data['firstOrg'];

    }else{
      OrganizationId = seletedOrg;
    }

    if(OrganizationId != 0){
      setState(() {
        firstorg = true;
      });
    }

    return OrganizationId;
  }

  Future<List> orgData() async {
    var res = await Network().getMethodWithToken('/user_companies');
    var body = json.decode(res.body);

    return [];

    // if(body['status'] == 1){
    //   var result = body['data'];
    //   setState(() {
    //     switchList = result;
    //   });
    //   return result;
    // }
  }
  Future<List> _selectorg(bool value,int orgid) async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    switchList.removeWhere((item) => item['id'] == orgid);

    var data = {'currentorg' : orgid,'otherorg':switchList};
    var res = await Network().getMethodWithToken('/SwitchOrg');
//    var res = await Network().ProjectStore(data, '/SwitchOrg');
    var body = json.decode(res.body);

    if(body['status'] == 1){

      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      // set value
      prefs.setInt('orgid', orgid);

      Fluttertoast.showToast(
          msg: body['data']['name']+" is Actived",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );

    }
    myFuture = orgData();
    bl.close();

  }

  @override
  void initState() {
    myFuture = orgData();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<List>(
          future: myFuture,
          builder: (context,snapshot){
            if(snapshot.hasError){
              print('Error in Loading'+snapshot.error.toString());
            }
            if(snapshot.hasData){
              if(snapshot.data.length == 0){
                return Container(
                  child: Center(child: Text("Organization is empty")),
                );
              }else {
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(top: 05, right: 05),
                      child: Column(
                        children: <Widget>[
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Container(
                          //       child: SizedBox(
                          //         // width: 20.0,
                          //         height: 30.0,
                          //         child: RaisedButton(
                          //             color: Colors.blue,
                          //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          //             child: Row(
                          //               children: <Widget>[
                          //                 Icon(Icons.add,color: Colors.white),
                          //                 Text('Add Organizations',style: TextStyle(color: Colors.white,),),
                          //               ],
                          //             ),
                          //             onPressed: (){}
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Divider(),
                          // Container(
                          //   padding: EdgeInsets.only(left: 50),
                          //   child: ListTile(
                          //     title: Text("Select All"),
                          //     trailing: Container(
                          //         width: 60,
                          //         child: Switch(
                          //           value: isSwitched,
                          //           // onChanged: (bool value) {
                          //           //   setState(() {
                          //           //     isSwitched = value;
                          //           //   });
                          //           // },
                          //           activeColor: Colors.white,
                          //           activeTrackColor: Colors.green,
                          //           inactiveThumbColor: Colors.white,
                          //           inactiveTrackColor: Colors.red,
                          //         )
                          //     ),
                          //   ),
                          // ),
                          ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            // padding: EdgeInsets.only(top: 16),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: CircleAvatar(
                                  // backgroundImage: AssetImage(widget.image),
                                  child: Text(
                                      snapshot.data[i]['name'].toString()
                                          .substring(0, 1)
                                          .toUpperCase()),
                                  maxRadius: 20,
                                ),
                                title: Text(snapshot.data[i]['name']),
                                trailing: Container(
                                    width: 60,
                                    child: Switch(
                                      value: snapshot.data[i]['is_active'] ==
                                          '1' ? true : false,
                                      onChanged: (bool value) => _selectorg(
                                          value, snapshot.data[i]['id']),
                                      // onChanged: (bool Value){},
                                      activeColor: Colors.white,
                                      activeTrackColor: Colors.green,
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: Colors.red,
                                    )
                                ),
                                onTap: () {},
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
            else{
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







