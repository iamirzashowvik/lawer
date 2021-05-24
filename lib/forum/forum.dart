import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lawer/model/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Forum extends StatefulWidget {
  const Forum({Key key}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> { final _loginForm = GlobalKey<FormState>();
TextEditingController post = TextEditingController();
final fireStoreInstance = FirebaseFirestore.instance;
String email,name,photoURL;
getSharedData()async{
  SharedPreferences preferences=await SharedPreferences.getInstance();
  setState(() {
    email=preferences.getString('email');
    name=preferences.getString('name');
    photoURL=preferences.getString('profilePHOTO');
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
    return Scaffold(

      body: Column(
        children: [
        Form(
        key: _loginForm,
        child: Column(
        children: [
          TFFxM(post, 'What\'s On Your Mind?'),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Padding(
             padding: const EdgeInsets.symmetric(
                 horizontal: 20),
             child: Row(mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 ElevatedButton(onPressed:  () async {
                   if (_loginForm.currentState.validate()) {

  fireStoreInstance
                         .collection("Forum")
                         .doc(email)
                         .set({
                       'name': name, // John Doe
                       'post':post.text,'photoUrl':photoURL,
'email': email,
                     }, SetOptions(merge: true)).then((_) async {
                       print("success!");
                     });
                     setState(() {
                       post.text='';
                     });

                     Get.snackbar('Success','Post Updated');
                   } else {
                     //  print("invalid");
                   }
                 }, child: Text('Post')),
               ],
             ),
           ),
         )

        ])),
      Expanded(flex: 1,
        child: StreamBuilder<QuerySnapshot>(
          stream: fireStoreInstance.collection('Forum').snapshots(),
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
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),itemCount:snapshot.data.docs.length ,
              itemBuilder: (BuildContext context, int index) {
                return Text(snapshot.data.docs[index]['post']);
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
