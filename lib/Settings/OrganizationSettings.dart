import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propel/Settings/Profile.dart';
import 'package:propel/auth/Organization/OrganizationDetails.dart';
import 'Employee/EmployeeList.dart';

class OrganizationSettings extends StatefulWidget {
  @override
  _OrganizationSettingsState createState() => _OrganizationSettingsState();
}

class _OrganizationSettingsState extends State<OrganizationSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[350],
        title: Text(
          "Organizations Settings",
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
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrganizationList()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/splash_img.jpg'),
                  ),
                  Container(
                    child:
                        Text("Nova P Felix\n9443447755\nfelix@propelsoft.in"),
                  ),
                  Icon(Icons.arrow_forward_ios_sharp)
                ],
              ),
            ),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrganizationProfile()));
              },
              title: Text("Organization Profile"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
            Divider(),
            ListTile(
              // onTap: (){
              //   Navigator.push(context,
              //       MaterialPageRoute(
              //           builder: (context) => OrganizationSettings(
              //           )));
              // },
              title: Text("Manage Organizations Account"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
            Divider(),
            ListTile(
              title: Text("Manage Workforce"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeList(
                        )));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Access Controls"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
          ],
        ),
      ),
    );
  }
}

class OrganizationList extends StatefulWidget {
  @override
  _OrganizationListState createState() => _OrganizationListState();
}

class _OrganizationListState extends State<OrganizationList> {
  int prorityid = 2;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[350],
        title: Text(
          "Organizations",
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
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/splash_img.jpg'),
                  ),
                  Container(
                    child:
                        Text("Nova P Felix\n9443447755\nfelix@propelsoft.in"),
                  ),
                  Radio(
                      value: 1,
                      groupValue: prorityid,
                      onChanged: _handleRadioValueChange),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/splash_img.jpg'),
                  ),
                  Container(
                    child:
                        Text("Nova P Felix\n9443447755\nfelix@propelsoft.in"),
                  ),
                  Radio(
                      value: 2,
                      groupValue: prorityid,
                      onChanged: _handleRadioValueChange),
                ],
              ),
              Divider(),
              RaisedButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'Add Organizations',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrganizationDetails()));
                  }),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: ButtonBar(
      //     alignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //
      //     ],
      //   ),
      // ),
    );
  }
}

class OrganizationProfile extends StatefulWidget {
  @override
  _OrganizationProfileState createState() => _OrganizationProfileState();
}

class _OrganizationProfileState extends State<OrganizationProfile> {
  final Name = new TextEditingController();
  final MobileNo = new TextEditingController();
  final Email = new TextEditingController();
  final DOB = new TextEditingController();
  final HomeAddress = new TextEditingController();
  final OfficeAddress = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[350],
        title: Text(
          "Organization Profile",
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
          padding: EdgeInsets.all(10.0),
          child: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/splash_img.jpg'),
                  ),
                ),
                TextField(
                  // onTap: () {
                  //   name_update();
                  // },
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    hintText: "Enter your Organization Name",
                    labelText: "Organization Name",

                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                  ),
                  controller: Name,
                ),
                TextField(
                  // onTap: () {
                  //   mobile_update();
                  // },
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    hintText: "Enter your Organization Email",
                    labelText: "Oraganization Email",

                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                  ),
                  controller: MobileNo,
                ),
                TextField(
                  // onTap: (){
                  //   email_update();
                  // },
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    hintText: "Enter your Website",
                    labelText: "Organization Website",

                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                  ),
                  controller: Email,
                ),
                TextField(
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => AddressUpdate()),
                    );
                  },
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    // hintText: "Enter your Add",
                    labelText: "Organization Address",

                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                  ),
                  controller: DOB,
                ),
                TextField(
                  // onTap: (){
                  //   home_address_update();
                  // },
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    hintText: "Enter your Mobile No",
                    labelText: "Organization Contact No",

                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                  ),
                  controller: HomeAddress,
                ),
                // TextField(
                //   // onTap: (){
                //   //   home_address_update();
                //   // },
                //   keyboardType: TextInputType.number,
                //   obscureText: false,
                //   decoration: InputDecoration(
                //     // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                //     hintText: "Enter your Working Hours",
                //     labelText: "Organization Working Hours",
                //
                //     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                //   ),
                //   controller: OfficeAddress,
                // ),
                TextField(
                  // onTap: (){
                  //   email_update();
                  // },
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                    // hintText: "Enter your Website",
                    labelText: "Organization Description",

                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                  ),
                  controller: Email,
                ),
                // TextField(
                //   // onTap: () {
                //   //   Navigator.push(
                //   //     context,
                //   //     new MaterialPageRoute(
                //   //         builder: (context) => AddressUpdate()
                //   //     ),
                //   //   );
                //   // },
                //   keyboardType: TextInputType.number,
                //   obscureText: false,
                //   decoration: InputDecoration(
                //     // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                //     // hintText: "Enter your Add",
                //     labelText: "Organization Category",
                //
                //     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                //   ),
                //   controller: DOB,
                // ),
                // TextField(
                //   // onTap: (){
                //   //   home_address_update();
                //   // },
                //   keyboardType: TextInputType.number,
                //   obscureText: false,
                //   decoration: InputDecoration(
                //     // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                //     // hintText: "Enter your Mobile No",
                //     labelText: "Organization ownership",
                //
                //     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                //   ),
                //   controller: HomeAddress,
                // ),
                // TextField(
                //   // onTap: (){
                //   //   home_address_update();
                //   // },
                //   keyboardType: TextInputType.number,
                //   obscureText: false,
                //   decoration: InputDecoration(
                //     // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                //     // hintText: "Enter your Working Hours",
                //     labelText: "Organization Administrators ",
                //
                //     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                //   ),
                //   controller: OfficeAddress,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void name_update() async {
    final firstname = new TextEditingController();
    final middlename = new TextEditingController();
    final lastname = new TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height =
              MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                padding: new EdgeInsets.all(10.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.only(left:15,right: 15),
                      height: 45.0,
                      child: TextField(
                        autofocus: true,
                        // onChanged:(val){
                        //
                        //   if (val.trim().isEmpty){
                        //     setState(() {
                        //       isCategoryNameVal = false;
                        //     });
                        //   }else{
                        //     setState(() {
                        //       isCategoryNameVal = true;
                        //     });
                        //   }
                        //
                        // },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[600]),
                            // hintText: "Boys Rings",
                            labelText: "First Name",
                            fillColor: Colors.white),
                        controller: firstname,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    ),
                    Container(
                      // padding: EdgeInsets.only(left:15,right: 15),
                      height: 45.0,
                      child: TextField(
                        autofocus: true,
                        // onChanged:(val){
                        //
                        //   if (val.trim().isEmpty){
                        //     setState(() {
                        //       isCategoryNameVal = false;
                        //     });
                        //   }else{
                        //     setState(() {
                        //       isCategoryNameVal = true;
                        //     });
                        //   }
                        //
                        // },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[600]),
                            // hintText: "Boys Rings",
                            labelText: "Middle Name",
                            fillColor: Colors.white),
                        controller: middlename,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    ),
                    Container(
                      // padding: EdgeInsets.only(left:15,right: 15),
                      height: 45.0,
                      child: TextField(
                        autofocus: true,
                        // onChanged:(val){
                        //
                        //   if (val.trim().isEmpty){
                        //     setState(() {
                        //       isCategoryNameVal = false;
                        //     });
                        //   }else{
                        //     setState(() {
                        //       isCategoryNameVal = true;
                        //     });
                        //   }
                        //
                        // },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[600]),
                            // hintText: "Boys Rings",
                            labelText: "Last Name",
                            fillColor: Colors.white),
                        controller: lastname,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    ),
                    ButtonTheme(
                      height: 45.0,
                      child: RaisedButton(
                        // padding: EdgeInsets.all(50),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon(Icons.direc,color: Colors.white),
                            Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ],
                        ),
                        // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void mobile_update() async {
    final mobileno = new TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height =
              MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                padding: new EdgeInsets.all(10.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.only(left:15,right: 15),
                      height: 45.0,
                      child: TextField(
                        autofocus: true,
                        // onChanged:(val){
                        //
                        //   if (val.trim().isEmpty){
                        //     setState(() {
                        //       isCategoryNameVal = false;
                        //     });
                        //   }else{
                        //     setState(() {
                        //       isCategoryNameVal = true;
                        //     });
                        //   }
                        //
                        // },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[600]),
                            // hintText: "Boys Rings",
                            labelText: "Mobile No",
                            fillColor: Colors.white),
                        controller: mobileno,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    ),
                    ButtonTheme(
                      height: 45.0,
                      child: RaisedButton(
                        // padding: EdgeInsets.all(50),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon(Icons.direc,color: Colors.white),
                            Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ],
                        ),
                        // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void email_update() async {
    final email = new TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height =
              MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                padding: new EdgeInsets.all(10.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.only(left:15,right: 15),
                      height: 45.0,
                      child: TextField(
                        autofocus: true,
                        // onChanged:(val){
                        //
                        //   if (val.trim().isEmpty){
                        //     setState(() {
                        //       isCategoryNameVal = false;
                        //     });
                        //   }else{
                        //     setState(() {
                        //       isCategoryNameVal = true;
                        //     });
                        //   }
                        //
                        // },
                        decoration: InputDecoration(
                            // border: OutlineInputBorder(
                            //   borderRadius: const BorderRadius.all(
                            //     Radius.circular(15.0),
                            //   ),
                            // ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[600]),
                            // hintText: "Boys Rings",
                            labelText: "Email",
                            fillColor: Colors.white),
                        controller: email,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    ),
                    ButtonTheme(
                      height: 45.0,
                      child: RaisedButton(
                        // padding: EdgeInsets.all(50),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon(Icons.direc,color: Colors.white),
                            Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ],
                        ),
                        // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void dob_update() async {
    final dob = new TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height =
              MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                padding: new EdgeInsets.all(10.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.only(left:15,right: 15),
                      height: 45.0,
                      child: TextField(
                        autofocus: true,
                        // onChanged:(val){
                        //
                        //   if (val.trim().isEmpty){
                        //     setState(() {
                        //       isCategoryNameVal = false;
                        //     });
                        //   }else{
                        //     setState(() {
                        //       isCategoryNameVal = true;
                        //     });
                        //   }
                        //
                        // },
                        decoration: InputDecoration(
                            hintText: 'Pick Date',
                            labelText: 'DOB',
                            labelStyle: TextStyle(fontSize: 14.0),
                            hintStyle: TextStyle(fontSize: 14.0),
                            suffixIcon:
                                Icon(Icons.calendar_today_rounded, size: 18.0)),
                        onTap: () async {
                          // final DateTime now = DateTime.now();
                          final DateFormat formatter = DateFormat('dd-MM-yyyy');

                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          dob.text = date.toString().substring(0, 10);
                        },
                        controller: dob,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    ),
                    ButtonTheme(
                      height: 45.0,
                      child: RaisedButton(
                        // padding: EdgeInsets.all(50),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon(Icons.direc,color: Colors.white),
                            Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ],
                        ),
                        // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void home_address_update() async {
    final home_address = new TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final double bottomsheet_height =
              MediaQuery.of(context).size.height * 0.10 - 50;
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                padding: new EdgeInsets.all(10.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.only(left:15,right: 15),
                      height: 45.0,
                      child: TextField(
                        autofocus: true,
                        // onChanged:(val){
                        //
                        //   if (val.trim().isEmpty){
                        //     setState(() {
                        //       isCategoryNameVal = false;
                        //     });
                        //   }else{
                        //     setState(() {
                        //       isCategoryNameVal = true;
                        //     });
                        //   }
                        //
                        // },
                        decoration: InputDecoration(
                            // border: OutlineInputBorder(
                            //   borderRadius: const BorderRadius.all(
                            //     Radius.circular(15.0),
                            //   ),
                            // ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[600]),
                            // hintText: "Boys Rings",
                            labelText: "Home Address",
                            fillColor: Colors.white),
                        controller: home_address,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    ),
                    ButtonTheme(
                      height: 45.0,
                      child: RaisedButton(
                        // padding: EdgeInsets.all(50),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon(Icons.direc,color: Colors.white),
                            Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ],
                        ),
                        // onPressed:isCategoryNameVal?(){ print("enabled");}:null,
                      ),
                    ),
                    SizedBox(
                      height: bottomsheet_height,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
