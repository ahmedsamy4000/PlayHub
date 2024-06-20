class RoomsStates{}

class RoomsInitialState extends RoomsStates{}

class DateChangeState extends RoomsStates{
  final String playDate;

  DateChangeState(this.playDate);
}
class GetPlaygroundDataState extends RoomsStates{
  final List<String> playgrounds;

  GetPlaygroundDataState({required this.playgrounds});

}