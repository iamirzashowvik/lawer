import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLawer extends StatefulWidget {
  const ProfileLawer({Key key}) : super(key: key);

  @override
  _ProfileLawerState createState() => _ProfileLawerState();
}

class _ProfileLawerState extends State<ProfileLawer> {
  var res, item;
  getLawerData() async {
    res = await FirebaseFirestore.instance
        .collection('Lawer')
        .where('email', isEqualTo: email)
        .get();
// print(res.data()['phn'].toString());
    res.docs.forEach((res) async {
      setState(() {
        item = res.data();
      });
    });
    print(item['name']);
  }
  final _loginForm = GlobalKey<FormState>();
  @override
  void initState() {
    getSharedData();
    // TODO: implement initState
    super.initState();

  }
  TextEditingController post = TextEditingController();
  final fireStoreInstance = FirebaseFirestore.instance;
  String email, name, photoURL;
  getSharedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
      print(email);
      name = preferences.getString('name');
      photoURL = preferences.getString('profilePHOTO');
      getLawerData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return res == null
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : SafeArea(
      child: Scaffold( appBar:
      AppBar( backgroundColor: Colors.white,elevation:0,
        leading:GestureDetector(onTap: () {

          Get.back();
        },child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),),title: Text('Profile',style: TextStyle(color: Colors.black),),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(item['profile']['picture']),
                radius: MediaQuery.of(context).size.width / 4,
              ),
              Text(
                item == null ? '' : item['name'],
                style: TextStyle(fontSize: 30),
              ),Text(
                item == null ? '' : item['email'],
                style: TextStyle(fontSize: 20),
              ),
              Text(
                item == null ? '' : item['service'],
                style: TextStyle(fontSize: 20),
              ),
              Text(
                item == null ? '' : item['education'],
                style: TextStyle(fontSize: 20),
              ),
              Text(
                item == null ? '' : 'Bar Registration Number : ${item['barresnumber']}',
                style: TextStyle(fontSize: 20),
              ),Text(
                item == null ? '' : 'Office Address : ${item['OfficeAddress']}',
                style: TextStyle(fontSize: 20),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
