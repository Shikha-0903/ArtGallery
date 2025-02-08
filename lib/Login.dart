import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';



class secondShikha extends StatefulWidget {
  const secondShikha({super.key});

  @override
  State<secondShikha> createState() => _secondShikhaState();
}

class _secondShikhaState extends State<secondShikha> {
  String Email="",pass="";
  bool isVisible = false;
  bool _isPasswordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                "Login To ArtGallery!!",
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
                      top: MediaQuery.of(context).size.height*0.5,
                      left: 40,
                      right: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                Email = value;
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
                                Navigator.pushNamed(context, "register");
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text("Sign In",style: TextStyle(fontSize: 20,color: Colors.black),),
                            IconButton(
                                onPressed:  ()async{
                                  try {
                                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: Email,
                                        password: pass
                                    );
                                    Navigator.pushNamed(context, "home");
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('No user found for that email.')),
                                      );
                                    } else if (e.code == 'wrong-password') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Wrong password provided')),
                                      );
                                    }
                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: ${e.message}')),
                                      );
                                    }
                                  }
                                  catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                },
                                icon: Icon(Icons.arrow_circle_right_rounded,size: 60,color: Colors.black,)),
                            /*IconButton(
                              onPressed: _signInWithGoogle,
                              icon: Icon(Icons.login, size: 40),
                            ),
                            IconButton(
                              onPressed: _signInWithFacebook,
                              icon: Icon(Icons.facebook, size: 40),
                            ),*/

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
