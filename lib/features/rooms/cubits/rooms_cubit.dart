import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:playhub/features/rooms/cubits/rooms_states.dart';
import 'package:playhub/features/rooms/data/playgroung_model.dart';


class RoomsCubit extends Cubit<RoomsStates> {
  RoomsCubit() : super(RoomsInitialState());

  void pickDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    emit(DateChangeState(formattedDate));
  }

  void getPlaygrounds() async {
    try {
      var data = await FirebaseFirestore.instance.collection('PlayGrounds').get();

      List<String> playgrounds = [];
      for (var document in data.docs) {
        Playground playground = Playground.fromJson(document.data());
        playgrounds.add(playground.name);
      }
      emit(GetPlaygroundDataState(playgrounds: playgrounds));
    } catch (e) {
      print('Error retrieving playgrounds: $e');
    }
  }

}
