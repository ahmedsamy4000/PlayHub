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

class CreateRoomsErrorState extends RoomsStates{}