import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/SearchScreen/CityFilterDialog.dart';
import 'CategoryButton.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  List<T> getCommonElements<T>(List<T> list1, List<T> list2) {
  // Convert lists to sets
  Set<T> set1 = list1.toSet();
  Set<T> set2 = list2.toSet();

  // Find the intersection of the two sets
  Set<T> intersection = set1.intersection(set2);

  // Convert the result back to a list
  return intersection.toList();
}

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
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
                            log("الحمار المتهور ضحي${AppCubit.get(context).items}");
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
                child: ListView.builder(
                      itemCount: AppCubit.get(context).items.length,
                      itemBuilder: (context, index) {
                        var item =
                            AppCubit.get(context).items[index];
                            print("reem");
                            log("dohaaaaaaaa&polaaaaaaaa$item");
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
                    )
              ),
            ],
          ),
          backgroundColor: Colors.black,
        );
      },
    );
  }
}
