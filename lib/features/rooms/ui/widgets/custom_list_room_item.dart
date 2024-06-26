import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/rooms/data/room_model.dart';
import 'package:playhub/features/rooms/ui/screens/room_details_screen.dart';

import '../../../../core/app_colors.dart';
import '../../cubits/rooms_cubit.dart';

class ListRoomItem extends StatelessWidget {
  const ListRoomItem({
    super.key, required this.room, required this.roomOwner, required this.roomId,
  });
  final RoomModel room;
  final UserModel roomOwner;
  final String roomId;
  @override
  Widget build(BuildContext context) {
    var cubit=context.read<RoomsCubit>();
    String currentUserType;
    return InkWell(
      onTap: (){
        cubit.getRoomPlayers(roomPlayers: room.players).then((_){
          if(roomOwner.id==LocalStorage().userData?.id){
            currentUserType="Owner";
          }else if(room.players.contains(LocalStorage().userData?.id)){
            currentUserType="Player";
          }else{
            currentUserType="Stranger";
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (con) => BlocProvider.value(
                value: context.read<RoomsCubit>(),
                  child: RoomDetailsScreen(room: room,roomOwner: roomOwner,roomId:roomId,currentUserType:currentUserType))));
        });
        },
      child: Container(
        margin: 10.padVertical,
        padding: 15.padAll,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10.0,
              offset: const Offset(3, 5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                roomOwner.image == null
                    ? CircleAvatar(
                  backgroundColor: AppColors.darkGreen,
                  radius: 35.r,
                  child: Text(
                    roomOwner.fullName == null
                        ? ''
                        : '${roomOwner.fullName![0]}',
                    style: const TextStyle(
                        fontSize: 30,
                        color: AppColors.white,
                      fontFamily: "Open Sans",
                    ),
                  ),
                )
                    : CircleAvatar(
                  backgroundColor: AppColors.darkGreen,
                  backgroundImage:
                  NetworkImage(roomOwner.image!),
                  radius: 35.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(roomOwner.fullName??"",
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold
                        ),),
                      Text("${room.playground}@${room.city}",
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children:  [
                          Text(room.date,
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                            ),),
                          Text(room.time,
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                            ),),
                        ],
                      ),
                      room.comment!=null?
                       Text(room.comment!,
                         style: TextStyle(
                           fontFamily: 'Open Sans',
                         ),):SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Image.asset("assets/images/level.png",width: 20.w,height: 19.h,),
                      ),
                      TextSpan(
                        text:"${room.level} Level",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                            color: AppColors.black
                          )
                      ),

                    ])),
                RichText(text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Image.asset("assets/images/time.png",width: 20.w,height: 19.h,),
                      ),
                      TextSpan(
                          text:"${room.period}",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: AppColors.black
                          )
                      ),

                    ])),
                RichText(text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Image.asset("assets/images/people.png",width: 20.w,height: 19.h,),
                      ),
                      TextSpan(
                          text:"${room.players.length+1}/${room.playersNum}",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: AppColors.black
                          )
                      ),

                    ])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}