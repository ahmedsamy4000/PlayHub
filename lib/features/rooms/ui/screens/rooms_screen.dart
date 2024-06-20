import 'package:flutter/material.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/features/rooms/ui/screens/add_room_screen.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rooms"),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Text("All"),
              ),
              Tab(
                child: Text("Created by me"),
              ),
              Tab(
                child: Text("Joined"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
        children: [
        Container(
          margin: 10.padVertical,
          padding: 10.padAll,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(3, 5),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: const Offset(-1, -1),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/login.jpg"),
                  ),
                  const SizedBox(width: 10), // Add spacing between the avatar and the text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mera Fahmy"),
                        const Text("Playground Name"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Date "),
                            Text(" remain time"),
                          ],
                        ),
                        const Text("Description"),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Level "),
                  Text("Match time"),
                  Text("People count"),
                ],
              ),
            ],
          ),
        ),
        ],
      ),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
        
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddRoomScreen()));

          },
          child: Text("Create Room"),
        ),
      ),
    );
  }
}
