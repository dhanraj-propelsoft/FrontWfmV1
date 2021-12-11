import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'package:propel/wfm/masters/Project/project.dart';
import 'dart:math';
import 'dart:convert';
import 'package:propel/main_page.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bottom_loader/bottom_loader.dart';


class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}


class CompanyWidget {
  const CompanyWidget(this.id,this.name);
  final String name;
  final int id;
}
class Animal {
  final int id;
  final String name;

  Animal({
    this.id,
    this.name,
  });
}
class _AddTaskState extends State<AddTask> {

  final Name = new TextEditingController();
  final Details = new TextEditingController();
  final CreateddateController = TextEditingController();
  final DuedateController = TextEditingController();
  BottomLoader bl;
  String ProjEndDate;
  List AssignedbyList;
  int Assignedbyemployee;
  List AssignedtoList;
  int Assignedtoemployee;
  List projectList;
  int seletedproject;
  List categoryList;
  int seletedcategory;
  int prorityid = 2;
  bool _valName = false;
  bool _isLoading = false;
  List tempFollowerList;
  List FollowerList;
  // List selectedfollower;
  String _myActivitiesResult;
  int seletedOrg;
  int OrganizationId;
  String Category = "Unassigned Category";
  List<CompanyWidget> _companies = [];
  List _selected_followers = [];
  bool isButtonEnabled = false;

  void _handleRadioValueChange(int value) {
    setState(() {
      prorityid = value;
      switch (prorityid) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  void initState() {
    _taskData();
    super.initState();

  }

  @override


  Future<String> _ProjBasedCate(int ProjId) async {

    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var res = await Network().getMethodWithToken('/ProjBasedCategory/$ProjId');
    var body = json.decode(res.body);
    print(body);
    if(body['status'] == 1){
        var projectData = body['projecData'];
        var catgoryData = body['categoryData'];
      setState(() {
        if(projectData['deadline_date'] != "Lifetime"){
          ProjEndDate = projectData['deadline_date'];
          DuedateController.text = ProjEndDate;
        }
        if(catgoryData != null){
          Category = catgoryData['name'];
          seletedcategory = catgoryData['id'];
        }else{
          Category = "Unassigned Category";
        }

      });
      bl.close();
    }else{
      bl.close();
      Fluttertoast.showToast(
          msg: "Server Error,Contact Admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
    }
  }


  Future<String> _taskData() async {
    setState(() {
      _isLoading = true;
    });
    int orgId = await Network().GetActiveOrg();
    var res = await Network().getMethodWithToken('/taskCreate/$orgId');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      var result = body['data'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user = localStorage.getString('personData');
      final res = jsonDecode(user);

      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String todayDate = formatter.format(now);
      setState(() {
        Assignedbyemployee = res['id'];
        Assignedtoemployee = res['id'];
        AssignedbyList = result['pAssignedbyList'];
        AssignedtoList = result['pAssignedtoList'];
        FollowerList = result['pFollowerList'];
        tempFollowerList = result['pFollowerList'];
        FollowerList.forEach((item) => _companies .add(CompanyWidget(item['id'], item['first_name'])));
        categoryList = result['pCategoryDatas'];
        projectList = result['pProjectDatas'];
        CreateddateController.text = todayDate;
        DuedateController.text = todayDate;
        _isLoading = false;
      });
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

  Future taskSave(String name,String Details,String StartDate,String EndDate,int assignedby,int assignedto,int category,int project,int prority,List _selected_followers) async {
    setState(() {
      _isLoading = true;
    });
    int orgId = await Network().GetActiveOrg();

    var data = {'pName' : name,'pDetails':Details,'pStartDate':StartDate,'pEndDate':EndDate,'pAssignedBy':assignedby,'pAssignedTo':assignedto,'pCategoryId':category,'pProjectId':project,'pProrityId':prority,'pFollower':_selected_followers,'orgId':orgId};

    var res = await Network().postMethodWithToken(data, '/taskStore');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                index:3, page:"Add"
              )));
    }else if(body['status'] == 0){
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "this Task name is already exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey,
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
              // color: Colors.blue,
            ),
          ),
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(title: Text("Add Task",style: TextStyle(color: Colors.white),),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
            Navigator.of(context).pop();
          },),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left:15,right: 15),
                  child: TextField(
                    // autofocus: true,
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
                    // maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Key in Work or to do task",
                      labelText: "Task",
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(fontSize: 14.0),
                      errorText: _valName ? "Name is required":null,
                    ),
                    controller: Name,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:15,right: 15),
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Enter the Task Details",
                      labelText: "Task Details",
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintStyle: TextStyle(fontSize: 14.0),
                    ),
                    controller: Details,
                  ),

                ),
                Container(
                    padding: EdgeInsets.only(left:15,right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child:TextField(
                            readOnly: true,
                            controller: CreateddateController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'Created Date',
                                labelStyle: TextStyle(fontSize: 14.0),
                                hintStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(Icons.calendar_today_rounded,size: 18.0)
                            ),
                            onTap: () async {
                              // final DateTime now = DateTime.now();
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              var date =  await showDatePicker(
                                  context: context,
                                  initialDate:DateTime.now(),
                                  firstDate:DateTime(1900),
                                  lastDate: DateTime(2100)
                              );
                              CreateddateController.text = date.toString().substring(0,10);
                            },),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Flexible(
                          child:TextField(
                            readOnly: true,
                            controller: DuedateController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                hintText: 'Pick Date',
                                labelText: 'Due Date',
                                labelStyle: TextStyle(fontSize: 14.0),
                                hintStyle: TextStyle(fontSize: 14.0),
                                suffixIcon: Icon(Icons.calendar_today_rounded,size: 18.0)
                            ),
                            onTap: () async {
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              var date =  await showDatePicker(
                                  context: context,
                                  initialDate:DateTime.now(),
                                  firstDate:DateTime(1900),
                                  lastDate: DateTime(2100));
                              DuedateController.text = date.toString().substring(0,10);

                              if(ProjEndDate != null){
                                // var startDate = ProjEndDate;
                                // var EndDate = DuedateController.text;
                                if(DuedateController.text.compareTo(ProjEndDate) > 0)
                                {
                                  Fluttertoast.showToast(

                                      msg: "Date Exceeds the Project Due date",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      // timeInSecForIos: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.black
                                  );
                                  setState(() {
                                    DuedateController.text = ProjEndDate;
                                  });
                                }
                              }

                              var startDate = CreateddateController.text;
                              var EndDate = DuedateController.text;
                              if(EndDate.compareTo(startDate) < 0)
                              {
                                Fluttertoast.showToast(

                                    msg: "Start Date should not be greater than End Date",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    // timeInSecForIos: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.black
                                );
                                setState(() {
                                  DuedateController.text = ProjEndDate != null?ProjEndDate:"";
                                });
                              }

                            },),
                        ),
                      ],
                    )
                ),
                Container(
                  // padding: EdgeInsets.only(left:15,right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                value: Assignedbyemployee,
                                hint: Text('Assigned By'),
                                items: AssignedbyList?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['person']['first_name']),
                                    value: item['person']['id'],
                                  );
                                })?.toList() ?? [],

                                onChanged: (newValue) {
                                  setState(() {
                                    Assignedbyemployee = newValue;
                                    _companies = [];
                                    tempFollowerList.forEach((item) => _companies .add(CompanyWidget(item['id'], item['first_name'])));
                                    _companies.removeWhere((item) => item.id == Assignedbyemployee);
                                    _companies.removeWhere((item) => item.id == Assignedtoemployee);
                                    // FollowerList.removeWhere((item) => int.parse(item['person_id']) == Assignedbyemployee);
                                    if(_selected_followers != null){
                                      _selected_followers.clear();
                                    }
                                    // selectedfollower.clear();
                                    // Assignedbychg(Assignedbyemployee);
                                    // FollowerList.removeWhere((item) => item['id'] == Assignedbyemployee);

                                  });
                                },
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 20.09,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                value: Assignedtoemployee,
                                hint: Text('Assigned To'),
                                items: AssignedtoList?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['person']['first_name']),
                                    value: item['person']['id'],
                                  );
                                })?.toList() ??
                                    [],
                                onChanged: (newValue) {
                                  setState(() {

                                    Assignedtoemployee = newValue;
                                    _companies = [];
                                    tempFollowerList.forEach((item) => _companies .add(CompanyWidget(item['id'], item['first_name'])));
                                    _companies.removeWhere((item) => item.id == Assignedtoemployee);
                                    _companies.removeWhere((item) => item.id == Assignedbyemployee);
                                    if(_selected_followers != null){
                                      _selected_followers.clear();
                                    }

                                    // FollowerList = tempFollowerList;
                                    // FollowerList.removeWhere((item) => int.parse(item['person_id']) == Assignedtoemployee);

                                    // FollowerList.removeWhere((item) => item['id'] == Assignedtoemployee);



                                  });
                                },
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 20.09,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.only(left:15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Expanded(
                            child: Text(Category,style: TextStyle(fontSize: 16.0,
                          color: Colors.grey
                      ),),
                          ),
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  value: seletedproject,
                                  hint: Text('Unassigned Proj'),
                                  items: projectList?.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['name'].toString()),
                                      value: item['id'],
                                    );
                                  })?.toList() ?? [],
                                  onChanged: (newValue) {
                                    setState(() {
                                      seletedproject = newValue;
                                    });
                                    _ProjBasedCate(seletedproject);
                                  },
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),

                ),
                Container(
                  padding: EdgeInsets.only(left:15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Priority",style: TextStyle(
                          color: Colors.grey
                      ),),
                      Radio(value: 1, groupValue: prorityid, onChanged: _handleRadioValueChange),
                      Tooltip(
                        message: "Low",
                        child: Transform.rotate(
                          angle: 270 * pi/180, //set the angel
                          child: Icon(Icons.double_arrow,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Radio(value: 2, groupValue: prorityid, onChanged: _handleRadioValueChange),
                      Tooltip(
                        message: "Normal",
                        child: Transform.rotate(
                          angle: 270 * pi/180, //set the angel
                          child: Icon(Icons.double_arrow,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Radio(value: 3, groupValue: prorityid, onChanged: _handleRadioValueChange),
                      Tooltip(
                        message: "Medium",
                        child: Transform.rotate(
                          angle: 270 * pi/180, //set the angel
                          child: Icon(Icons.double_arrow,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Radio(value: 4, groupValue: prorityid, onChanged: _handleRadioValueChange),
                      Tooltip(
                        message: "High",
                        child: Transform.rotate(
                          angle: 270 * pi/180, //set the angel
                          child: Icon(Icons.double_arrow,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // temporry hide by Ajith
                Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: MultiSelectBottomSheetField(
                    initialValue: _selected_followers,
                    initialChildSize: 0.7,
                    maxChildSize: 0.95,
                    title: Text("Select Followers"),
                    buttonText: Text("Followers"),
                    items:  _companies.map((item) =>
                        MultiSelectItem(item.id, item.name)).toList(),
                    searchable: true,
                    onConfirm: (values) {
                      setState(() {
                        _selected_followers = values;
                      });
                    },

                  ),
                ),

              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: <Widget>[
                      Text('Cancel',style: TextStyle(color: Colors.white,),),
                      // Icon(Icons.close,color: Colors.white),
                    ],
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
              ),
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
                    setState(() {
                      seletedcategory = null;
                      seletedproject = null;
                      // Assignedtoemployee = null;
                      _selected_followers.clear();
                    });
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
                      // Icon(Icons.save,color: Colors.white),
                    ],
                  ),
                    // onPressed:
                    // Name.text.isEmpty?null:
                    //     (){
                    // print(Name.text);
                    // },
                  // onPressed: (){

                    // setState(() {
                    //   Name.text.isEmpty?_valName = true:_valName = false;
                    //   if(_valName == false){
                    //     taskSave(Name.text,Details.text,CreateddateController.text,DuedateController.text,Assignedbyemployee,Assignedtoemployee,seletedcategory,seletedproject,prorityid,_selected_followers);
                    //   }
                    // });
                  // }
                onPressed:isButtonEnabled?(){
                  setState(() {
                    Name.text.isEmpty?_valName = true:_valName = false;
                    if(_valName == false){
                      taskSave(Name.text,Details.text,CreateddateController.text,DuedateController.text,Assignedbyemployee,Assignedtoemployee,seletedcategory,seletedproject,prorityid,_selected_followers);
                    }
                  });
                  // taskSave(Name.text,Details.text,CreateddateController.text,DuedateController.text,Assignedbyemployee,Assignedtoemployee,seletedcategory,seletedproject,prorityid,_selected_followers);
                }:null,
              ),
            ],
          ),
        ),
      );
    }

  }
}

