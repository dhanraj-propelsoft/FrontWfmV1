import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'package:propel/wfm/masters/Category/add_category.dart';
import 'package:propel/wfm/masters/Category/update_category.dart';
import 'dart:convert';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:propel/main_page.dart';
import 'package:connectivity/connectivity.dart';
import 'package:bottom_loader/bottom_loader.dart';


class category extends StatefulWidget {
  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {

  bool isSwitched;
  int OrganizationId;
  List switchList;
  Future myFuture;
  int seletedOrg;
  bool unAssigned;
  bool firstorg = false;
  BottomLoader bl;

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



  Future<List> checkconnections() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile) {
      print("connectde mobile");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("connectde wifi");
    }else{
      print("offline mode");
    }
  }

  Future<List> categoryData() async {
    final prefs = await SharedPreferences.getInstance();
    final orgId = await get_orgId();

    var res = await Network().categoryList('/CategoryList/$orgId');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      var result = body['data'];
      setState(() {
        isSwitched = body['selectall'];
        switchList = result;
      });
      return result;
    }
  }


  Future<List> _onchanged(bool value,int index,int id) async {

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    final user = await categoryData();

    var data = {'id' : id,'status':value?1:0};

    var res = await Network().ProjectStore(data, '/CategoryStatusChg');
    var body = json.decode(res.body);

    if(body['status'] == 1){

      Fluttertoast.showToast(

          msg: body['data'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
      myFuture = categoryData();

      bl.close();

    }

  }


  Future<List> _unAssigned(bool value) async {

   setState(() {
     unAssigned = value;
   });

   // obtain shared preferences
   final prefs = await SharedPreferences.getInstance();
   // set value
   prefs.setBool('unAssignedcategory', unAssigned);

  }


  Future<List> _selectall(bool value) async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    final user = await categoryData();
    var data = {'status':value,'id':user};
    var res = await Network().ProjectStore(data, '/CategorySelectAll');
    var body = json.decode(res.body);

    if(body['status'] == 1){
      Fluttertoast.showToast(
          msg: body['data'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
      myFuture = categoryData();
      setState(() {
        isSwitched = value;
      });
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();
      // set value
      prefs.setBool('unAssignedcategory', value);

      bl.close();
    }

  }

  @override
  void initState() {
    myFuture = categoryData();
    checkconnections();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<List>(
          future: myFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasError){
              print('Error in Loading'+snapshot.error.toString());
            }
            if(snapshot.hasData){
              if(snapshot.data.length == 0){
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(top: 05, right: 05),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: SizedBox(
                                  // width: 20.0,
                                  height: 30.0,
                                  child: RaisedButton(
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20)),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.add, color: Colors.white),
                                          Text('Add Category', style: TextStyle(
                                            color: Colors.white,),),
                                        ],
                                      ),
                                      // onPressed: () {
                                      //
                                      //   Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               AddCategory()));
                                      // }
                                    onPressed: firstorg?(){
                                      Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCategory()));
                                    }:null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Center(
                              child: Text("Category is Empty")
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }else{
                return Scaffold(
                  body: Container(
                    padding: EdgeInsets.only(top:05,right: 05),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: SizedBox(
                                // width: 20.0,
                                height: 30.0,
                                child: RaisedButton(
                                    color: Colors.orange,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.add,color: Colors.white),
                                        Text('Add Category',style: TextStyle(color: Colors.white,),),
                                      ],
                                    ),
                                  onPressed: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddCategory()));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Container(
                          // padding: EdgeInsets.only(left: 50),
                          child: ListTile(
                            title: Text("Select All"),
                            trailing: Container(
                                width: 60,
                                child: Switch(
                                  value: isSwitched,
                                  // onChanged: (bool value) {
                                  //   setState(() {
                                  //     isSwitched = value;
                                  //   });
                                  // },
                                  onChanged: (bool expanding) => _selectall(expanding),
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.green,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.red,
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              // padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),

                              itemBuilder: (context, i){
                                return ListTile(

                                  title: Text(snapshot.data[i]['pName']),
                                  trailing: Container(
                                      width: 60,
                                      child: Switch(
                                        value: switchList[i]['pStatus'],
                                        onChanged: (bool expanding) => _onchanged(expanding, i,snapshot.data[i]['pId']),
                                        activeColor: Colors.white,
                                        activeTrackColor: Colors.green,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: Colors.red,
                                      )
                                  ),
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateCategory(
                                              id:snapshot.data[i]['pId'],
                                              name:snapshot.data[i]['pName'],
                                            )));
                                  },
                                );

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
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








