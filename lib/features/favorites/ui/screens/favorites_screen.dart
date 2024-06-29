import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/features/favorites/ui/widgets/favorites_playgrounds.dart';
import 'package:playhub/features/favorites/ui/widgets/favorites_trainers.dart';
import 'package:playhub/generated/l10n.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).Favorites),
          bottom: TabBar(
            labelColor: AppColors.darkGreen,
            unselectedLabelColor: AppColors.grey,
            tabs: [
              Tab(text: S.of(context).Playgrounds),
              Tab(text: S.of(context).Trainers),
            ],
          ),
        ),
        body: const TabBarView(
                children: [
                  FavoritesPlaygrounds(),
                  FavoritesTrainers(),
                ],
              ),
      ),
    );
  }
}
