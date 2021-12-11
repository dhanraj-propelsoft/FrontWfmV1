import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProject extends StatefulWidget {
  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {

  List employeeList;
  int seletedemployee;
  List categoryList;
  int seletedcategory;
  final Name = new TextEditingController();
  bool _valName = false;
  final Details = new TextEditingController();
  final CreateddateController = TextEditingController();
  final DuedateController = TextEditingController();
  var todayDate =  DateTime.now();
  bool _isLoading = false;
  int seletedOrg;
  int OrganizationId;
  bool isButtonEnabled = false;



  void initState() {
    _projectData();
    super.initState();

  }

  @override
  Future<String> _projectData() async {
    setState(() {
      _isLoading = true;
    });
    int orgId = await Network().GetActiveOrg();
    var res = await Network().getMethodWithToken('/projectCreate/$orgId');
    var body = json.decode(res.body);

    // print(body);
    if(body['status'] == 1){
      var result = body['data'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user = localStorage.getString('personData');
      final res = jsonDecode(user);
      // var formattedDate ="${todayDate.year}-${todayDate.month}-${todayDate.day}";
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String todayDate = formatter.format(now);
      // result['pEmployeeDatas'].forEach((item) => print(item['person']));
      setState(() {
        seletedemployee = res['id'];
        employeeList = result['pEmployeeDatas'];
        categoryList = result['pCategoryDatas'];
        CreateddateController.text = todayDate;
        DuedateController.text = "Lifetime";
        _isLoading = false;
        // seletedemployee = int.parse(Data['person_id']);
      });

    }

  }

  Future projectSave(String name,String Details,int employee,int category,String StartDate,String EndDate) async {
    setState(() {
      _isLoading = true;
    });
    int orgId = await Network().GetActiveOrg();
    var data = {'pName' : name,'pDetails':Details,'pProjectOwner':employee,'pCategoryId':category,'pStartDate':StartDate,'pDeadlineDate':EndDate,'orgId':orgId};
    var res = await Network().postMethodWithToken(data, '/projectStore');
    var body = json.decode(res.body);
    print(body);
    if(body['status'] == 1){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                index:2, page:"Add"
              )));
    }else if(body['status'] == 0){
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "this Project name is already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
    }else{
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Server Error,Contact Admin..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
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
        appBar: AppBar(title: Text("Add Project",style: TextStyle(color: Colors.white),),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
            Navigator.of(context).pop();
          },),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    obscureText: false,
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
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Enter Project Name",
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(fontSize: 14.0),
                      errorText: _valName ? "Name is required" : null,
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
                    ),
                    controller: Name,

                  ),

                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                    obscureText: false,
                    // maxLines: 3,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Enter the Project Details",
                      labelText: "Details",
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(fontSize: 14.0),
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
                    ),
                    controller: Details,
                  ),

                ),

                Container(
                  // padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [


                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              value: seletedemployee,

                              hint: Text('Project Owner'),
                              items: employeeList?.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['person']['first_name']),
                                      value: item['person']['id'],
                                );
                              })?.toList() ??
                                  [],
                              onChanged: (newValue) {
                                setState(() {
                                  seletedemployee = newValue;

                                });
                              },
                            ),
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              value: seletedcategory,

                              hint: Text('UnAssigned Category'),
                              items: categoryList?.map((item) {
                                return new DropdownMenuItem(
                                  child: Text(item['pName']),
                                  value: item['pId'],
                                );
                              })?.toList() ?? [],
                              onChanged: (newValue) {
                                setState(() {
                                  seletedcategory = newValue;
                                });

                              },
                            ),
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextField(
                            readOnly: true,
                            controller: CreateddateController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'Start Date',
                                labelStyle: TextStyle(fontSize: 14.0),
                                hintStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(
                                    Icons.calendar_today_rounded, size: 18.0)
                            ),
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              CreateddateController.text = date.toString().substring(0, 10);
                            },),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Flexible(
                          child: TextField(
                            readOnly: true,
                            controller: DuedateController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'End Date',
                                labelStyle: TextStyle(fontSize: 14.0),
                                hintStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(
                                    Icons.calendar_today_rounded, size: 18.0)
                            ),
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              DuedateController.text = date.toString().substring(0, 10);
                              var startDate = CreateddateController.text;
                              var EndDate = DuedateController.text;
                              print(EndDate.compareTo(startDate));
                              if(EndDate.compareTo(startDate) < 0)
                              {
                                Fluttertoast.showToast(
                                    msg: "Start Date should not be greater than End Date.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.black);

                                setState(() {
                                  DuedateController.text = "";
                                });
                              }

                            },),
                        ),
                      ],
                    )
                ),

                SizedBox(
                  height: 50,
                ),

                ButtonBar(
                    children: <Widget>[

                      RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            Text('Clear',style: TextStyle(color: Colors.white,),),
                            // Icon(Icons.redo_sharp,color: Colors.white),
                          ],
                        ),
                        onPressed:isButtonEnabled?(){
                          Name.clear();
                          Details.clear();
                          // CreateddateController.clear();
                          // DuedateController.clear();
                          setState(() {
                            seletedcategory = null;
                          });
                          // Name.clear();
                          // Details.clear();
                          // setState(() {
                          //   seletedcategory = null;
                          //   seletedproject = null;
                          //   Assignedtoemployee = null;
                          //   _selected_followers.clear();
                          // });
                        }:null,
                        // onPressed: (){
                        //   Name.clear();
                        //   Details.clear();
                        //   // CreateddateController.clear();
                        //   // DuedateController.clear();
                        //   setState(() {
                        //     seletedcategory = null;
                        //     seletedproject = null;
                        //     Assignedtoemployee = null;
                        //     _selected_followers.clear();
                        //   });
                        // }
                      ),
                      RaisedButton(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            Text('Save',style: TextStyle(color: Colors.white,),),
                            // Icon(Icons.redo_sharp,color: Colors.white),
                          ],
                        ),
                        onPressed:isButtonEnabled?(){
                          projectSave(
                              Name.text, Details.text, seletedemployee,
                              seletedcategory, CreateddateController.text,
                              DuedateController.text);
                        }:null,

                      ),
                    ]


                )
              ],
            ),
          ),
        ),

      );
    }
  }
}
