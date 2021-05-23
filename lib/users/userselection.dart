import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawer/users/lawers/signin__lawer.dart';
import 'package:lawer/users/lawers/signup__lawer.dart';
import 'package:lawer/users/people/SignInPeople.dart';

import 'package:lawer/users/people/signup__people.dart';

class UserSelection extends StatefulWidget {


  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            ElevatedButton(onPressed: (){
 Get.to(SignInPeople());}, child: Text('Need a Lawer')),
            ElevatedButton(onPressed: (){
              Get.to(SignInLawer());
            }, child: Text('Lawer')),
          ],),
        ),
      ),
    );
  }
}
