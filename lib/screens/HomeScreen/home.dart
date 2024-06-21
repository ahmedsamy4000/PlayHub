import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/features/categories/ui/screens/category_screen.dart';
import 'package:playhub/models/playgroundmodel.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Reem Hatem'),
            const SizedBox(height: 16),
            Text(
              'Categories',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Categories')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final playgrounds = snapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: playgrounds.map((playground) {
                        final name = playground['Name'];
                        final imageUrl = playground['Image'];
                        final categoryId = playground['Id'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryScreen(
                                      categoryId: categoryId, name: name)),
                            );
                          },
                          child: Container(
                            width: 200,
                            margin: EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageUrl != null
                                    ? Image.network(imageUrl,
                                        width: 200,
                                        height: 150,
                                        fit: BoxFit.cover)
                                    : Icon(Icons.image, size: 150),
                                SizedBox(height: 8),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
            SizedBox(height: 16),
            Text(
              'Playgrounds',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('PlayGrounds')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final playgrounds = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: playgrounds.length,
                    itemBuilder: (context, index) {
                      final playground = playgrounds[index];
                      final name = playground['Name'];
                      final city = playground['City'];
                      final imageUrl = playground['Image'];
                      final playgroundId = playground.id;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayGroundScreen(
                                      name, city, imageUrl, playgroundId)));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              imageUrl != null
                                  ? Image.network(imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover)
                                  : Icon(Icons.image, size: 100),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(city),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  cubit.addPlaygroundToFavorites(playgroundId);
                                },
                                icon: const Icon(Icons.favorite),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
