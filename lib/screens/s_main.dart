import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("main"),
              TextButton(onPressed: (){
                Navigator.of(context, rootNavigator: true)
                    .pushNamed("/camera");
              }, child: Text("move to camera"))
            ],
          )
        ),
      ),
    );
  }
}
