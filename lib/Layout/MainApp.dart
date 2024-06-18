import 'package:flutter/material.dart';
import 'package:playhub/screens/HomeScreen/home.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int currentIdx = 0;
  List<Widget> pages = [
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlayHub', textAlign: TextAlign.left,),
      ),
      body: pages[currentIdx],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.search),
        label: Text('Browse all courts'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdx,
        onTap: (index){
          setState(() {
            currentIdx = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: "1",
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_call),
            label: "1",
            ),
        ],
        ),
    );
  }
}