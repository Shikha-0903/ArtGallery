import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'artd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sycs_proj_shikha/bottomNav.dart';
import 'package:url_launcher/url_launcher.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late String userName = 'User'; // Default value

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userData = await FirebaseFirestore.instance.collection('shikha').doc(uid).get();
        print(userData);
        if (userData.exists) {
          setState(() {
            userName = userData['name'];
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
        title: Text( "Hello $userName!! welcome to artGallery", style: TextStyle(
          fontSize: 30, fontFamily: "DancingScript", color: Colors.white,),),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Have a look on new collection!",style: TextStyle(fontSize: 20,fontFamily: "RobotoMono",fontWeight: FontWeight.bold,),),
            ),
            SizedBox(
              height: 400,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildArtworkItem(context: context,imageUrl: "images/img1.jpg",
                      title: "Banjaran",
                      artist: "untitled,\nSF64-064,1974",
                      description: "so authentic and elegant work",
                      money: "Rs.6000",
                      artworkId: "art1",
                      size:"70 x 70 cm",
                      medium: "paint",
                      frame: "not included"),
                  _buildArtworkItem(context: context,imageUrl: "https://rukminim2.flixcart.com/image/850/1000/jy7kyvk0/painting/h/2/g/p0670-paf-original-imafhnggafz8fcrd.jpeg?q=20&crop=false",
                      title: "Elizabeth Peyton",
                      artist: "Elio,O liver\n(call me by your Name)",
                      description: "popular for color combination",
                      money: "contact for price",
                      artworkId: "art2",
                      size: "30.5 x 45.4 cm",
                      medium: "print",
                      frame: "included"
                  ),
                  _buildArtworkItem(context: context,imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-QyEz-rlFl1pJtkKzWNifRYIPqaqr6eaygQ&s",
                      title: "Radha-Krishna",
                      artist: "Amrita Sher-Gil\n1940",
                      description: "its a blend of hindu religion",
                      money: "Rs.1 lakh",
                      artworkId: "art3",
                      size: "100 x 45.4 cm",
                      medium: "drawing",
                      frame: "included"),
                  _buildArtworkItem(context: context,imageUrl: "https://img.huffingtonpost.com/asset/56216c1a1400002b003c8777.jpeg?cache=bItG5koanL&ops=crop_0_111_772_693%2Cscalefit_720_noupscale",
                      title: "Human Mindset",
                      artist: "Jamini Roy\n1971",
                      description: "Humans Behaviour",
                      money: "Rs.18000",
                      artworkId: "art4",
                      size: "50.5 x 50.5 cm",
                      medium: "paint",
                      frame: "not included"
                  ),
                  _buildArtworkItem(context: context,imageUrl: "https://www.artisera.com/cdn/shop/files/Paintings_600x400.jpg?v=1613715757",
                      title: "Women",
                      artist: "shikha\n2000",
                      description: "Womens need freedom",
                      money: "Rs.9000",
                      artworkId: "art5",
                      size: "20.5 x 20 cm",
                      medium: "print",
                      frame: "not included"),
                  _buildArtworkItem(context: context,imageUrl: "https://rukminim2.flixcart.com/image/850/1000/jv5k2a80/painting/r/j/5/naag-203-e-new-anjani-art-gallery-original-imafg3rzdetxhgbc.jpeg?q=90&crop=false",
                      title: "sunny Bank",
                      artist: "satyam\n2010",
                      description: "Nature with blend of colors",
                      money: "free of cost",
                      artworkId: "art6",
                      size: "25 x 25 cm",
                      medium: "acrylic paint",
                      frame: "included"),
                  _buildArtworkItem(context: context,imageUrl: "https://raniartsandteak.co.in/cdn/shop/products/IMG_2718.jpg?v=1598702603",
                      title: "Rajasthani culture",
                      artist: "Mohammed Ali\n1880",
                      description: "Representing Rajasthan",
                      money: "Rs.50,000",
                      artworkId: "art7",
                      size: "71.55 x 70 cm",
                      medium: "painting",
                      frame: "included"),
                  _buildArtworkItem(context: context,imageUrl: "https://www.diamondartclub.com/cdn/shop/products/genius-billionaire-playboy-philanthropist-diamond-art-painting-33888589185217.jpg?v=1680445707&width=425",
                      title: "Iron Man",
                      artist: "Sneha\n2007",
                      description: "Marvel Character",
                      money: "Rs.10,000",
                      artworkId: "art8",
                      size: "43 x 34 cm",
                      medium: "mixed media",
                      frame: "not included"),
                  _buildArtworkItem(context: context,imageUrl: "images/img3.jpg",
                      title: "South Indians",
                      artist: "Pooja\n2001",
                      description: "full of literature",
                      money: "Rs.8000",
                      artworkId: "art9",
                      size: "10 x 10 cm",
                      medium: "mixed media",
                      frame: "included"),
                  _buildArtworkItem(context: context,imageUrl: "images/girl.jpg",
                      title: "Ballerina",
                      artist: "Enola Holmes\n1920",
                      description: "Ballet",
                      money: "Rs.2 lakh",
                      artworkId: "art10",
                      size: "30 x 45 cm",
                      medium: "print",
                      frame: "included"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 250, left: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "explore");
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.brown ,
                          ),
                          child: Text("explore more"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                   Image(image: AssetImage("images/sneha.jpg"), fit: BoxFit.cover,width: MediaQuery.of(context).size.width,),
                   Positioned(
                     left: 0,
                     right: 0,
                     bottom: 0,
                     child: Padding(
                       padding: EdgeInsets.all(0.8),
                       child: Column(
                         children: [
                           Text("Visit Our Most Searched art Gallery",style: TextStyle(fontSize: 30,color: Colors.white,fontFamily: "Anton"),),
                           Text("Follow this local galleries\n and artists you love",style: TextStyle(fontSize: 20,color: Colors.white),),
                           GestureDetector(
                             onTap: () {
                               _launchLocationUrl('https://www.google.com/maps/search/?api=1&query=Tate+Modern+London');
                             },
                             child: Text(
                               "Location: Tate Modern Gallery",
                               style: TextStyle(fontSize: 16, color: Colors.blue),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
              ],
            ),
            SizedBox(

            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _onItemTapped(context,index);
        },
      ),
    );
  }
  }
void _launchLocationUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
  void _onItemTapped(BuildContext context,int index) {
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
  //model for homepage listView
  Widget _buildArtworkItem({
    required String imageUrl,
    required String title,
    required String artist,
    required String description,
    required String money,
    required BuildContext context,
    required String artworkId,
    required String size,
    required String medium,
    required String frame,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle tap event here, e.g., navigate to a new page or show a dialog/modal
        _showArtworkDetails(context,imageUrl, title, artist, description, money,artworkId,size,medium,frame);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 200,
              width: 200, // Adjust width as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'By $artist',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              money,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showArtworkDetails(BuildContext context,
      String imageUrl,
      String title,
      String artist,
      String description,
      String money,
      String artworkId,
      String size,
      String medium,
      String frame) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtworkDetailsPage(
          imageUrl: imageUrl,
          title: title,
          artist: artist,
          description: description,
          money: money,
          artworkId: artworkId,
          size: size,
          medium: medium,
          frame: frame,
        ),
      ),
    );
  }