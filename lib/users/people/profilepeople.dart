import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
   getSharedData();
    // TODO: implement initState
    super.initState();
  }
  String email, name, photoURL,phn,add,nid;
  getSharedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
      name = preferences.getString('name');
      photoURL = preferences.getString('profilePHOTO');
     phn= preferences.getString('phn');
     add= preferences.getString('PresentAddress');
     nid= preferences.getString('nid');
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
           children: [ CircleAvatar(
             backgroundImage: NetworkImage(photoURL),
             radius: MediaQuery.of(context).size.width / 4,
           ),
             Text(
              name,
               style: TextStyle(fontSize: 30),
             ),
             Text(
               email,
               style: TextStyle(fontSize: 20),
             ),
             Text(
              phn,
               style: TextStyle(fontSize: 20),
             ),
             Text(
               add,
               style: TextStyle(fontSize: 20),
             ),
             Text(
               nid,
               style: TextStyle(fontSize: 20),
             ),
           ],

          ),
        ),
      ),
    );
  }
}
