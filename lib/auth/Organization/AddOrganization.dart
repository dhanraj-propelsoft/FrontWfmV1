import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:propel/network_utils/api.dart';

import '../../main_page.dart';

class AddOrganization extends StatefulWidget {
  @override
  _AddOrganizationState createState() => _AddOrganizationState();
}

class _AddOrganizationState extends State<AddOrganization> {
  final organizationName = TextEditingController();
  bool organizationNameValue = false;
  final unitName = TextEditingController();
  final alias = TextEditingController();
  List OrgCategory;
  List OrgOwnership;

  int OrgCategoryId;
  int OrgOwenershipId;
  bool _isLoading = false;

  Future<List> getOrgMasterData() async {
    setState(() {
      _isLoading = true;
    });
    var response = await Network().getMethodWithToken('/getOrgMasterData');
    var dataResponse = jsonDecode(response.body);

    if (dataResponse['status'] == 1) {
      setState(() {
        OrgCategory = dataResponse['CategoryData'];
        OrgOwnership = dataResponse['ownershipData'];
        _isLoading = false;
      });
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    getOrgMasterData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
    } else {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Add Organization',
              style: TextStyle(color: Colors.white),
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                TextField(
                  controller: organizationName,
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      setState(() {
                        organizationNameValue = false;
                      });
                    } else {
                      setState(() {
                        organizationNameValue = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Organization Name",
                    labelText: "Organization Name",
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintStyle: TextStyle(fontSize: 14.0),
                  ),
                ),
                TextField(
                  controller: unitName,
                  decoration: InputDecoration(
                    hintText: "Enter Unit Name/No",
                    labelText: "Unit Name/No",
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintStyle: TextStyle(fontSize: 14.0),
                  ),
                ),
                TextField(
                  controller: alias,
                  decoration: InputDecoration(
                    hintText: "Enter Alias Name",
                    labelText: "Alias",
                    labelStyle: TextStyle(fontSize: 14.0),
                    hintStyle: TextStyle(fontSize: 14.0),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            value: OrgCategoryId,
                            hint: Text('Select Category'),
                            items: OrgCategory?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['name']),
                                    value: item['id'],
                                  );
                                })?.toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                OrgCategoryId = value;
                              });
                            },
                          ),
                        )),
                      ),
                      Flexible(
                          child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                            value: OrgOwenershipId,
                            hint: Text('Select Ownership'),
                            items: OrgOwnership?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['name']),
                                    value: item['id'],
                                  );
                                })?.toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                OrgOwenershipId = value;
                              });
                            }),
                      )))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: ButtonBar(
            children: [
              RaisedButton(
                color: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                onPressed: organizationNameValue
                    ? () {
                        storeOrganization();
                      }
                    : null,
              )
            ],
          ),
        ),
      );
    }
  }

  Future storeOrganization() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'pOrganizationName': organizationName.text,
      'pUnitName': unitName.text,
      'pAlias': alias.text,
      'pCategoryId': OrgCategoryId,
      'pOwnershipId': OrgOwenershipId
    };
    var res = await Network().postMethodWithToken(data, '/organization_store');
    var body = json.decode(res.body);

    if (body['status'] == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage(index: 0, page: "Add")));
    } else {}
  }
}
// import 'package:awesome_loader/awesome_loader.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
//
// import 'package:propel/network_utils/api.dart';
//
// import '../../main_page.dart';
//
// class AddOrganization extends StatefulWidget {
//   @override
//   _AddOrganizationState createState() => _AddOrganizationState();
// }
//
// class _AddOrganizationState extends State<AddOrganization> {
//   final organizationName = TextEditingController();
//   bool organizationNameValue = false;
//   final organizationEmail = TextEditingController();
//   bool organizationEmailValue = false;
//   final orgWebsite = TextEditingController();
//   final unitName = TextEditingController();
//   final orgContactNumber = TextEditingController();
//   final orgDescription = TextEditingController();
//   final alias = TextEditingController();
//   List OrgCategory;
//   List OrgOwnership;
//
//   int OrgCategoryId;
//   int OrgOwenershipId;
//   bool _isLoading = false;
//
//   Future<List> getOrgMasterData() async {
//     setState(() {
//       _isLoading = true;
//     });
//     var response = await Network().getMethodWithToken('/getOrgMasterData');
//     var dataResponse = jsonDecode(response.body);
//
//     if (dataResponse['status'] == 1) {
//       setState(() {
//         OrgCategory = dataResponse['CategoryData'];
//         OrgOwnership = dataResponse['ownershipData'];
//         _isLoading = false;
//       });
//     } else {
//       return [];
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getOrgMasterData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         body: Container(
//           child: Center(
//             child: AwesomeLoader(
//               loaderType: AwesomeLoader.AwesomeLoader3,
//               // color: Colors.blue,
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//             backgroundColor: Colors.orange,
//             iconTheme: IconThemeData(color: Colors.white),
//             title: Text(
//               'Add Organization',
//               style: TextStyle(color: Colors.white),
//             )),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.only(left: 15, right: 15),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: organizationName,
//                   onChanged: (value) {
//                     if (value.trim().isEmpty) {
//                       setState(() {
//                         organizationNameValue = false;
//                       });
//                     } else {
//                       setState(() {
//                         organizationNameValue = true;
//                       });
//                     }
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Enter Organization Name",
//                     labelText: "Organization Name",
//                     labelStyle: TextStyle(fontSize: 14.0),
//                     hintStyle: TextStyle(fontSize: 14.0),
//                   ),
//                 ),
//                 TextField(
//                   controller: organizationEmail,
//                   onChanged: (value) {
//                     if (value.trim().isEmpty) {
//                       setState(() {
//                         organizationEmailValue = false;
//                       });
//                     } else {
//                       setState(() {
//                         organizationEmailValue = true;
//                       });
//                     }
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Enter Organization Email",
//                     labelText: "Organization Email",
//                     labelStyle: TextStyle(fontSize: 14.0),
//                     hintStyle: TextStyle(fontSize: 14.0),
//                   ),
//                 ),
//                 TextField(
//                   controller: orgWebsite,
//                   decoration: InputDecoration(
//                     hintText: "Enter Organization Website",
//                     labelText: "Organization Website",
//                     labelStyle: TextStyle(fontSize: 14.0),
//                     hintStyle: TextStyle(fontSize: 14.0),
//                   ),
//                 ),
//                 TextField(
//                   controller: orgContactNumber,
//                   decoration: InputDecoration(
//                     hintText: "Enter Organization Contact Number",
//                     labelText: "Organization Contact Number",
//                     labelStyle: TextStyle(fontSize: 14.0),
//                     hintStyle: TextStyle(fontSize: 14.0),
//                   ),
//                 ),
//                 TextField(
//                   controller: orgDescription,
//                   decoration: InputDecoration(
//                     hintText: "Enter Oragnization Description",
//                     labelText: "Oragnization Description",
//                     labelStyle: TextStyle(fontSize: 14.0),
//                     hintStyle: TextStyle(fontSize: 14.0),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         DropdownButtonHideUnderline(
//                             child: ButtonTheme(
//                           alignedDropdown: true,
//                           child: DropdownButton(
//                             value: OrgCategoryId,
//                             hint: Text('Select Category'),
//                             items: OrgCategory?.map((item) {
//                                   return new DropdownMenuItem(
//                                     child: new Text(item['name']),
//                                     value: item['id'],
//                                   );
//                                 })?.toList() ??
//                                 [],
//                             onChanged: (value) {
//                               setState(() {
//                                 OrgCategoryId = value;
//                               });
//                             },
//                           ),
//                         )),
//                         DropdownButtonHideUnderline(
//                             child: ButtonTheme(
//                           alignedDropdown: true,
//                           child: DropdownButton(
//                               value: OrgOwenershipId,
//                               hint: Text('Select OwnerShip'),
//                               items: OrgOwnership?.map((item) {
//                                     return new DropdownMenuItem(
//                                       child: new Text(item['name']),
//                                       value: item['id'],
//                                     );
//                                   })?.toList() ??
//                                   [],
//                               onChanged: (value) {
//                                 setState(() {
//                                   OrgOwenershipId = value;
//                                 });
//                               }),
//                         ))
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           child: ButtonBar(
//             children: [
//               RaisedButton(
//                 color: Colors.pinkAccent,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Row(
//                   children: [
//                     Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.white),
//                     )
//                   ],
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               RaisedButton(
//                 color: Colors.green,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Row(
//                   children: [
//                     Text(
//                       'Save',
//                       style: TextStyle(color: Colors.white),
//                     )
//                   ],
//                 ),
//                 onPressed: organizationNameValue
//                     ? () {
//                         storeOrganization();
//                       }
//                     : null,
//               )
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   Future storeOrganization() async {
//     setState(() {
//       _isLoading = true;
//     });
//     var data = {
//       'pOrganizationName': organizationName.text,
//       'pUnitName': unitName.text,
//       'pAlias': alias.text,
//       'pCategoryId': OrgCategoryId,
//       'pOwnershipId': OrgOwenershipId
//     };
//     var res = await Network().postMethodWithToken(data, '/organization_store');
//     var body = json.decode(res.body);
//
//     if (body['status'] == 1) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => MainPage(index: 0, page: "Add")));
//     } else {}
//   }
// }
