import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:propel/wfm/task/task_details.dart';
import 'package:propel/network_utils/api.dart';
import 'dart:convert';
import 'package:propel/models/chat_users.dart';
import 'package:propel/components/chat.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bottom_loader/bottom_loader.dart';



class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {

  String Category;
  String Project;
  String AssignedTo;
  int selected;
  BottomLoader bl;
  int seletedactions;
  Future myFuture;
  int seletedOrg;
  int OrganizationId;
  bool unAssignedcategory;
  bool unAssignedProject;
  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }
  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }


  get_orgId() async{
    final prefs = await SharedPreferences.getInstance();
    seletedOrg = prefs.getInt('orgid') ?? 0;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var Data = jsonDecode(localStorage.getString('allData'));
    if(seletedOrg == 0){
      OrganizationId = Data['firstOrg'];
    }else{
      OrganizationId = seletedOrg;
    }
    return OrganizationId;
  }


  Future<List> taskData() async {
    final orgId = await get_orgId();
    final prefs = await SharedPreferences.getInstance();
    unAssignedcategory = prefs.getBool('unAssignedcategory') == null?true:prefs.getBool('unAssignedcategory');
    unAssignedProject = prefs.getBool('unAssignedproject') == null?true:prefs.getBool('unAssignedproject');
    var res = await Network().getMethodWithToken('/Dashboard/$orgId');

    var body = json.decode(res.body);
    return [];
    // if(body['status'] == 1){
    //   var result = body['data'];
    //   return result;
    // }
  }

  Future<List> action_changed(int actionId,int statusId,int taskId) async {
    bl = new BottomLoader(
      context,
      showLogs: true,
      isDismissible: true,
    );
    bl.style(
      message: 'Please wait...',
    );
    bl.display();
    var data = {'taskId' : taskId,'actionId':actionId,'statusId':statusId};
    var res = await Network().postMethodWithToken(data, '/taskAction');
    var body = json.decode(res.body);
    if(body['status'] == 1){
      Fluttertoast.showToast(

          msg: "Status has been Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black
      );
    setState(() {
      myFuture = taskData();
    });
      bl.close();
    }

  }
  void myScroll() async {

    // _scrollBottomBarController.addListener(() {
    //   if (_scrollBottomBarController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     if (!isScrollingDown) {
    //       isScrollingDown = true;
    //       _showAppbar = false;
    //       hideBottomBar();
    //     }
    //   }
    //   if (_scrollBottomBarController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     if (isScrollingDown) {
    //       isScrollingDown = false;
    //       _showAppbar = true;
    //       showBottomBar();
    //     }
    //   }
    // });
  }
  @override
  void initState() {
    myFuture = taskData();
    myScroll();
    super.initState();
  }
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
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
                  child: Center(
                      child:Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("To Add Task, tap",style: TextStyle(fontSize: 15.0),),
                          Icon(Icons.post_add_rounded,color: Colors.grey,),
                          Text("at the bottom of your screen.",style: TextStyle(fontSize: 15.0),),
                        ],
                                    ),
                  ),
                );
              }else {
                return Scaffold(
                  body: SingleChildScrollView(
                    child: GestureDetector(
                      // onTap: () {
                      //
                      //   Navigator.of(context).push(
                      //       MaterialPageRoute(builder: (context) =>
                      //           TaskDetails(
                      //               id: snapshot.data[i]['pStartDate']
                      //           )));
                      //
                      // },
                      child: Container(
                        padding: EdgeInsets.only(top: 05, right: 05),
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                              controller: _scrollBottomBarController,
                              key: Key('builder ${selected.toString()}'),
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              // padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {


                                var now = new DateTime.now();
                                var formatter = new DateFormat('yyyy-MM-dd');
                                final todayDate = formatter.format(now);


                                String Date = snapshot.data[i]['pStartDate']+'  to  '+snapshot.data[i]['pEndDate'];
                                final StartingDate = DateTime.parse(snapshot.data[i]['pEndDate']);
                                final EndDate = DateTime.parse(todayDate);
                                final difference = int.parse(StartingDate.difference(EndDate).inDays.toString());
                                int expiredDays = difference.abs();
                                String DateDifference = (difference > 0)?'$difference days leftover':
                                                         difference == 0 ?'Due on Today'
                                                             :'$expiredDays days Overdue';



                                if (snapshot.data[i]['pCategoryVO']['pId'] != ''){
                                  Category = snapshot.data[i]['pCategoryVO']['pName'];
                                } else {
                                  Category = "UnAssigned";
                                }

                                if (snapshot.data[i]['pProjectVO']['pId'] != ''){
                                  Project = snapshot.data[i]['pProjectVO']['pName'];
                                } else {
                                  Project = "UnAssigned";
                                }

                                // if (snapshot.data[i]['pTaskWorkforceVO']){
                                  AssignedTo = snapshot.data[i]['pTaskWorkforceVO']['pFirstName'];
                                // }

                                // return new Text(differenceInYears + ' years');
                                return ExpansionTile(
                                  // initiallyExpanded: true,
                                  key: Key(i.toString()),
                                  initiallyExpanded : i==selected,
                                  leading: (snapshot
                                      .data[i]['pTaskStatusVO']["pId"] == 1)
                                      ?
                                  Icon(Icons.playlist_play, color: Colors.blue,)
                                      :
                                  snapshot.data[i]['pTaskStatusVO']["pId"] == 2
                                      ?
                                  Icon(
                                    Icons.directions_run, color: Colors.blue,)
                                      :
                                  snapshot.data[i]['pTaskStatusVO']["pId"] == 3
                                      ?
                                  Icon(Icons.anchor, color: Colors.blueGrey,)
                                      :
                                  snapshot.data[i]['pTaskStatusVO']["pId"] == 5
                                      ?
                                  Icon(Icons.stop, color: Colors.black,)
                                      :
                                  snapshot.data[i]['pTaskStatusVO']["pId"] == 4
                                      ?
                                  Icon(Icons.done, color: Colors.green,)
                                      :
                                  snapshot.data[i]['pTaskStatusVO']["pId"] == 7
                                      ?
                                  Icon(Icons.thumb_up,
                                    color: Colors.lightGreen[900],)
                                      :
                                  snapshot.data[i]['pTaskStatusVO']["pId"] == 6
                                      ?
                                  Icon(
                                    Icons.thumb_down, color: Colors.red[700],)
                                      :
                                  Icon(Icons.playlist_play, color: Colors.red,),
                                  title: Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.rotate(
                                        angle: 270 * pi / 180, //set the angel
                                        child: Icon(Icons.double_arrow,
                                          color: (snapshot
                                              .data[i]['pPriorityVO']["pId"] ==
                                              1) ? Colors.black :
                                          snapshot
                                              .data[i]['pPriorityVO']["pId"] ==
                                              2 ? Colors.blue :
                                          snapshot
                                              .data[i]['pPriorityVO']["pId"] ==
                                              3 ? Colors.green :
                                          snapshot
                                              .data[i]['pPriorityVO']["pId"] ==
                                              4 ? Colors.red : Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 05,
                                      ),
                                      Expanded(
                                        child: Text(
                                          snapshot.data[i]['pName'],
                                          style: TextStyle(fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // trailing: Container(
                                  //     child: CircleAvatar(
                                  //       backgroundColor: Colors.green,
                                  //       // child: Text("1"),
                                  //       maxRadius: 05,
                                  //     )
                                  // ),
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){

                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) =>
                                                TaskDetails(
                                                    id: snapshot.data[i]['pId']
                                                )));
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 05),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [

                                                // SizedBox(
                                                //   width: 05
                                                // ),
                                                Column(
                                                  children: [
                                                    // Container(
                                                    //   // margin: EdgeInsets.all(10),
                                                    //   padding: EdgeInsets.only(top: 05,bottom: 05),
                                                    //   alignment: Alignment.center,
                                                    //   decoration: BoxDecoration(
                                                    //       color: Colors.grey,
                                                    //       // border: Border.all(
                                                    //       //     // color: Colors.pink[800],// set border color
                                                    //       //     width: 3.0),   // set border width
                                                    //       borderRadius: BorderRadius.all(
                                                    //           Radius.circular(10.0)), // set rounded corner radius
                                                    //       // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]// make rounded corner of border
                                                    //   ),
                                                    //   child: Text("21 jan 2021 to 24 jan 2021",style: TextStyle(fontWeight: FontWeight.bold,),),
                                                    // ),

                                                    Text(Date,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blue),),
                                                  ],
                                                ),
                                                SizedBox(
                                                    width: 15
                                                ),
                                                Column(
                                                  children: [
                                                    // Icon(Icons.calendar_today_rounded, color: Colors.blueGrey,),
                                                    Container(
                                                        child:
                                                        Text(
                                                            DateDifference,
                                                            style: TextStyle(fontWeight: FontWeight.bold,
                                                              color: difference>0?Colors.green:difference == 0?Colors.orange:Colors.red,)
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 05),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    // Text((snapshot.data[i]['pCategoryVO'] != false)?"Category: "+snapshot.data[i]['pCategoryVO']['pName']:"Category:  Unassigned",
                                                    //   style: TextStyle(
                                                    //       fontWeight: FontWeight
                                                    //           .bold),),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Category :',
                                                        style: TextStyle(
                                                          color: Colors.grey,),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: '$Category',
                                                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    width: 05
                                                ),
                                                Column(
                                                  children: [
                                                    // Text((snapshot.data[i]['pProjectVO'] != false)?"Project: "+snapshot.data[i]['pProjectVO']['pName']:"Project: Unassigned",
                                                    //   style: TextStyle(
                                                    //       fontWeight: FontWeight
                                                    //           .bold),),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Project :',
                                                        style: TextStyle(
                                                          color: Colors.grey,),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: '$Project',
                                                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 00,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 05),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    // Text.rich(
                                                    //   child: Text("Assigned to: "+snapshot
                                                    //       .data[i]['pTaskWorkforceVO']['pFirstName'],
                                                    //     style: TextStyle(
                                                    //         fontWeight: FontWeight
                                                    //             .bold),),
                                                    // ),
                                                    // Text("Assigned To: "+snapshot
                                                    //   .data[i]['pTaskWorkforceVO']['pFirstName'],
                                                    // style: TextStyle(
                                                    //       fontWeight: FontWeight
                                                    //   .bold),),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Assigned To :',
                                                        style: TextStyle(
                                                          color: Colors.grey,),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: '$AssignedTo',
                                                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // Column(
                                                //   children: [
                                                //     Text("Progress Action to",
                                                //       style: TextStyle(
                                                //           fontWeight: FontWeight
                                                //               .bold),),
                                                //   ],
                                                // ),
                                                Column(
                                                  children: [
                                                    // DropdownButton<String>(
                                                    //   hint: Text('Select Actions'),
                                                    //   value: dropdownValue,
                                                    //   items: <String>['Foo', 'Bar'].map((String value) {
                                                    //   return new DropdownMenuItem<String>(
                                                    //     value: value,
                                                    //     child: new Text(value),
                                                    //   );
                                                    //   }).toList(),
                                                    //   onChanged: (newValue) {
                                                    //         //   setState(() {
                                                    //         //     seletedcategory = newValue;
                                                    //         //     _cateBasedProj(seletedcategory);
                                                    //         //   });
                                                    //         },
                                                    // ),
                                                    DropdownButtonHideUnderline(
                                                      child: ButtonTheme(
                                                        alignedDropdown: true,
                                                        child: DropdownButton(
                                                          // value: seletedactions,
                                                          // icon: Icon(
                                                          //   Icons.account_tree,
                                                          //   color: Colors.grey,
                                                          //   size: 20.09,
                                                          // ),
                                                          // iconSize: 30,
                                                          // icon: (null),
                                                          // style: TextStyle(
                                                          //   color: Colors.black54,
                                                          //   fontSize: 16,
                                                          // ),
                                                          hint: Text('Select Actions'),
                                                          items: snapshot.data[i]['pTaskActionListVo'].map<DropdownMenuItem>((value) {
                                                            return DropdownMenuItem(
                                                              value: value['task_action']['id'],
                                                              child: Text(value['task_action']['name'].toString()),
                                                            );
                                                          }).toList(),
                                                          // items: snapshot.data[i]['pTaskActionListVo']?.map((item) {
                                                          //
                                                          //   return DropdownMenuItem(
                                                          //     child: new Text(item['task_action']['name'].toString()),
                                                          //     value: item['task_action']['id'].toString(),
                                                          //   );
                                                          // })?.toList() ?? [],
                                                          // onChanged: (newValue) {
                                                          //   setState(() {
                                                          //     seletedactions = newValue;
                                                          //   });
                                                          // },
                                                          onChanged: (newValue) => action_changed(newValue,snapshot.data[i]['pTaskStatusVO']["pId"],snapshot.data[i]['pId']),
                                                        ),
                                                      ),
                                                    )
                                                    // DropdownButton<String>(
                                                    //   // icon: Icon(
                                                    //   //   Icons.accessibility_sharp,
                                                    //   //   color: Colors.grey,
                                                    //   //   size: 20.09,
                                                    //   // ),
                                                    //   value: dropdownValue,
                                                    //   underline: Container(),
                                                    //   items: <String>['One', 'Two', 'Free', 'Four']
                                                    //       .map<DropdownMenuItem<String>>((String value) {
                                                    //     return DropdownMenuItem<String>(
                                                    //       value: value,
                                                    //       child: Text(value),
                                                    //     );
                                                    //   })
                                                    //       .toList(),
                                                    //   onChanged: (value) {
                                                    //     // setState(() {
                                                    //     //   dropdownValue = value;
                                                    //     // });
                                                    //   },
                                                    // )
                                                    // DropdownButtonHideUnderline(
                                                    //   child: ButtonTheme(
                                                    //     alignedDropdown: true,
                                                    //     child: DropdownButton(
                                                    //       value: dropdownValue,
                                                    //       // icon: Icon(
                                                    //       //   Icons.account_tree,
                                                    //       //   color: Colors.grey,
                                                    //       //   size: 20.09,
                                                    //       // ),
                                                    //       // iconSize: 30,
                                                    //       // icon: (null),
                                                    //       // style: TextStyle(
                                                    //       //   color: Colors.black54,
                                                    //       //   fontSize: 16,
                                                    //       // ),
                                                    //       hint: Text('Select Actions'),
                                                    //       items: [
                                                    //
                                                    //       ],
                                                    //       // items: ActionList?.map((item) {
                                                    //       //
                                                    //       //     return new DropdownMenuItem(
                                                    //       //       child: new Text(item['task_action']['name'].toString()),
                                                    //       //       value: item['task_action']['id'],
                                                    //       //     );
                                                    //       //   })?.toList() ?? [],
                                                    //       // onChanged: (newValue) {
                                                    //       //   setState(() {
                                                    //       //     seletedcategory = newValue;
                                                    //       //     _cateBasedProj(seletedcategory);
                                                    //       //   });
                                                    //       // },
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                  onExpansionChanged: ((newState){
                                    if(newState)
                                      setState(() {
                                        Duration(seconds:  20000);
                                        selected = i;
                                      });
                                    else setState(() {
                                      selected = -1;
                                    });
                                  }),
                                  // onExpansionChanged: ((newState){
                                  //
                                  //   if(newState) {
                                  //     // setState(() {
                                  //     Duration(seconds: 20000);
                                  //     selected = i;
                                  //     print(i);
                                  //   }
                                  //     // });
                                  //   else {
                                  //   // setState(() {
                                  //   selected = -1;
                                  //   }
                                  //   // });
                                  // }),


                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            } else{
              return Scaffold(
                body: Container(
                  child: Center(
                    child: AwesomeLoader(
                      loaderType: AwesomeLoader.AwesomeLoader3,
                      // color: Colors.orange,
                    ),
                  ),
                ),
              );
            }

          }
          ),
    );
  }
}
