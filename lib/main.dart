import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/loading.dart';
import 'package:test_app/screens/game/guessing.dart';
import 'package:test_app/screens/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Test App',
              theme: ThemeData(
                primaryColor: kPrimaryColor,
                textTheme:
                    Theme.of(context).textTheme.apply(bodyColor: kTextColor),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: HomePage(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return new MaterialApp(
          title: 'MediaQuery Demo',
          theme: new ThemeData(
            primarySwatch: Colors.red,
          ),
          home: new Loading(),
        );
      },
    );
  }
}
