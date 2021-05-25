import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lawer/forum/forum.dart';
import 'package:lawer/users/people/profilepeople.dart';
import 'package:lawer/users/userselection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lawer/users/people/LawerDetails.dart';
import 'conversations/conversations.dart';

class HomePeople extends StatefulWidget {
  @override
  _HomePeopleState createState() => _HomePeopleState();
}

class _HomePeopleState extends State<HomePeople> {
  String name = 'UserName';
  final fireStoreInstance = FirebaseFirestore.instance;
  List<dynamic> lawers = [];
  getSharedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
    });
    fireStoreInstance.collection("Lawer").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var dataFF2 = result.data();
        setState(() {
          lawers.add(dataFF2);
        });
      });
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
            onTap: (index) {},
            tabs: [
              Tab(icon: Text('Laws')),
              Tab(icon: Text('Lawers')),
              Tab(icon: Text('Forum')),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  Get.to(Conversations());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(FontAwesomeIcons.facebookMessenger),
                ),
              ),
            ),
          ],
          title: Text(name),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(),
              ListTile(
                onTap: () {
                  Get.to(Profile());
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
            lawers.length == 0
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: lawers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          print(lawers[index]['email']);
                          Get.to(LawerDetails(lawers[index]['email']));
                        },
                        title: Container(
                          width: (MediaQuery.of(context).size.width / 3) * 1.7,
                          child: Center(
                            child: Row(
                              children: [
                                Image.network(
                                  lawers[index]['profile']['picture'],
                                  height: 90,
                                  width: 90,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(lawers[index]['name'],
                                          minFontSize: 10,
                                          maxLines: 3,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Gilroy',
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          AutoSizeText(lawers[index]['email'],
                                              minFontSize: 10,
                                              maxLines: 3,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Gilroy',
                                              )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(lawers[index]['phn'],
                                          minFontSize: 10,
                                          maxLines: 3,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Gilroy',
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
            Forum()
          ],
        ),
      ),
    );
  }
}
