import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lawer/forum/postDetails.dart';
import 'package:lawer/model/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Forum extends StatefulWidget {
  const Forum({Key key}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
class _ForumState extends State<Forum> {
  final _loginForm = GlobalKey<FormState>();
  TextEditingController post = TextEditingController();
  final fireStoreInstance = FirebaseFirestore.instance;
  String email, name, photoURL;
  getSharedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
      name = preferences.getString('name');
      photoURL = preferences.getString('profilePHOTO');
    });
  }

  int listcount = 0;
  @override
  void initState() {
    getSharedData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Form(
              key: _loginForm,
              child: Column(children: [
                TFFxM(post, 'What\'s On Your Mind?'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [


                        ElevatedButton(
                            onPressed: () async {
                              String idX=getRandomString(10);
                              if (_loginForm.currentState.validate()) {
                                fireStoreInstance
                                    .collection("Forum")
                                    .doc(idX)
                                    .set({
                                  'name': name, // John Doe
                                  'post': post.text, 'photoUrl': photoURL,
                                  'email': email,
                                  'count':idX,
                                  'timestamp': FieldValue.serverTimestamp(),
                                }, SetOptions(merge: true)).then((_) async {
                                  print("success!");
                                });
                                setState(() {
                                  post.text = '';
                                });

                                Get.snackbar('Success', 'Post Updated');
                              } else {
                                //  print("invalid");
                              }
                            },
                            child: Text('Post')),
                      ],
                    ),
                  ),
                )
              ])),
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStoreInstance
                  .collection('Forum')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                // final messages = snapshot.data.docs.reversed;

                return ListView.builder(
                  reverse: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    listcount=snapshot.data.docs.length;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Get.to(PostDetails(
                              snapshot.data.docs[index]['email'],
                              snapshot.data.docs[index]['name'],
                              snapshot.data.docs[index]['photoUrl'],
                              snapshot.data.docs[index]['post'],
                               snapshot.data.docs[index]['count'].toString(),
                             ));
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data.docs[index]['photoUrl']),
                                  radius: 20,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      snapshot.data.docs[index]['name'],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text(
                                    //   //DateTime.fromMicrosecondsSinceEpoch(snapshot.data.docs[index]['timestamp'].seconds.)
                                    //   snapshot.data.docs[index]['timestamp']
                                    //       .now()
                                    //       .toDate(),
                                    //   style: TextStyle(
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.data.docs[index]['post']),
                            ),
                            Divider(
                              thickness: 5,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
