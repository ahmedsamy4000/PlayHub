import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';

void showAnimatedDialog(
    BuildContext context,
    String? playGrounId,
    String playGroundName,
    String? name,
    String? time,
    String? date,
    String? numOfPlayers,
    String? price) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: BookScreen(
            playGrounId, playGroundName, name, time, date, numOfPlayers, price),
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

class BookScreen extends StatelessWidget {
  final String? playGroundId;
  final String? playGroundName;
  final String? name;
  final String? time;
  final String? date;
  final String? numOfPlayers;
  final String? price;
  const BookScreen(this.playGroundId, this.playGroundName, this.name, this.time,
      this.date, this.numOfPlayers, this.price,
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
                          Colors.green,
                          Colors.grey,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "$playGroundName",
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
                        Expanded(child: Text("Name : $name")),
                        Expanded(child: Text("Time : $time")),
                        Expanded(
                            child: Text("Number of Players : $numOfPlayers")),
                        Expanded(child: Text("Price : $price")),
                        Expanded(child: Center(
                          child: BlocBuilder<AppCubit, AppStates>(
                            builder: (context, state) {
                              if (state is AddNewOrderLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                );
                              }
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      minimumSize: const Size(200, 50)),
                                  onPressed: () async {
                                    PaymobResponse? response;
                                    PaymobPayment.instance
                                        .pay(
                                            context: context,
                                            currency: "EGP",
                                            amountInCents: "20000",
                                            onPayment: (responsee) {
                                              response = responsee;
                                            })
                                        .then((_) {
                                      if (response != null) {
                                        print(response!.success);
                                        if (response!.success != false) {
                                          BlocProvider.of<AppCubit>(context)
                                              .addNewOrder(
                                                  playGroundId,
                                                  int.parse(time.toString()),
                                                  date,
                                                  true)
                                              .then((_) {
                                            Navigator.pop(context);
                                            BlocProvider.of<AppCubit>(context)
                                                .getPlaygroundById(
                                                    playGroundId!, date!);
                                          });
                                        }
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "Confirm",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ));
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
