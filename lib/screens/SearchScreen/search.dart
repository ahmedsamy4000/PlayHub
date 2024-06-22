import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/screens/SearchScreen/CityFilterDialog.dart';
import 'CategoryButton.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: AppCubit.get(context).searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: AppColors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: AppColors.black),
                    onChanged: (value) {
                      AppCubit.get(context).changeSearchQuery(value);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: AppColors.darkGreen),
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
                color: AppColors.white,
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
                      physics: BouncingScrollPhysics(),
                      itemCount: AppCubit.get(context).items.length,
                      itemBuilder: (context, index) {
                        final playground = AppCubit.get(context).items[index];
                        final name = playground['Name'];
                        final city = playground['City'];
                        final imageUrl = playground['Image'];
                        return Container(
                          width: 200.w,
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.green3,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.green2,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              imageUrl != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: AppColors.black.withOpacity(0.7),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    city,
                                    style: TextStyle(
                                      color: AppColors.black.withOpacity(0.4),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
          backgroundColor: AppColors.white,
        );
      },
    );
  }
}
