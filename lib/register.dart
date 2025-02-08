import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late String email;
  late String pass;
  late String name;
  bool _isPasswordVisible = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _name= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                "Register To ArtGallery!!",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontFamily: "RubikScribble",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.4,
                      left: 40,
                      right: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            controller: _name,
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white54,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Name",
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            controller: _email,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white54,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Email",
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            controller: _pass,
                            onChanged: (value) {
                              setState(() {
                                pass = value;
                              });
                            },
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              fillColor: Colors.white54,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Password",
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "login");
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text("Sign Up",style: TextStyle(fontSize: 20,color: Colors.black),),
                            IconButton(
                                onPressed: ()async{
                                  try {
                                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: email,
                                      password: pass,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('user registered')),
                                    );
                                    User? user = FirebaseAuth.instance.currentUser;

                                    if (user != null) {
                                      // Use the user's UID as the document ID
                                      FirebaseFirestore.instance.collection("shikha").doc(user.uid).set({
                                        "name": _name.text,
                                        "email": _email.text,
                                        "password": _pass.text
                                      });
                                    } else {
                                      // Handle the case where the user is not logged in
                                      print("User is not logged in");
                                    }
                                    _email.clear();
                                    _pass.clear();
                                    _name.clear();
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('password provided is too weak')),
                                      );
                                    } else if (e.code == 'email-already-in-use') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('account already exists')),
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                icon: Icon(Icons.arrow_circle_right_rounded,size: 60,color: Colors.black,)),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
