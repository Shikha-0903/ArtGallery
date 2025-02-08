import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sycs_proj_shikha/artd.dart';
import 'package:sycs_proj_shikha/artdetail.dart';
import 'package:sycs_proj_shikha/explore_more.dart';
import 'package:sycs_proj_shikha/homepage.dart';
import 'package:sycs_proj_shikha/register.dart';
import 'package:sycs_proj_shikha/shikha1.dart';
import 'package:sycs_proj_shikha/Login.dart';
import "user.dart";
import 'package:provider/provider.dart';
import "package:sycs_proj_shikha/search.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  app = await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey:dotenv.env['FIREBASE_API']!,
      appId:"1:998264731262:android:ee7ca055863d8777838a2f",
      messagingSenderId:"998264731262",
      projectId: "artgallery-1e47c",
    ),
  );
  auth = FirebaseAuth.instance;
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    String currentUserUid = user?.uid ?? '';
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteState(currentUserUid)),
        ChangeNotifierProvider(create: (_) => Favorite_State(currentUserUid)),
      ],
      child: MyApp(),
    ));
  });
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "first",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'home':
            return PageRouteBuilder(  
              pageBuilder: (_, __, ___) => HomePage(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              },
            );
          case 'explore':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => Explore_More(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              },
            );
          case 'user':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => User_data(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              },
            );
          case "login":
            return PageRouteBuilder(
              pageBuilder: (_,__,___) =>secondShikha(),
              transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(
                opacity: anim,
                child: child,
        );
        },
        );
          case "register":
            return PageRouteBuilder(
              pageBuilder: (_,__,___) =>Registration(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              },
            );
          case "first":
            return PageRouteBuilder(
              pageBuilder: (_,__,___) =>Home(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              },
            );
          case "search":
            return PageRouteBuilder(
              pageBuilder: (_,__,___) =>SearchPage(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              },
            );
          default:
            return null;
        }
      },
    );
  }
}