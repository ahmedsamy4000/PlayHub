import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/categories/ui/screens/category_screen.dart';
import 'package:playhub/features/favorites/ui/screens/favorites_screen.dart';
import 'package:playhub/features/favorites/ui/widgets/favorites_playgrounds.dart';
import 'package:playhub/generated/l10n.dart';
import 'package:playhub/screens/FeedbackScreen/feedbackscreen.dart';
import 'package:playhub/screens/HomeScreen/CategoryCard.dart';
import 'package:playhub/screens/HomeScreen/floatingactionmenu.dart';
import 'package:playhub/screens/playgroundScreen/playgroundscreen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return Scaffold(
      backgroundColor: AppColors.greenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.greenBackground,
        title: Text(
          'PlayHub',
          textAlign: TextAlign.left,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedBackScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.feedback_outlined,
              color: AppColors.darkGreen,
            ),
          ),
          IconButton(
            onPressed: () {
              cubit.getFavoritesPlaygrounds().then((_) {
                if (cubit.state is GetFavoritesPlaygroundsSuccessState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                }
              });
            },
            icon: Icon(
              Icons.favorite,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: FloatingActionMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Welcome Reem Hatem'),
              const SizedBox(height: 16),
              Text(
                S.of(context).Categories,
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
                    final categories = snapshot.data!.docs;

                    return SizedBox(
                      height: 320.0,
                      child: PageView.builder(
                        itemCount: categories.length,
                        physics: const BouncingScrollPhysics(),
                        padEnds: false,
                        pageSnapping: true,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final name = category['Name'];
                          final imageUrl = category['Image'];
                          final categoryId = category['Id'];

                          return CategoryCard(
                            imageUrl: imageUrl ?? '',
                            name: name,
                            onTap: () {
                              cubit.getFavoritesPlaygrounds().then((_) {
                                if (cubit.state
                                is GetFavoritesPlaygroundsSuccessState) {
                                  cubit
                                      .getCategoryPlaygrounds(categoryId)
                                      .then((_) {
                                    if (cubit.state
                                    is GetCategoryPlaygroundsSuccessState) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryScreen(
                                            categoryId: categoryId,
                                            name: name,
                                            favorites: cubit.favoritesId,
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                }
                              });
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
              SizedBox(height: 16),
              Text(
                S.of(context).Playgrounds,
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
                                        name, city, imageUrl, playgroundId, playground['Map'])));
                          },
                          child: Container(
                            width: 200.w,
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.green2,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.green2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    imageUrl != null
                                        ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                        child: Image.network(
                                          imageUrl,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                        : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.image, size: 70),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          city,
                                          style: TextStyle(
                                            color: AppColors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.green1,
                                    radius: 15,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: AppColors.white,
                                        size: 15,
                                      ),
                                      onPressed: () {
                                        cubit.addPlaygroundToFavorites(
                                            playgroundId);
                                      },
                                    ),
                                  ),
                                ),
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
      ),
    );
  }
}
