import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/SearchScreen/CityFilterDialog.dart';
import 'CategoryButton.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: AppCubit.get(context).searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        AppCubit.get(context).changeSearchQuery(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CityFilterDialog(
                            onCitySelected: (city) {
                              AppCubit.get(context).changeSelectedCity(city);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.black,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoryButton(
                          text: "All",
                          isSelected:
                              AppCubit.get(context).selectedCategory == "All",
                          onTap: () {
                            AppCubit.get(context).changeSelectedCategory("All");
                          },
                        ),
                        CategoryButton(
                          text: "Category one",
                          isSelected: AppCubit.get(context).selectedCategory ==
                              "Category one",
                          onTap: () {
                            AppCubit.get(context)
                                .changeSelectedCategory("Category one");
                          },
                        ),
                        CategoryButton(
                          text: "Category two",
                          isSelected: AppCubit.get(context).selectedCategory ==
                              "Category two",
                          onTap: () {
                            AppCubit.get(context)
                                .changeSelectedCategory("Category two");
                          },
                        ),
                        // Add more categories as needed
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('PlayGrounds')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var items = snapshot.data!.docs.where((doc) {
                        var itemData = doc.data() as Map<String, dynamic>;
                        var matchesSearchQuery =
                            AppCubit.get(context).searchQuery.isEmpty ||
                                itemData['Name'].toLowerCase().contains(
                                    AppCubit.get(context)
                                        .searchQuery
                                        .toLowerCase());
                        var matchesCity =
                            AppCubit.get(context).selectedCity == "All" ||
                                itemData['City'] ==
                                    AppCubit.get(context).selectedCity;
                        // print(matchesSearchQuery && matchesCity);
                        return matchesSearchQuery && matchesCity;
                      }).toList();

                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item =
                              items[index].data() as Map<String, dynamic>;
                          return ListTile(
                            leading: Image.network(item['Image']),
                            title: Text(item['Name'],
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(item['Region'],
                                style: TextStyle(color: Colors.white70)),
                            // trailing: Text(item['City']),
                            //     style: TextStyle(color: Colors.white)),
                            tileColor: Colors.grey[900],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black,
          );
        },
      ),
    );
  }
}
