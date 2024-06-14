import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  // String? img;
  // Future<void> getPlayGrounds() async {
  //   QuerySnapshot snap =
  //       await FirebaseFirestore.instance.collection('PlayGrounds').get();
  //   DocumentSnapshot docsnap = snap.docs.first;
  //   img = docsnap.get('Image');
  // }
}
