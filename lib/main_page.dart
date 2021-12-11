import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:propel/wfm/masters/Category/category.dart';
import 'package:propel/wfm/masters/Project/project.dart';
import 'auth/Organization/organizations.dart';
import 'package:propel/wfm/task/task.dart';
import 'package:propel/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:propel/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:propel/Settings/Home.dart';

class MainPage extends StatefulWidget {
  final int index;
  final String page;
  const MainPage({Key key, this.index, this.page}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int initalindex;
  bool firstOrg = false;
  BottomLoader bl;

  _load_data() async {
    int org_id = await Network().GetActiveOrg();
    if (org_id != 0) {
      setState(() {
        firstOrg = true;
      });
    }
  }

  @override
  void initState() {
    _load_data();
    super.initState();
    if (widget.index == null) {
      setState(() {
        initalindex = 0;
      });
    } else {
      setState(() {
        initalindex = widget.index;
      });
      if (widget.index == 0) {
        Fluttertoast.showToast(
            msg: (widget.page == "Add")
                ? "Organization Added Successfully"
                : "Organization Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black);
      }
      if (widget.index == 1) {
        Fluttertoast.showToast(
            msg: (widget.page == "Add")
                ? "Category Added Successfully"
                : "Category Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black);
      }
      if (widget.index == 2) {
        Fluttertoast.showToast(
            msg: (widget.page == "Add")
                ? "Project Added Successfully"
                : "Project Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black);
      }
      if (widget.index == 3) {
        Fluttertoast.showToast(
            msg: (widget.page == "Add")
                ? "Task Added Successfully"
                : "Task Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black);
      }
    }
  }

  TabBar get _tabBar => TabBar(
        indicatorColor: Colors.orangeAccent,
        labelColor: Colors.black,
        tabs: <Widget>[
          Tab(text: 'Org', icon: Icon(Icons.account_balance, size: 20)),
          Tab(text: 'Category', icon: Icon(Icons.account_tree, size: 20)),
          Tab(text: 'Projects', icon: Icon(Icons.layers, size: 20)),
          Tab(text: 'Task', icon: Icon(Icons.assignment, size: 20)),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: initalindex,
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Ado unbox",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          ),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.white,
              child: _tabBar,
            ),
          ),
          actions: <Widget>[],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: firstOrg
            ? FloatingActionButton(
                child: Icon(
                  Icons.post_add_rounded,
                  color: Colors.white,
                ),
                // backgroundColor: Colors.orange,
                onPressed: () {
                  Navigator.pushNamed(context, '/addTask');
                },
              )
            : null,
        body: TabBarView(
          children: <Widget>[
            Organizations(),
            category(),
            project(),
            TaskList()
          ],
        ),
      ),
    );
  }

  void logout() async {
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
    var res = await Network().getMethodWithToken('/logout');
    var body = json.decode(res.body);

    if (body['status'] == '1') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('token');
      localStorage.remove('personData');
      localStorage.remove('active_org');
      bl.close();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CheckAuth()));
    }
  }
}
