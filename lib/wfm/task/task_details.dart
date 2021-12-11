import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:convert';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:bottom_loader/bottom_loader.dart';

class TaskDetails extends StatefulWidget {
  final int id;
  const TaskDetails({Key key,this.id}) : super(key: key);
  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class CompanyWidget {
  const CompanyWidget(this.id,this.name);
  final String name;
  final int id;
}

class _TaskDetailsState extends State<TaskDetails> {

    String taskname;
    String taskdetails;
    bool taskdetailvalidate= true;
    bool loader;
    String timeline;
    String DateDifference;
    int datediffcolor;
    String Assignedby;
    String Assignedto;
    String Category;
    String Project;
    int taskstatusid;
    int taskprorityid;
    List actionlist;
    Future myFuture;
    BottomLoader bl;

    List<CompanyWidget> _companies = [];
    List<int> _filters = [];



    Future<List> follower_update(value) async {

      bl = new BottomLoader(
        context,
        showLogs: true,
        isDismissible: true,
      );
      bl.style(
        message: 'Please wait...',
      );
      bl.display();

        var data = {'task_id':widget.id,'follower_id':value};
        print(data);
        var res = await Network().postMethodWithToken(data, '/taskfollowerupdate');
        Fluttertoast.showToast(

            msg: "Follower has been Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey[200],
            textColor: Colors.black
        );
        myFuture = taskDetails();
        bl.close();

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
        myFuture = taskDetails();
  bl.close();
        // setState(() {
        //   myFuture = taskData();
        // });

      }

    }

    Widget taskstatus(id){
      return (id == 1)
          ?
      Icon(Icons.playlist_play, color: Colors.blue,)
          :
      id == 2
          ?
      Icon(
        Icons.directions_run, color: Colors.blue,)
          :
      id == 3
          ?
      Icon(Icons.anchor, color: Colors.blueGrey,)
          :
      id == 5
          ?
      Icon(Icons.stop, color: Colors.black,)
          :
      id == 4
          ?
      Icon(Icons.done, color: Colors.green,)
          :
      id == 7
          ?
      Icon(Icons.thumb_up,
        color: Colors.lightGreen[900],)
          :
      id == 6
          ?
      Icon(
        Icons.thumb_down, color: Colors.red[700],)
          :
      Icon(Icons.playlist_play, color: Colors.red,);

    }

    Widget taskprority(id){
      return Transform.rotate(
        angle: 270 * pi / 180, //set the angel
        child: Icon(Icons.double_arrow,
          color: (id ==
              1) ? Colors.black :
          id ==
              2 ? Colors.blue :
          id ==
              3 ? Colors.green :
          id ==
              4 ? Colors.red : Colors.grey,
        ),
      );
    }

    Future taskDetails() async {
     setState(() {
       loader = true;
     });
     int taskid = widget.id;
     var res = await Network().getMethodWithToken('/taskDetails/$taskid');
     var body = json.decode(res.body);
     if(body['status'] == "SUCCESS"){
       var result = body['data'];
       return result;


        // setState(() {
        //   taskname = result['pName'];
        //   taskdetails = result['pDetails'];
        //   taskdetailvalidate = result['pDetails'] != ""?true:false;
        //   Category = result['pCategoryVO'].runtimeType == bool?"":result['pCategoryVO']['pName'];
        //   Project = result['pProjectVO'].runtimeType == bool?"":result['pProjectVO']['pName'];
        //   Assignedto = result['pTaskWorkforceVO']['pFirstName'];
        //   var now = new DateTime.now();
        //   var formatter = new DateFormat('yyyy-MM-dd');
        //   final todayDate = formatter.format(now);
        //   timeline = result['pStartDate']+'  to  '+result['pEndDate'];
        //   final StartingDate = DateTime.parse(result['pEndDate']);
        //   final EndDate = DateTime.parse(todayDate);
        //   final difference = int.parse(StartingDate.difference(EndDate).inDays.toString());
        //   datediffcolor = difference;
        //   int expiredDays = difference.abs();
        //   DateDifference = (difference > 0)?'$difference days leftover':
        //   difference == 0 ?'Due on Today'
        //       :'$expiredDays days Overdue';
        //   taskstatusid = result['pTaskStatusVO']['pId'];
        //   taskprorityid = result['pPriorityVO']["pId"];
        //   actionlist = result['pTaskActionListVo'];
        //   // print(result['pEmployeeVO']);
        //   result['pEmployeeVO'].forEach((item) => _companies .add(CompanyWidget(item['id'], item['first_name'])));
        //   result['pTaskFollowerVO'].forEach((item) => _filters .add(item['pId']));
        //   loader = false;
        // });

     }
   }

  @override

  void initState() {
    super.initState();

    myFuture = taskDetails();


  }
  Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: Text("Ado unbox",style: TextStyle(color: Colors.white),),
           leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
             Navigator.of(context).pop();
           },),
         ),
         body:new FutureBuilder(

             future: myFuture,
             builder: (context,snapshot){
               if(snapshot.hasError){
                 print('Error in Loading'+snapshot.error.toString());
               }
              if(snapshot.hasData){

                var now = new DateTime.now();
                var formatter = new DateFormat('yyyy-MM-dd');
                final todayDate = formatter.format(now);
                timeline = snapshot.data['pStartDate']+'  to  '+snapshot.data['pEndDate'];
                final StartingDate = DateTime.parse(snapshot.data['pEndDate']);
                final EndDate = DateTime.parse(todayDate);
                final difference = int.parse(StartingDate.difference(EndDate).inDays.toString());
                datediffcolor = difference;
                int expiredDays = difference.abs();
                DateDifference = (difference > 0)?'$difference days leftover':
                difference == 0 ?'Due on Today'
                    :'$expiredDays days Overdue';
                Category = snapshot.data['pCategoryVO'].runtimeType == bool?"":snapshot.data['pCategoryVO']['pName'];
                Project = snapshot.data['pProjectVO'].runtimeType == bool?"":snapshot.data['pProjectVO']['pName'];
                Assignedto = snapshot.data['pTaskWorkforceVO']['pFirstName'];
                actionlist = snapshot.data['pTaskActionListVo'];
                _companies = [];
                snapshot.data['pEmployeeVO'].forEach((item) => _companies .add(CompanyWidget(item['person']['id'], item['person']['first_name'])));
                _filters = [];
                snapshot.data['pTaskFollowerVO'].forEach((item) => _filters .add(item['pId']));
                _companies.removeWhere((item) => item.id == snapshot.data['pTaskWorkforceVO']['pId']);
                _companies.removeWhere((item) => item.id == snapshot.data['pTaskCreatorVO']['pId']);
                // _filters.clear();
                return Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(05.0),
                        child: Row(
                          children: [
                            taskstatus(snapshot.data['pTaskStatusVO']['pId']),
                            SizedBox(width: 02.0,),
                            taskprority(snapshot.data['pPriorityVO']['pId']),
                            SizedBox(width: 02.0,),
                            Text(snapshot.data['pName'].toString())
                          ],
                        ),
                      ),
                      Visibility(
                        visible: snapshot.data['pDetails']!= ""?true:false,
                        child: Container(
                          padding: EdgeInsets.all(05.0),
                          child: Row(
                            children: [
                              Text(snapshot.data['pDetails'])
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(05.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timeline,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),),
                            Text(
                                DateDifference,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                  color: datediffcolor>0?Colors.green:datediffcolor == 0?Colors.orange:Colors.red,)
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(05.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Assigned To :',
                                  style: TextStyle(
                                    color: Colors.grey,),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '$Assignedto',
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Category:',
                                  style: TextStyle(
                                    color: Colors.grey,),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '$Category',
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: RichText(
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
                            ),
                          ],
                        ),
                      ),
                      ExpansionTile(
                        title: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            minWidth: 10.0,
                            alignedDropdown: true,
                            child: DropdownButton(
                              // icon: Icon(
                              //   Icons.pending_actions_outlined,
                              //   color: Colors.grey,
                              //   size: 20.09,
                              // ),
                              hint: Text('Select Actions'),
                              items: actionlist.map<DropdownMenuItem>((value) {
                                return DropdownMenuItem(
                                  value: value['task_action']['id'],
                                  child: Text(value['task_action']['name'].toString()),
                                );
                              }).toList(),
                              onChanged: (newValue) => action_changed(newValue,snapshot.data['pTaskStatusVO']['pId'],widget.id),
                            ),
                          ),
                        ),
                        children: [
                          Container(

                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: MultiSelectBottomSheetField(
                              initialValue: _filters,
                              initialChildSize: 0.7,
                              maxChildSize: 0.95,
                              title: Text("Select Followers"),
                              buttonText: Text("Followers"),
                              items:  _companies.map((animal) => MultiSelectItem(animal.id, animal.name)).toList(),
                              searchable: true,
                              // onConfirm: (values) {
                              //   setState(() {
                              //     // _filters.clear();
                              //     _filters = values;
                              //   });
                              //
                              // },
                              onConfirm: (newValue) => follower_update(newValue),
                              // chipDisplay: MultiSelectChipDisplay(
                              //   onTap: (item) {
                              //     setState(() {
                              //       _selectedAnimals3.remove(item);
                              //     });
                              //     _multiSelectKey.currentState.validate();
                              //   },
                              // ),
                            ),
                          ),
                          // SingleChildScrollView(
                          //   physics: BouncingScrollPhysics(),
                          //   scrollDirection: Axis.horizontal,
                          //   child: Wrap(
                          //     children: companyPosition.toList(),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                );
              }else{
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

         // body: Container(
         //   child: Column(
         //     children: [
         //       Container(
         //         padding: EdgeInsets.all(05.0),
         //         child: Row(
         //           children: [
         //               Icon(Icons.thumb_up,
         //               color: Colors.lightGreen[900],),
         //               SizedBox(width: 02.0,),
         //               Transform.rotate(
         //               angle: 270 * pi / 180, //set the angel
         //               child: Icon(Icons.double_arrow,
         //
         //               ),
         //             ),
         //               SizedBox(width: 02.0,),
         //               Text("Task Name")
         //           ],
         //         ),
         //       ),
         //       Container(
         //         padding: EdgeInsets.all(05.0),
         //         child: Row(
         //           children: [
         //               Text("Task Detail")
         //           ],
         //         ),
         //       ),
         //       Container(
         //         padding: EdgeInsets.all(05.0),
         //         child: Row(
         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
         //           children: [
         //             Text("21-06-2021 to 22-06-2021",
         //               style: TextStyle(
         //                   fontWeight: FontWeight.bold,
         //                   color: Colors.blue),),
         //             Text(
         //                 "2 Days Left",
         //                 style: TextStyle(fontWeight: FontWeight.bold,
         //                   color: Colors.grey,)
         //             ),
         //           ],
         //         ),
         //       ),
         //       Container(
         //         padding: EdgeInsets.all(05.0),
         //         child: Row(
         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
         //           children: [
         //             Flexible(
         //               child: RichText(
         //                 text: TextSpan(
         //                   text: 'Assigned To :',
         //                   style: TextStyle(
         //                     color: Colors.grey,),
         //                   children: <TextSpan>[
         //                     TextSpan(
         //                         text: 'Ajithshdfsdhf',
         //                         style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
         //                   ],
         //                 ),
         //               ),
         //             ),
         //             Flexible(
         //               child: RichText(
         //                 text: TextSpan(
         //                   text: 'Category:',
         //                   style: TextStyle(
         //                     color: Colors.grey,),
         //                   children: <TextSpan>[
         //                     TextSpan(
         //                         text: 'Mecdfhdbfdfdh',
         //                         style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
         //                   ],
         //                 ),
         //               ),
         //             ),
         //             Flexible(
         //               child: RichText(
         //                 text: TextSpan(
         //                   text: 'Project :',
         //                   style: TextStyle(
         //                     color: Colors.grey,),
         //                   children: <TextSpan>[
         //                     TextSpan(
         //                         text: 'Reanjdfdfch',
         //                         style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
         //                   ],
         //                 ),
         //               ),
         //             ),
         //           ],
         //         ),
         //       ),
         //       // Container(
         //       //   padding: EdgeInsets.all(05.0),
         //       //   child: Row(
         //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
         //       //     children: [
         //       //       RichText(
         //       //         text: TextSpan(
         //       //           text: 'Assigned To :',
         //       //           style: TextStyle(
         //       //             color: Colors.grey,),
         //       //           children: <TextSpan>[
         //       //             TextSpan(
         //       //                 text: 'Ajith',
         //       //                 style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
         //       //           ],
         //       //         ),
         //       //       ),
         //       //       DropdownButtonHideUnderline(
         //       //         child: ButtonTheme(
         //       //           alignedDropdown: true,
         //       //           child: DropdownButton(
         //       //             hint: Text('Select Actions'),
         //       //             items: selectActions.map<DropdownMenuItem>((value) {
         //       //               return DropdownMenuItem(
         //       //                 value: value['id'],
         //       //                 child: Text(value['name']),
         //       //               );
         //       //             }).toList(),
         //       //             onChanged: (newValue) => {}
         //       //           ),
         //       //         ),
         //       //       )
         //       //     ],
         //       //   ),
         //       // ),
         //       ExpansionTile(
         //         title: DropdownButtonHideUnderline(
         //           child: ButtonTheme(
         //             alignedDropdown: true,
         //             child: DropdownButton(
         //                 icon: Icon(
         //                   Icons.pending_actions_outlined,
         //                   color: Colors.grey,
         //                   size: 20.09,
         //                 ),
         //                 hint: Text('Select Actions'),
         //                 items: selectActions.map<DropdownMenuItem>((value) {
         //                   return DropdownMenuItem(
         //                     value: value['id'],
         //                     child: Text(value['name']),
         //                   );
         //                 }).toList(),
         //                 onChanged: (newValue) => {}
         //
         //             ),
         //           ),
         //         ),
         //         children: [
         //           SingleChildScrollView(
         //             physics: BouncingScrollPhysics(),
         //             scrollDirection: Axis.horizontal,
         //             child: Wrap(
         //               children: companyPosition.toList(),
         //             ),
         //           ),
         //         ],
         //       ),
         //       // Container(
         //       //     padding: EdgeInsets.only(left:05,right: 10),
         //       //
         //       //     child: MultiSelectFormField(
         //       //       autovalidate: false,
         //       //       chipBackGroundColor: Colors.blue,
         //       //       chipLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
         //       //       // dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
         //       //       // checkBoxActiveColor: Colors.blue,
         //       //       // checkBoxCheckColor: Colors.white,
         //       //       // FollowerList.removeWhere((item) => item['id'] == Assignedbyemployee);
         //       //
         //       //       dialogShapeBorder: RoundedRectangleBorder(
         //       //
         //       //           borderRadius: BorderRadius.all(Radius.circular(12.0))),
         //       //           title: Text(
         //       //         "Followers",
         //       //         style: TextStyle(fontSize: 16),
         //       //       ),
         //       //       validator: (value) {
         //       //
         //       //
         //       //         if (value == null || value.length == 0) {
         //       //           return 'Please select one or more options';
         //       //         }
         //       //         return null;
         //       //       },
         //       //       dataSource: FollowerList,
         //       //       textField: 'first_name',
         //       //       valueField: 'person_id',
         //       //       okButtonLabel: 'OK',
         //       //       cancelButtonLabel: 'CANCEL',
         //       //       // hintWidget: Text('Tap to Select followers'),
         //       //       initialValue: selectedfollower,
         //       //       onSaved: (value) {
         //       //         setState(() {
         //       //           selectedfollower = value;
         //       //
         //       //
         //       //
         //       //           //
         //       //           //   // selectedfollower.removeWhere((item) => int.parse(item) == Assignedtoemployee);
         //       //           // }
         //       //         });
         //       //       },
         //       //     )
         //       // ),
         //
         //
         //       Divider(),
         //       Container(
         //         child: Expanded(child:SingleChildScrollView(
         //           child: ListView.builder(physics: NeverScrollableScrollPhysics(),
         //           itemCount: chatMessage.length,
         //           shrinkWrap: true,
         //           padding: EdgeInsets.only(top: 10,bottom: 10),
         //           // physics: NeverScrollableScrollPhysics(),
         //           itemBuilder: (context, i){
         //           return Container(
         //             padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
         //             child: Align(
         //               alignment: (chatMessage[i].type == MessageType.Receiver?Alignment.topLeft:Alignment.topRight),
         //               child: Container(
         //                 decoration: BoxDecoration(
         //                   borderRadius: BorderRadius.circular(20),
         //                   color: (chatMessage[i].type  == MessageType.Receiver?Colors.white:Colors.grey.shade200),
         //                 ),
         //                 padding: EdgeInsets.all(16),
         //                 child: Text(chatMessage[i].message),
         //               ),
         //             ),
         //           );
         //         },
         //     ),
         //         )),
         //       ),
         //     ],
         //   ),
         // ),
         // bottomNavigationBar: BottomNavBar(),
       );

  }


}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey[200],
      height: 50,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.transparent,
            margin: EdgeInsets.fromLTRB(35, 02, 0, 02),
            child: TextField(

              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.textsms,
                  color: Colors.blue,
                ),
                suffixIcon: const Icon(
                  Icons.send,
                  color: Colors.green,
                ),
                hintText: 'Type a Message',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(

                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


