import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_login_button.dart';
import 'package:playhub/features/authentication/ui/widgets/login_divider.dart';
import 'package:playhub/features/rooms/cubits/rooms_cubit.dart';
import 'package:playhub/features/rooms/data/room_model.dart';
import 'package:playhub/features/rooms/ui/screens/rooms_screen.dart';

import '../../../../core/app_colors.dart';
import '../widgets/players_list_item.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({
    super.key,
    required this.room,
    required this.roomOwner,
    required this.roomId,
    required this.currentUserType,
  });

  final RoomModel room;
  final UserModel roomOwner;
  final String roomId;
  final String currentUserType;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<RoomsCubit>();
    return Scaffold(
      body: Column(
        children: [
          Container(
            //height: 380.h,
            padding: 30.padAll,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.r),bottomRight: Radius.circular(30.r),),

            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                "assets/images/backgroundPlayground.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: 18.padAll,
                padding: 15.padAll,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: AppColors.grey
                  ),
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PlayersListItem(item: roomOwner, owner: true),
                        SizedBox(width: 10.w),
                        Text(
                          roomOwner.fullName ?? "",
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    Container(
                      margin: 10.padRight,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: TitleText(text: "Playground"),flex: 3,),
                            Flexible(child: DetailsText(text: "${room.playground}@${room.city}"),flex: 4,),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: TitleText(text: "Date and Time"),flex: 3,),
                            Flexible(child: DetailsText(text: "${room.date}@${room.time}"),flex: 4,),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: TitleText(text: "Category"),flex: 3,),
                            Flexible(child: DetailsText(text: room.category),flex: 4,),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: TitleText(text: "Playing Level"),flex: 3,),
                            Flexible(child: DetailsText(text: room.level),flex: 4,),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: TitleText(text: "Match period"),flex: 3,),
                            Flexible(child: DetailsText(text: room.period),flex: 4,),
                          ],
                        ),
                        room.comment == null ? SizedBox.shrink() :
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: TitleText(text: "Comment"),flex: 3,),
                            Flexible(child: DetailsText(text: room.comment!),flex: 4,),
                          ],
                        ),

                        SizedBox(height: 20.h),
                        cubit.players.isEmpty ? SizedBox.shrink() : TitleText(text: "Players"),
                        cubit.players.isEmpty
                            ? SizedBox.shrink()
                            : SizedBox(
                          height: 100.h, // Adjust this height as necessary
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: cubit.players.length,
                            itemBuilder: (con, index) {
                              return PlayersListItem(item: cubit.players[index]);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(width: 10.w);
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        currentUserType == "Stranger"
                            ? LoginButton(
                          onTap: () {
                            cubit.playerJoinRoom(id: roomId, room: room).then((_) {
                              Navigator.pop(context);                            });
                          },
                          text: "Join",
                          gradiantColor: AppColors.loginGradiantColorButton,
                          tapedGradiantColor: AppColors.loginGradiantColorButtonTaped,
                        )
                            : currentUserType == "Player"
                            ? LoginButton(
                          onTap: () {
                            cubit.playerUnJoinRoom(id: roomId, room: room).then((_) {
                              Navigator.pop(context);
                            });
                          },
                          text: "Cancel",
                          gradiantColor: AppColors.loginGradiantColorButton,
                          tapedGradiantColor: AppColors.loginGradiantColorButtonTaped,
                        )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),



    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({
    super.key, required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize:17.sp));
  }
}

class DetailsText extends StatelessWidget {
  const DetailsText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${text}",
      style: TextStyle(fontSize: 17.sp, color: AppColors.grey),
    );
  }
}

