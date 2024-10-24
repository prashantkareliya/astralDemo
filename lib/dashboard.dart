import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard" ),
        actions: [
          IconButton(onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
          }, icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
