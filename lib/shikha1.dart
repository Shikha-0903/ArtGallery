import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image(
                image: AssetImage("images/front1.jpg"),
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding:EdgeInsets.only(top:150),
                    child: Text("Creativity requires the courage,\nlets showcase our Creativity",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: "DancingScript",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "login");
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.brown ,
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10), // Adjusted padding
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(fontSize: 30), // Adjusted font size
                      ),
                    ),
                  ),
                ],
              ),


            ],
          );
        },
      ),
    );
  }
}

