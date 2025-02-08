import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sycs_proj_shikha/bottomNav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User_data extends StatefulWidget {
  const User_data({Key? key}) : super(key: key);

  @override
  State<User_data> createState() => _UserState();
}

class _UserState extends State<User_data> {
  int _selectedIndex = 2;
  late String userName = 'User'; 
  late String email='';

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userData = await FirebaseFirestore.instance.collection('shikha').doc(uid).get();
        print(userData);
        if (userData.exists) {
          setState(() {
            userName = userData['name'];
            email= userData['email'];
          });
        }
      }
    } catch (error) {
      print('Error fetching user name: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello $userName",style: TextStyle(fontFamily: "RobotoMono"),),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _onItemTapped(context, index);
        },
      ),
      bottomSheet: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Icon(Icons.person,size: 100,color: Colors.grey,),
                  Text("$email",style: TextStyle(fontSize: 25),),
              SizedBox(height: 20,),
              Text("we hope that you enjoyed our ArtGallery"),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.brown ,
                ),
                child: Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'home');
        break;
      case 1:
        Navigator.pushNamed(context, 'search');
        break;
      case 2:
        Navigator.pushNamed(context, 'user');
        break;
      default:
        break;
    }
  }

  // Inside the _logout method in User_data widget
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Reset the currentUserUid in the FavoriteState provider
      //Provider.of<FavoriteState>(context, listen: false).resetCurrentUserUid('');
      Navigator.pushNamed(context, 'login');
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
