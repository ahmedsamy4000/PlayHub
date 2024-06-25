import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';

class FeedbacksScreen extends StatelessWidget {
  const FeedbacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    cubit.getFeedbacks();
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Feedbacks',
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold),
            ),
            //meraaaaaa
          ),
          body: ListView.builder(
              itemCount: cubit.feedbacks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.green,
                    color: AppColors.darkGreen,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User Name: ${cubit.feedbacks[index]['UserName']}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "User Email: ${cubit.feedbacks[index]['UserEmail']}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Message: ${cubit.feedbacks[index]['Feedback']}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
