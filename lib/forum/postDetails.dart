import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawer/model/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetails extends StatefulWidget {
  final String posteremail;
  final String name;
  final String photoUrl;
  final String post;
final String id;

  PostDetails(this.posteremail, this.name, this.photoUrl, this.post,this.id);
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  String email, name, photoURL;
  getSharedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
      name = preferences.getString('name');
      photoURL = preferences.getString('profilePHOTO');
    });
  }

  @override
  void initState() {
    getSharedData();
    // TODO: implement initState
    super.initState();
  }

  final fireStoreInstance = FirebaseFirestore.instance;
  TextEditingController post = TextEditingController();
  final _loginForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
        AppBar( backgroundColor: Colors.white,elevation:0,
          leading:GestureDetector(onTap: () {

        Get.back();
      },child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.arrow_back_ios,color: Colors.black,),
      ),),title: Text('Comments',style: TextStyle(color: Colors.black),),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.photoUrl),
                      radius: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.post),
                ),
                Divider(
                  thickness: 5,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Comments'),
            ),
            Form(
                key: _loginForm,
                child: Column(children: [
                  TFFxM(post, 'Type your comment?'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                if (_loginForm.currentState.validate()) {
                                  fireStoreInstance
                                      .collection("Forum")
                                      .doc(widget.id)
                                      .collection("comments")
                                      .doc()
                                      .set({
                                    'comment': post.text,
                                    'name': name,
                                    'email': email,
                                    'photoUrl': photoURL,
                                    'timestamp': FieldValue.serverTimestamp(),
                                  }, SetOptions(merge: true)).then((_) {
                                    print('success');
                                    Get.snackbar('Success', 'Comment Updated');
                                  });
                                  setState(() {
                                    post.text = '';
                                  });
                                } else {
                                  //  print("invalid");
                                }
                              },
                              child: Icon(Icons.send)),
                        ],
                      ),
                    ),
                  )
                ])),
         Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStoreInstance
                  .collection('Forum').doc(widget.id).collection('comments')
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
//  print(snapshot.data.docs[0]['comment']);
                return ListView.builder(
                  reverse: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                   
                    return 
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        
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
                              child: Text(snapshot.data.docs[index]['comment']),
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
     
          ]),
        ),
      ),
    );
  }
}
