import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propel/network_utils/api.dart';

import 'package:flutter_radio_group/flutter_radio_group.dart';

import 'package:grouped_buttons_ns/grouped_buttons_ns.dart';

class OrganizationDetails extends StatefulWidget {
  @override
  _OrganizationDetailsState createState() => _OrganizationDetailsState();
}

class _OrganizationDetailsState extends State<OrganizationDetails> {
  bool _isLoading = false;
  List OrgCategory;
  List OrgOwnership;

  Future<List> getOrgMasterData() async {
    setState(() {
      _isLoading = true;
    });
    var response = await Network().getMethodWithToken('/getOrgMasterData');
    var dataResponse = jsonDecode(response.body);
    print(dataResponse);
    if (dataResponse['status'] == 1) {
      setState(() {
        OrgCategory = dataResponse['CategoryData'];

        print(OrgCategory);
        OrgOwnership = dataResponse['ownershipData'];
        _isLoading = false;
      });
    } else {
      return [];
    }
  }

  var _listVertical = ["Vertical 1", "Vertical 2", "Vertical 3"];

  var _keyVertical = GlobalKey<FlutterRadioGroupState>();

  var _indexVertical = 1;

  @override
  void initState() {
    super.initState();
    getOrgMasterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[350],
        title: Text(
          "Add Organization",
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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Your Organization Structure *",
                style: TextStyle(fontSize: 15),
              ),
              RadioButtonGroup(
                labels: [
                  'Option 1',
                  'Option 2',
                ],
                onChange: (String label, int index) =>
                    print('label: $label index: $index'),
                onSelected: (String label) => print(label),
              ),
              Divider(
                height: 32,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
