import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lawer/forum/forum.dart';
import 'package:lawer/users/people/profilepeople.dart';
import 'package:lawer/users/userselection.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
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
    getData();
    super.initState();
  }

  String selectedType;
  final List<DropdownMenuItem> items = [];
  getData() async {
    var b =
        await fireStoreInstance.collection("Lawertype").doc('Lawertype').get();
    String string = b.data()['Lawertype'];
    setState(() {
      for (int i = 0; i < string.split(",").length; i++) {
        items.add(DropdownMenuItem(
          child: Text(string.split(",")[i]),
          value: string.split(",")[i],
        ));
      }
    });
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
              Tab(icon: Text('Lawyers')),
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
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: SearchableDropdown.single(
                    displayClearIcon: false,
                    items: items,
                    value: 'Lawyer Service Type',
                    hint: 'Lawyer Service Type',
                    searchHint: "Search / Select one",
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    dialogBox: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '*required';
                      }
                      return null;
                    },
                    isExpanded: true,
                  ),
                ),
                lawers.length == 0
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: lawers.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(lawers.length);
                              for (int i = 0; i < lawers.length; i++) {
                                if (selectedType == lawers[index]['service']) {
                                  return ListTile(
                                    onTap: () {
                                      print(lawers[index]['email']);
                                      Get.to(
                                          LawerDetails(lawers[index]['email']));
                                    },
                                    title: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) *
                                              1.7,
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Image.network(
                                              // lawers[index]['profile']['picture']
                                              lawers[index]['profile']
                                                              ['picture']
                                                          .toString()
                                                          .substring(0, 3) ==
                                                      'sca'
                                                  ? 'https://firebasestorage.googleapis.com/v0/b/lawer-8613e.appspot.com/o/${lawers[index]['profile']['picture']}?alt=media&token=260e6756-d21b-43a6-9391-2270ff39f3f2'
                                                  : lawers[index]['profile']
                                                      ['picture'],
                                              height: 90,
                                              width: 90,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                      lawers[index]['name'],
                                                      minFontSize: 10,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'Gilroy',
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                      lawers[index]['email'],
                                                      minFontSize: 10,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: 'Gilroy',
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                      lawers[index]['phn'],
                                                      minFontSize: 10,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.visible,
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
                                } else {
                                  return Container();
                                }
                              }
                            }),
                      ),
              ],
            ),
            Forum()
          ],
        ),
      ),
    );
  }
}
