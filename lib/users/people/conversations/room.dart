import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawer/model/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Room extends StatefulWidget {

final String lawerphoto;
final String lawername;
final String laweremail;
Room(this.laweremail,this.lawername,this.lawerphoto);
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {final _loginForm = GlobalKey<FormState>(); TextEditingController post = TextEditingController();
final fireStoreInstance = FirebaseFirestore.instance;
String email, name, photoURL,threadId;
getSharedData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email');
    name = preferences.getString('name');
    photoURL = preferences.getString('profilePHOTO');
  threadId=widget.laweremail.toString().split('@')[0]+email.toString().split('@')[0];
  print(threadId);
  });
}
@override
  void initState() {
  getSharedData();
  // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: photoURL == null
          ? CircularProgressIndicator()
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget.lawerphoto),
          // radius: 20,
        ),
      ),
      title: Text(
        widget.lawername,
        style: TextStyle(color: Colors.black),
      ),
    ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreInstance
            .collection('Conversations').doc(threadId).collection('messages')
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

          return ListView.builder(
            //reverse: true,
            padding:
            EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {

              return
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(

                    title: Column(
                       crossAxisAlignment: snapshot.data.docs[index]['user']=='client'? CrossAxisAlignment.end:CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data.docs[index]['message'],
                          style: TextStyle(
                              fontSize: 25,color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                  ),
                );

            },
          );
        },
      ),
bottomSheet: Form(
    key: _loginForm,
    child: Row(children: [
      Container(width: MediaQuery.of(context).size.width/1.5,child: TFFxM(post, 'Send Text Message')),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
              onPressed: () async {

                if (_loginForm.currentState.validate()) {
                  fireStoreInstance
                      .collection("Conversations")
                      .doc(threadId)
                      .set({
                    'message': post.text,



                    'timestamp': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true)).then((_) async {
                    print("success!");
                  });
                  fireStoreInstance
                      .collection("Conversations")
                      .doc(threadId)
                      .collection('messages')
                      .doc()
                      .set({
                    'message': post.text,
                    'user':'client',
                    'timestamp': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true)).then((_) {
                    print('success');

                  });

                  setState(() {
                    post.text = '';
                  });

                  //Get.snackbar('Success', 'Request Sent');
                } else {
                  //  print("invalid");
                }
              },
              child: Text('Send')),
        ),
      )
    ])),
    );
  }
}
