import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/utils.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future signUp() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) return;

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        Utils.showSnackBar(e.message);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Signup Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Container(
                      width: 160,
                      height: 120,
                      child: Image.asset('assets/DPMS_logo.png')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && EmailValidator.validate(email)
                          ? null
                          : 'Enter a valid email',
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter minimum 6 characters'
                      : null,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value == null || value.isEmpty ? '이름을 입력하세요' : null,
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '이름',
                      hintText: ''),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value == null || value.isEmpty || value.length != 8
                          ? '생년월일을 입력하세요(8자리) ex)19980525'
                          : null,
                  controller: birthdayController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '생년월일',
                      hintText: '19980525'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 15),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value == null || value.isEmpty || value.length != 13
                          ? '전화번호를 입력하세요("-" 포함) ex)010-1234-5678'
                          : null,
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '전화번호',
                      hintText: '010-1234-5678'),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    await signUp();

                    final String email = emailController.text;
                    final String name = nameController.text;
                    final String birthday = birthdayController.text;
                    final String phoneNumber = phoneNumberController.text;
                    final String uid = FirebaseAuth.instance.currentUser!.uid;

                    createUser(
                      email: email,
                      name: name,
                      birthday: birthday,
                      phoneNumber: phoneNumber,
                      uid: uid,
                    );

                    Navigator.pop(context);
                  },
                  child: Text(
                    '가입하기',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createUser({
    required String email,
    required String name,
    required String birthday,
    required String phoneNumber,
    required String uid,
  }) async {
    final docRequest = FirebaseFirestore.instance.collection('user').doc();

    final json = {
      'email': email,
      'name': name,
      'birthday': birthday,
      'phoneNumber': phoneNumber,
      'uid': uid,
    };

    await docRequest.set(json);
  }
}
