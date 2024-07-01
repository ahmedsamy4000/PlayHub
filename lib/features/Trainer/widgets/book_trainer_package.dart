import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';

void showAnimatedDialog(
    BuildContext context,
    String? description,
    String? duration,
    String? price,
    String? trainerId,
    String? trainerName,
    int index) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: AppColors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: BookPackageScreen(
            description, duration, price, trainerId, trainerName, index),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  );
}

class BookPackageScreen extends StatelessWidget {
  final String? description;
  final String? duration;
  final String? price;
  final String? trainerId;
  final String? trainerName;
  final int index;
  const BookPackageScreen(this.description, this.duration, this.price,
      this.trainerId, this.trainerName, this.index,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: 400,
        height: 400,
        child: Card(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.green,
                          AppColors.grey,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Book Package",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text("Description : $description")),
                        Expanded(child: Text("Duration : $duration")),
                        Expanded(child: Text("Price : $price")),
                        Expanded(child: Center(
                          child: BlocBuilder<AppCubit, AppStates>(
                            builder: (context, state) {
                              if (state is AddNewOrderLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.green,
                                  ),
                                );
                              }
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(200, 50),
                                ),
                                onPressed: () async {
                                  PaymobResponse? response;
                                  PaymobPayment.instance
                                      .pay(
                                    context: context,
                                    currency: "EGP",
                                    amountInCents: "20000",
                                    onPayment: (responsee) {
                                      response = responsee;
                                    },
                                  )
                                      .then((_) {
                                    if (response != null &&
                                        response!.success == true) {
                                      AppCubit.get(context)
                                          .addPackageBooking(
                                              trainerId.toString(),
                                              trainerName.toString(),
                                              index)
                                          .then((_) {
                                        AppCubit.get(context)
                                            .getPlayerBookedPackage();

                                        Navigator.pop(context);
                                      });
                                    }
                                  });
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              );
                            },
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
