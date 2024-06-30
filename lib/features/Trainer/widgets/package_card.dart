import 'package:flutter/material.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/Trainer/widgets/trainer_update_package.dart';

// Define your custom widget
class PackageWidget extends StatelessWidget {
  final cubit;

  PackageWidget({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Your Packages',
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        cubit.packages.isEmpty
            ? const Padding(
                padding: EdgeInsets.only(top: 200),
                child: Center(
                  child: Text(
                    'You have no Packages yet.',
                    style: TextStyle(fontFamily: 'Open Sans', fontSize: 16),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.packages.length,
                itemBuilder: (context, index) {
                  final description = cubit.packages[index].description;
                  final price = cubit.packages[index].price;
                  final duration = cubit.packages[index].duration;

                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: FadeInSlide(
                        duration: 0.5 + (index / 10),
                        child: Card(
                          color: AppColors.green1,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Descrition: $description",
                                      style: const TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Duration: $duration",
                                      style: const TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Price: $price",
                                      style: const TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdatePackage(
                                                            Idx: index)));
                                          },
                                          child: const Text(
                                            'UPDATE',
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontFamily: 'Open Sans',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(width: 30),
                                        TextButton(
                                          onPressed: () {
                                            cubit.deletePackage(
                                                cubit.packagesId[index]);
                                          },
                                          child: const Text(
                                            'DELETE',
                                            style: TextStyle(
                                                color: AppColors.red,
                                                fontFamily: 'Open Sans',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
      ],
    );
  }
}
