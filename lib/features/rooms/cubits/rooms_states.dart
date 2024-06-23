import 'package:playhub/features/authentication/data/user_model.dart';
import 'package:playhub/features/rooms/data/room_model.dart';

class RoomsStates{}

class RoomsInitialState extends RoomsStates{}

class DateChangeState extends RoomsStates{
  final String playDate;

  DateChangeState(this.playDate);
}
class TimeChangeState extends RoomsStates{
  final String playTime;

  TimeChangeState({required this.playTime});

}
class GetPlaygroundDataState extends RoomsStates{
  final List<String> playgrounds;

  GetPlaygroundDataState({required this.playgrounds});

}

class GetRoomsDataState extends RoomsStates{
  final List<RoomModel> rooms;
  final List<UserModel> roomOwners;
  final List<List<UserModel>> roomsPlayers;
  GetRoomsDataState({required this.roomsPlayers, required this.roomOwners, required this.rooms});
}

class CreateRoomsErrorState extends RoomsStates{}

class GetUserByIdState extends RoomsStates{
  final UserModel? user;

  GetUserByIdState({this.user});
}