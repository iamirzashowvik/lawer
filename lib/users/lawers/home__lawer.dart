import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawer/forum/forum.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../userselection.dart';

class HomeLawer extends StatefulWidget {
  @override
  _HomeLawerState createState() => _HomeLawerState();
}

class _HomeLawerState extends State<HomeLawer> {
  String name='UserName';
  getSharedData()async{

    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
      name=preferences.getString('name');
    });

  }
  @override
  void initState() {
    getSharedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            onTap: (index) {

            },
            tabs: [
              Tab(icon: Text('Laws')),
              Tab(icon: Text('Lawers')),
              Tab(icon: Text('Forum')),
            ],
          ),actions: [
          GestureDetector(onTap: () async{
            SharedPreferences preference=await SharedPreferences.getInstance();
            preference.setBool('isLogInLawer', false);
            Get.offAll(UserSelection());
          },child: Icon(Icons.exit_to_app),)

        ],
          title: Text(name),
        ),
        body: TabBarView(
          children: [
            Center(
                child: Text(
                  "0",
                  style: TextStyle(fontSize: 40),
                )),
            Center(
                child: Text(
                  "1",
                  style: TextStyle(fontSize: 40),
                )),
           Forum()
          ],
        ),
      ),
    );
  }}
