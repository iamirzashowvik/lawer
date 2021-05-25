import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lawer/forum/forum.dart';
import 'package:lawer/users/lawers/conv_lawer/conv_lawer.dart';
import 'package:lawer/users/lawers/profilel.dart';
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
              Tab(icon: Text('Chats')),
              Tab(icon: Text('Forum')),
            ],
          ),actions: [

        ],
          title: Text(name),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(),
              ListTile(
                onTap: () {
                  Get.to(ProfileLawer());
                },
                title: Row(
                  children: [
                    Icon(FontAwesomeIcons.user),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('   Profile'),
                    )
                  ],
                ),
              ),
              ListTile(
                onTap: () async {
                  SharedPreferences preference =
                  await SharedPreferences.getInstance();
                  preference.setBool('isLogInPeople', false);
                  preference.setBool('isLogInLawer', false);
                  Get.offAll(UserSelection());
                },
                title: Row(
                  children: [
                    Icon(FontAwesomeIcons.signOutAlt),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('   Logout'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
                child: Text(
                  "0",
                  style: TextStyle(fontSize: 40),
                )),
            Conv_lawer(),
           Forum()
          ],
        ),
      ),
    );
  }}
