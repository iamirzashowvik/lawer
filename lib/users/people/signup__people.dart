import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lawer/model/textformfield.dart';
import 'package:lawer/users/people/SignInPeople.dart';

class SignUpPeople extends StatefulWidget {
  const SignUpPeople({Key key}) : super(key: key);

  @override
  _SignUpPeopleState createState() => _SignUpPeopleState();
}

class _SignUpPeopleState extends State<SignUpPeople> {
  final _loginForm = GlobalKey<FormState>();
  TextEditingController fullName = TextEditingController();
  TextEditingController presentaddress = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController needs = TextEditingController();
  TextEditingController nid = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _loginForm,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Hi there, Lets know a bit about you!',
                    style: TextStyle(
                        fontFamily: 'Gilroy', color: Colors.blue, fontSize: 30),
                  ),
                ),
                TFFxM(fullName, 'Full Name'),
                TFFxM(email, 'Email'),
                TFFxM(password, 'Password'),
                TFFxM(presentaddress, 'Present Address'),
                TFFxM(phone, 'Phone Number'),
                TFFxM(needs, 'What Solution I\'m looking for in 100 words?'),
                TFFxM(nid, 'NID/Passport/Driving License Number'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: GestureDetector(
                    onTap: () async {
                      if (_loginForm.currentState.validate()) {
                        EasyLoading.show(status: 'loading...');
                       

                        firestoreInstance
                            .collection("client")
                            .doc(email.text)
                            .set({
                          'name': fullName.text, // John Doe
                          'phn': phone.text, // Stokes and Sons
                          'password': password.text,
                          'needs': needs.text,
                          'nid': nid.text,
                          'PresentAddress': presentaddress.text,
                          'email': email.text,
                          'usertype':'client'
                        }, SetOptions(merge: true)).then((_) async {
                          print("success!");
                        });
                        EasyLoading.dismiss();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => SignInPeople()));
                      } else {
                        //  print("invalid");
                      }
                    },
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
