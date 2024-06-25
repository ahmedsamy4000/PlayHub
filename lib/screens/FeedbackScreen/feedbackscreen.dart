import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  TextEditingController feedback = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.darkGreen,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "PlayHub",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.darkGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: AppColors.darkGreen),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "We hope you are enjoying using PlayHub. Your feedback is incredibly valuable to us as we strive to improve our services and your experience",
                          maxLines: 4,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Name : ${LocalStorage().userData!.fullName}"),
                          ),
                          Divider(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              controller: feedback,
                              maxLines: 7,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: "Your FeedBack",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: AppColors.darkGreen,
                                          width: 1))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: BlocBuilder<AppCubit, AppStates>(
                                builder: (context, state) {
                                  if (state is AddFeedBackLoadingState) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.darkGreen,
                                      ),
                                    );
                                  }
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.darkGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          minimumSize: const Size(200, 50)),
                                      onPressed: () async {
                                        BlocProvider.of<AppCubit>(context)
                                            .addFeedback(
                                                LocalStorage()
                                                    .userData!
                                                    .fullName!,
                                                feedback.text)
                                            .then((_) {
                                          feedback.clear();
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child: Container(
                                                    width: 300,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.white),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(15.0),
                                                      child: Center(
                                                        child: Text(
                                                          "We Recieved your Feedback Thank you..",
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        });
                                      },
                                      child: const Text(
                                        "Confirm",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
