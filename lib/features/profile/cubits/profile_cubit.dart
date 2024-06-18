import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playhub/features/profile/cubits/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  File? selectedImage;

  Future pickImageFromGallery() async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage != null) {
        selectedImage = File(returnedImage.path);
        emit(ChangeProfilePhotoSuccessState());
      }
    } catch (e) {
      emit(ChangeProfilePhotoFailedState());
    }
  }

  Future pickImageFromCamera() async {
    try {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (returnedImage != null) {
        selectedImage = File(returnedImage.path);
        emit(ChangeProfilePhotoSuccessState());
      }
    } catch (e) {
      emit(ChangeProfilePhotoFailedState());
    }
  }
}
