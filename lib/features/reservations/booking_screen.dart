import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/reservations/playground_orders.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    cubit.getOwnerPlaygrounds();
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Playgrounds'),
          ),
          body: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cubit.ownerPlaygrounds.length,
            itemBuilder: (context, index) {
              final playground = cubit.ownerPlaygrounds[index];
              final name = playground.name;
              final city = playground.city;
              final imageUrl = playground.image;
              final playgroundId = cubit.ownerPlaygroundsIds[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PlaygroundOrdersScreen(id: playgroundId, name: name)
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: FadeInSlide(
                    duration: 0.5 + (index / 10),
                    child: Card(
                      color: AppColors.white,
                      child: Row(
                        children: [
                          imageUrl != ''
                              ? Image.network(imageUrl,
                                  width: 120, height: 100, fit: BoxFit.cover)
                              : const Icon(Icons.image, size: 100),
                          10.horizontalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${playground.region}, $city",
                                style: const TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 15,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
