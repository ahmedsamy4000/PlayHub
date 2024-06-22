import 'package:flutter/material.dart';
import 'package:playhub/core/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final VoidCallback onTap;

  const CategoryCard({
    required this.imageUrl,
    required this.name,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
          ],
          border: Border.all(color: AppColors.darkGreen, width: 2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.green3,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(25.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Positioned(
            //   right: 8,
            //   top: 8,
            //   child: CircleAvatar(
            //     backgroundColor: Colors.green,
            //     radius: 15,
            //     child: Image.asset(
            //       'assets/icons/add.png',
            //       color: Colors.white,
            //       height: 15,
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 5),
            //     child: Text(
            //       name,
            //       style: TextStyle(
            //         color: Colors.black.withOpacity(0.7),
            //         fontWeight: FontWeight.bold,
            //         fontSize: 16.0,
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
