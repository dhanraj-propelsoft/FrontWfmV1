import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class Sync extends StatefulWidget {
  @override
  _SyncState createState() => _SyncState();
}

class _SyncState extends State<Sync> {



  Future<List> checkconnections() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("connectde mobile");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("connectde wifi");
    }else{
      print("offline mode");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
